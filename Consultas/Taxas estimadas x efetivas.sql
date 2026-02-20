DECLARE
  @Data_Inicial DateTime,
  @Data_Final DateTime,
  @IdMoeda_Corrente Integer

SET @Data_Inicial = '2025-01-01'
SET @Data_Final = '2026-12-31'
SET @IdMoeda_Corrente = (SELECT IdMoeda FROM cad_Moeda WHERE Moeda_Corrente = 1)

;WITH Taxas_Processo AS (
SELECT
  Txs.IdLogistica_Taxa,
  Txs.IdTaxa_Logistica_Exibicao,
  Lft.IdRegistro_Financeiro,
  ROUND(ROUND(Txs.Valor
    * CASE
    WHEN Txs.IdMoeda = Rfn.IdMoeda THEN 1
    WHEN Lfc.IdMoeda_Origem = Txs.IdMoeda AND Lfc.IdMoeda_Destino = Rfn.IdMoeda THEN Lfc.Fator_Conversao
    WHEN Lfc.IdMoeda_Origem = Rfn.IdMoeda AND Lfc.IdMoeda_Destino = Txs.IdMoeda AND COALESCE(Lfc.Fator_Conversao, 0) <> 0 THEN ROUND(1 / Lfc.Fator_Conversao, 6)
    END, 2) / Rfn.Valor_Total * 100, 6) AS Percentual,
  Txs.Natureza
FROM
  (SELECT
    Ltx.IdLogistica_Taxa,
    Ltx.IdTaxa_Logistica_Exibicao,
    Ltx.IdRegistro_Pagamento AS IdRegistro_Financeiro,
    Ltx.IdMoeda_Pagamento AS IdMoeda,
    -Ltx.Valor_Pagamento_Total AS Valor,
    0 AS Natureza
  FROM
    mov_Logistica_Taxa Ltx
  WHERE
    Ltx.IdRegistro_Pagamento IS NOT NULL
  AND
    Ltx.Valor_Pagamento_Total <> 0
  UNION ALL
  SELECT
    Ltx.IdLogistica_Taxa,
    Ltx.IdTaxa_Logistica_Exibicao,
    Ltx.IdRegistro_Recebimento AS IdRegistro_Financeiro,
    Ltx.IdMoeda_Recebimento AS IdMoeda,
    Ltx.Valor_Recebimento_Total AS Valor,
    1 AS Natureza
  FROM
    mov_Logistica_Taxa Ltx
  WHERE
    Ltx.IdRegistro_Recebimento IS NOT NULL
  AND
    Ltx.Valor_Recebimento_Total <> 0
  ) AS Txs
JOIN
  mov_Logistica_Fatura Lft ON Lft.IdRegistro_Financeiro = Txs.IdRegistro_Financeiro
JOIN
  mov_Registro_Financeiro Rfn ON Rfn.IdRegistro_Financeiro = Lft.IdRegistro_Financeiro
LEFT OUTER JOIN
  mov_Logistica_Fatura_Conversao Lfc ON Lfc.IdLogistica_Fatura = Lft.IdRegistro_Financeiro
    AND ((Lfc.IdMoeda_Origem = Txs.IdMoeda AND Lfc.IdMoeda_Destino = Rfn.IdMoeda)
      OR (Lfc.IdMoeda_Origem = Rfn.IdMoeda AND Lfc.IdMoeda_Destino = Txs.IdMoeda))
WHERE
  Rfn.Valor_Total <> 0
), Percentuais AS (
SELECT
  Txs.IdLogistica_Taxa,
  Txs.IdTaxa_Logistica_Exibicao,
  Txs.IdRegistro_Financeiro,
  Txs.Natureza,
  CASE
    WHEN ROW_NUMBER() OVER(PARTITION BY Txs.IdRegistro_Financeiro ORDER BY Txs.Percentual DESC, Txs.IdLogistica_Taxa) = 1 THEN
      CASE
        WHEN Txs.Percentual < 0 THEN Txs.Percentual - (100 - ABS(Ttl.Percentual_Total))
        ELSE Txs.Percentual + (100 - ABS(Ttl.Percentual_Total))
      END
    ELSE Txs.Percentual
  END AS Percentual
FROM
  Taxas_Processo Txs
LEFT OUTER JOIN
  (SELECT
    Txs.IdRegistro_Financeiro,
    SUM(Txs.Percentual) AS Percentual_Total
  FROM
    Taxas_Processo Txs
  GROUP BY
    Txs.IdRegistro_Financeiro
  ) Ttl ON Ttl.IdRegistro_Financeiro = Txs.IdRegistro_Financeiro
), Taxas_Calculadas AS (
SELECT
  Prc.IdLogistica_Taxa,
  Prc.IdTaxa_Logistica_Exibicao,
  Prc.Natureza,
  Ffn.IdRegistro_Financeiro,
  Mfn.IdMovimentacao_Financeira,
  Mfn.Valor_Corrente AS Total_Corrente,
  ABS(ROUND((Prc.Percentual * Ffb.Valor_Total * Ffb.Fator_Conversao * Mfn.Fator_Corrente) / 100, 2)) AS Valor_Corrente
FROM
  mov_Movimentacao_Financeira Mfn
JOIN
  mov_Fatura_Financeira_Baixa Ffb ON Ffb.IdMovimentacao_Financeira = Mfn.IdMovimentacao_Financeira
JOIN
  mov_Fatura_Financeira Ffn ON Ffn.IdFatura_Financeira = Ffb.IdFatura_Financeira
JOIN
  Percentuais Prc ON Prc.IdRegistro_Financeiro = Ffn.IdRegistro_Financeiro
WHERE
  Mfn.Valor > 0
AND 
  Mfn.IdConta_Corrente <> 17 /* (BANCO BAIXAS CUSTO FINANCEIRO)*/
), Taxas AS (
  SELECT
  Txs.IdMovimentacao_Financeira,
  Txs.IdLogistica_Taxa,
  Txs.IdTaxa_Logistica_Exibicao,
  Txs.IdRegistro_Financeiro,
  CASE
    WHEN ROW_NUMBER() OVER(PARTITION BY Txs.IdMovimentacao_Financeira ORDER BY Txs.Valor_Corrente DESC, Txs.IdLogistica_Taxa) = 1 THEN
    Txs.Valor_Corrente + (Txs.Total_Corrente - Ttl.Total)
    ELSE
    Txs.Valor_Corrente
  END AS Valor
  FROM
  Taxas_Calculadas Txs
  JOIN
  (SELECT
    Tcl.IdMovimentacao_Financeira,
    SUM(Tcl.Valor_Corrente) AS Total
  FROM
    Taxas_Calculadas Tcl
  GROUP BY
    Tcl.IdMovimentacao_Financeira
  ) Ttl ON Ttl.IdMovimentacao_Financeira = Txs.IdMovimentacao_Financeira
), Variacoes AS (
SELECT
  Ltx.IdLogistica_House,
  Ltx.IdLogistica_Taxa,
  Ltx.IdMoeda_Pagamento,
  Ltx.IdMoeda_Recebimento,
  Ltx.IdRegistro_Pagamento,
  Ltx.IdRegistro_Recebimento,
  Tle.Nome AS Taxa,
  Ltx.Valor_Pagamento_Total,
  Ltx.Valor_Recebimento_Total,
  CASE
    WHEN Ltx.IdMoeda_Pagamento = @IdMoeda_Corrente THEN 1
    WHEN Fpg.IdMoeda_Origem = Ltx.IdMoeda_Pagamento AND Fpg.IdMoeda_Destino = @IdMoeda_Corrente THEN Fpg.Fator_Conversao
    WHEN Fpg.IdMoeda_Origem = @IdMoeda_Corrente AND Fpg.IdMoeda_Destino = Ltx.IdMoeda_Pagamento AND ISNULL(Fpg.Fator_Conversao, 0) <> 0 THEN ROUND(1 / Fpg.Fator_Conversao, 6)
    ELSE 0
  END AS Fator_Pagamento,
  CASE
    WHEN Ltx.IdMoeda_Recebimento = @IdMoeda_Corrente THEN 1
    WHEN Frc.IdMoeda_Origem = Ltx.IdMoeda_Recebimento AND Frc.IdMoeda_Destino = @IdMoeda_Corrente THEN Frc.Fator_Conversao
    WHEN Frc.IdMoeda_Origem = @IdMoeda_Corrente AND Frc.IdMoeda_Destino = Ltx.IdMoeda_Recebimento AND ISNULL(Frc.Fator_Conversao, 0) <> 0 THEN ROUND(1 / Frc.Fator_Conversao, 6)
    ELSE 0
  END AS Fator_Recebimento,
  CASE
    WHEN Ffp.Data_Pagamento > Lfr.Data_Faturamento THEN Ffp.Data_Pagamento
    ELSE Lfr.Data_Faturamento
  END AS Data,
  COALESCE(NULLIF(Lhs.Referencia_Externa, ''), Lhs.Numero_Processo) AS Referencia
FROM
  mov_Logistica_Taxa Ltx
JOIN
  mov_Logistica_House Lhs ON Lhs.IdLogistica_House = Ltx.IdLogistica_House
JOIN
  cad_Taxa_Logistica_Exibicao Tle ON Tle.IdTaxa_Logistica_Exibicao = Ltx.IdTaxa_Logistica_Exibicao
JOIN
  cad_Taxa_Logistica Tlg ON Tlg.IdTaxa_Logistica = Tle.IdTaxa_Logistica
LEFT OUTER JOIN
  mov_Logistica_Fatura_Conversao Fpg ON Fpg.IdLogistica_Fatura = Ltx.IdRegistro_Pagamento
    AND ((Fpg.IdMoeda_Origem = Ltx.IdMoeda_Pagamento AND Fpg.IdMoeda_Destino = @IdMoeda_Corrente)
    OR (Fpg.IdMoeda_Origem = @IdMoeda_Corrente Fpg AND.IdMoeda_Destino = Ltx.IdMoeda_Pagamento))
LEFT OUTER JOIN
  mov_Logistica_Fatura_Conversao Frc ON Frc.IdLogistica_Fatura = Ltx.IdRegistro_Recebimento
    AND ((Frc.IdMoeda_Origem = Ltx.IdMoeda_Recebimento AND Frc.IdMoeda_Destino = @IdMoeda_Corrente)
    OR (Frc.IdMoeda_Origem = @IdMoeda_Corrente AND Frc.IdMoeda_Destino = Ltx.IdMoeda_Recebimento))
LEFT OUTER JOIN
  vis_Logistica_Fatura Lfr ON Lfr.IdRegistro_Financeiro = Ltx.IdRegistro_Recebimento
LEFT OUTER JOIN
  mov_Fatura_Financeira Ffp ON Ffp.IdRegistro_Financeiro = Ltx.IdRegistro_Pagamento
WHERE
  Tlg.Tributavel = 0
AND
  (Ltx.Tipo_Pagamento <> 1 /* SEM COBRANÇA */)
AND
  (Ltx.Tipo_Recebimento <> 1 /* SEM COBRANÇA */)
AND
  ((ISNULL(Ltx.Valor_Pagamento_Total, 0) <> ISNULL(Ltx.Valor_Recebimento_Total, 0))
  OR
  (ISNULL(Ltx.IdMoeda_Pagamento, 0) <> ISNULL(Ltx.IdMoeda_Recebimento, 0))
  OR
  ((ISNULL(Ltx.IdMoeda_Pagamento, 0) = ISNULL(Ltx.IdMoeda_Recebimento, 0))
  AND (ISNULL(Ltx.Valor_Pagamento_Total, 0) = ISNULL(Ltx.Valor_Recebimento_Total, 0))))
AND
  (CASE
    WHEN Ffp.Data_Pagamento > Lfr.Data_Faturamento THEN Ffp.Data_Pagamento
    ELSE Lfr.Data_Faturamento
  END BETWEEN @Data_Inicial AND @Data_Final)
  ), Comissao_Agente AS (
SELECT
  Txs.IdMovimentacao_Financeira,
  Txs.IdLogistica_Taxa,
  Txs.Valor
FROM
  Taxas Txs
WHERE
  Txs.IdTaxa_Logistica_Exibicao = 11 /* COMISSÃO AGENTE */
)

