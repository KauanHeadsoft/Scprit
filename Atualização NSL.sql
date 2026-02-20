<DataSet><Parameters><Item Name="IdLogistica_House" Type="ftInteger" Size="0" Test="3052"/></Parameters><CommandText>DECLARE
  @IdLogistica_House Integer = :IdLogistica_House

SELECT
  Lhs.IdLogistica_House,
  ISNULL(Lmc.Lucro_Efetivo, 0) - ISNULL(Txs.Total_Taxas_Tributaveis, 0) AS Lucro_Contabil_Total,
  CAST(CASE 
    WHEN Lhs.Situacao_Agenciamento = 5 /* Finalizado */ THEN 1
    ELSE 0
  END AS BIT) AS Disponivel_Apuracao
FROM
  mov_Logistica_House Lhs
JOIN
  cad_Moeda Mcr ON Mcr.Moeda_Corrente = 1
LEFT OUTER JOIN
  mov_Logistica_Moeda Lmc ON Lmc.IdLogistica_House = Lhs.IdLogistica_House
    AND Lmc.IdMoeda = Mcr.IdMoeda
LEFT OUTER JOIN
  (SELECT
    Ltx.IdLogistica_House,
    SUM(CASE
      WHEN Ltx.IdMoeda_Recebimento = Mcr.IdMoeda THEN Ltx.Valor_Recebimento_Total
      WHEN Lfc.IdMoeda_Origem = Ltx.IdMoeda_Recebimento AND Lfc.IdMoeda_Destino = Mcr.IdMoeda THEN ROUND(Ltx.Valor_Recebimento_Total * Lfc.Fator_Conversao, 2)
      WHEN Lfc.IdMoeda_Origem = Mcr.IdMoeda AND Lfc.IdMoeda_Destino = Ltx.IdMoeda_Recebimento AND ISNULL(Lfc.Fator_Conversao, 0) &lt;&gt; 0 THEN ROUND(Ltx.Valor_Recebimento_Total * ROUND(1 / Lfc.Fator_Conversao, 6), 2)
      ELSE 0
    END) AS Total_Taxas_Tributaveis
  FROM
    mov_Logistica_Taxa Ltx
  LEFT OUTER JOIN
    cad_Moeda Mcr ON Mcr.Moeda_Corrente = 1
  LEFT OUTER JOIN
    mov_Logistica_Fatura_Conversao Lfc ON Lfc.IdLogistica_Fatura = Ltx.IdRegistro_Recebimento
      AND ((Lfc.IdMoeda_Origem = Ltx.IdMoeda_Recebimento AND Lfc.IdMoeda_Destino = Mcr.IdMoeda)
        OR (Lfc.IdMoeda_Origem = Mcr.IdMoeda AND Lfc.IdMoeda_Destino = Ltx.IdMoeda_Recebimento))
  WHERE
    Ltx.IdLogistica_House = @IdLogistica_House
  AND
    Ltx.Tributavel = 1
  GROUP BY
    Ltx.IdLogistica_House
  ) Txs ON Txs.IdLogistica_House = Lhs.IdLogistica_House
WHERE
  Lhs.IdLogistica_House = @IdLogistica_House</CommandText></DataSet>