SELECT
  Lft.Numero AS Numero_Fatura,
  Tle.Nome As Taxa,
  CASE Txs.Natureza
    WHEN 0 THEN 'Débito' 
    WHEN 1 THEN 'Crédito'
  END Natureza,

  CASE Txs.Natureza 
    WHEN 0 THEN Mrp.Sigla 
    WHEN 1 THEN Mrc.Sigla
  END AS Moeda,

  CASE Txs.Natureza 
    WHEN 0 THEN Ltx.Valor_Pagamento_Total 
    WHEN 1 THEN Ltx.Valor_Recebimento_Total
  END AS Valor_Total_Estimado,

  CASE Txs.Natureza 
    WHEN 0 THEN Ltx.Fator_Pagamento_Corrente 
    WHEN 1 THEN Ltx.Fator_Recebimento_Corrente
  END AS Fator_Corrente_Estimado,

  CASE Txs.Natureza 
    WHEN 0 THEN Ltx.Valor_Pagamento_Corrente
    WHEN 1 THEN Ltx.Valor_Recebimento_Corrente
  END AS Valor_Corrente_Estimado,

  Txs.Valor_Corrente AS Valor_Corrente_Efetivo,
  Txs.Total_Corrente AS Total_Movimentacao,
  Lhs.Numero_Processo,
  Lhs.Data_Abertura_Processo,
  Ffn.Valor AS Valor_Fatura,
  Ffn.Total_Pago AS Total_Pago_Fatura,
  Ffn.Total_Pago_Corrente AS Total_Pago_Corrente_Fatura,
  Ffn.Total_Multa AS Total_Multa_Fatura,
  Ffn.Total_Juros AS Total_Juros_Fatura,
  Ffn.Total_Acrescimo AS Total_Acrescimo_Fatura,
  Ffn.Total_Desconto AS Total_Desconto_Fatura,
  Ffn.Total_Abatimento AS Total_Abatimento_Fatura
FROM
  Taxas_Calculadas Txs
JOIN
  vis_Logistica_Taxa Ltx ON Ltx.IdLogistica_Taxa = Txs.IdLogistica_Taxa
JOIN 
  cad_Taxa_Logistica_Exibicao Tle on Tle.IdTaxa_Logistica_Exibicao = Ltx.IdTaxa_Logistica_Exibicao
JOIN 
  cad_Moeda Mrp on Mrp.IdMoeda = Ltx.IdMoeda_Pagamento
JOIN 
  cad_Moeda Mrc on Mrc.IdMoeda = Ltx.IdMoeda_Recebimento
JOIN 
  mov_Logistica_House Lhs on Lhs.IdLogistica_House = Ltx.IdLogistica_House
LEFT OUTER JOIN
  vis_Logistica_Fatura Lft on Lft.IdRegistro_Financeiro = Txs.IdRegistro_Financeiro
LEFT OUTER JOIN 
  mov_Fatura_Financeira Ffn on Ffn.IdRegistro_Financeiro = Txs.IdRegistro_Financeiro
  /*WHERE*/
WHERE 
  Lhs.Data_Abertura_Processo > '2025-10-01' 
ORDER BY
  Txs.IdMovimentacao_Financeira
