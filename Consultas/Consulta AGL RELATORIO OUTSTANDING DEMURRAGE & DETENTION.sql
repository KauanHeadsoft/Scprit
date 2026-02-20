SELECT
    Lhs.IdLogistica_House,
    Lmd.Lucro_Estimado,
    Lmd.Total_Pago - Lmd.Total_Pagamento_Local AS Diferenca_Pagamento,
    Lmd.Total_Pago,
    CASE 
        WHEN Txa.Total_Recebimento IS NOT NULL THEN Lmd.Total_Recebido_Local + Txa.Total_Recebimento
        ELSE Lmd.Total_Recebido_Local
    END AS Total_Fatura_Armador,
    Spl.Descricao,
    Lhs.Observacao,
    Lhe.Numero_Processo as Processo_Origem,
    Ven.Nome AS Vendedor,
    Oft.Numero_Oferta,
    Lhs.Numero_Processo,
    Rec.Pessoa_Recebimento,
    Rec.Moeda_Recebimento,
    Rec.Valor_Recebimento,
    Lmd.Total_Recebimento_Local,
    CASE
        WHEN Rec.Data_Vencimento IS NOT NULL THEN
            CASE
                WHEN DATEDIFF(DAY, GETDATE(), Rec.Data_Vencimento) < 0 
                THEN '-' + CAST(ABS(DATEDIFF(DAY, GETDATE(), Rec.Data_Vencimento)) AS VARCHAR) 
                ELSE '+' + CAST(DATEDIFF(DAY, GETDATE(), Rec.Data_Vencimento) AS VARCHAR)
            END
        ELSE NULL
    END AS Dias_Vencimento,
    Rec.Data_Vencimento,
    Cia.Nome AS Cia_Transporte,
    Lhs.Conhecimentos AS BL_House,
    Lms.Numero_Conhecimento AS BL_Master,
    Rec.Status_Fatura,
    Rec.Situacao_Fatura
FROM
    mov_Logistica_House Lhs 
LEFT OUTER JOIN
    mov_Logistica_Master Lms ON Lms.IdLogistica_Master = Lhs.IdLogistica_Master 
LEFT OUTER JOIN
    mov_Oferta_Frete Oft ON Oft.IdOferta_Frete = Lhs.IdOferta_Frete
LEFT OUTER JOIN
    mov_Logistica_House Lhe ON Lhe.IdLogistica_House = Lhs.IdProcesso_Origem
LEFT OUTER JOIN
    cad_Status_Processo_Logistico Spl on Spl.IdStatus_Processo_Logistico = Lhs.IdStatus_Processo_Logistico
LEFT OUTER JOIN
    cad_Pessoa Ven ON Ven.IdPessoa = Lhs.IdVendedor
LEFT OUTER JOIN
    cad_Pessoa Cia ON Cia.IdPessoa = Lms.IdCompanhia_Transporte
LEFT OUTER JOIN (
    SELECT 
        ROW_NUMBER() OVER(PARTITION BY Lho.IdLogistica_House ORDER BY Lho.IdLogistica_House) AS Indice,
        Lho.IdLogistica_House,
        Lda.Total_Recebimento
    FROM
        mov_Logistica_House Lho
    LEFT OUTER JOIN  
        mov_Logistica_Taxa Ltx on Ltx.IdLogistica_House = Lho.IdLogistica_House
    LEFT OUTER JOIN 
        mov_Logistica_Master Lmt on Lmt.IdLogistica_Master = Lho.IdLogistica_Master
    LEFT OUTER JOIN 
        mov_Logistica_Moeda Lda on Lda.IdLogistica_House = Lho.IdLogistica_House AND Lda.IdMoeda = 110 
    WHERE
        Ltx.IdTaxa_Logistica_Exibicao = 168 
    AND 
        Lmt.IdCompanhia_Transporte = Ltx.IdPessoa_Recebimento
) Txa on Txa.IdLogistica_House = Lhs.IdLogistica_House AND Txa.Indice = 1
LEFT OUTER JOIN
    mov_Logistica_Moeda Lmd ON Lmd.IdLogistica_House = Lhs.IdLogistica_House AND Lmd.IdMoeda = 110 
LEFT OUTER JOIN (
    SELECT
        ROW_NUMBER() OVER(PARTITION BY Lft.IdLogistica_House ORDER BY Ffn.Data_Vencimento ASC) AS Indice,
        Lft.IdLogistica_House,
        Ffn.Data_Vencimento,
        Prc.Nome AS Pessoa_Recebimento,
        SUM(Ltx.Valor_Recebimento_Total) as Valor_Recebimento,
        Mda.Sigla AS Moeda_Recebimento,
        CASE
            WHEN Ffn.IdRegistro_Unificador <> 0 THEN 'Fatura Unificada'
            WHEN Ffn.Situacao In (2, 3) THEN 'Fatura com Baixa'
            WHEN Ffn.Conferido = 1 THEN 'Fatura Conferida'
            WHEN Rfn.Origem_Lancamento <> 1 AND Ffn.Tipo = 2 THEN 'Título'
            ELSE 'Fatura Finalizada'
        END AS Status_Fatura, /*Adicionado esse CASE para buscar o status que fica no operacial na guia da fatura*/
         CASE
        WHEN Ffn.Situacao = 1 THEN 'Em Aberto'
        WHEN Ffn.Situacao = 2 THEN 'Quitada'
        WHEN Ffn.Situacao = 3 THEN 'Parcialmente quitada'
        WHEN Ffn.Situacao = 4 THEN 'Unificada'
        WHEN Ffn.Situacao = 5 THEN 'Em cobrança'
        WHEN Ffn.Situacao = 6 THEN 'Cancelada'
        WHEN Ffn.Situacao = 7 THEN 'Em cobrança judicial'
        WHEN Ffn.Situacao = 8 THEN 'Negativado'
        WHEN Ffn.Situacao = 9 THEN 'Protestado'
        WHEN Ffn.Situacao = 10 THEN 'Junk'
        END AS Situacao_Fatura /*status para buscar o tipo de fatura*/
    FROM
        mov_Logistica_Fatura Lft
    LEFT OUTER JOIN
        mov_Fatura_Financeira Ffn ON Ffn.IdRegistro_Financeiro = Lft.IdRegistro_Financeiro
    LEFT OUTER JOIN 
        mov_Registro_Financeiro Rfn ON Rfn.IdRegistro_Financeiro = Ffn.IdRegistro_Financeiro
    LEFT OUTER JOIN
        mov_Logistica_Taxa Ltx ON Ltx.IdRegistro_Recebimento = Ffn.IdRegistro_Financeiro
    LEFT OUTER JOIN
        vis_Logistica_Fatura_Totais Lfs on Lfs.IdRegistro_Financeiro = Lft.IdRegistro_Financeiro
    LEFT OUTER JOIN
        cad_Pessoa Prc ON Prc.IdPessoa = Ltx.IdPessoa_Recebimento
    LEFT OUTER JOIN
        cad_Moeda Mda ON Mda.IdMoeda = Ltx.IdMoeda_Recebimento
    WHERE Ffn.Natureza = 1 /*Crédito*/
    GROUP BY
        Lft.IdLogistica_House,
        Ffn.Data_Vencimento,
        Prc.Nome,
        Mda.Sigla,
        Ffn.IdRegistro_Unificador,
        Ffn.Situacao,
        Ffn.Conferido,
        Rfn.Origem_Lancamento,
        Ffn.Tipo
    ) Rec on Rec.IdLogistica_House = Lhs.IdLogistica_House AND Rec.Indice = 1
LEFT OUTER JOIN (
    SELECT
        ROW_NUMBER() OVER(PARTITION BY Lft.IdLogistica_House ORDER BY Ffn.Situacao DESC) AS Indice,
        Lft.IdLogistica_House,
        Ltx.IdPessoa_Pagamento,
        Ffn.Situacao,
        Ffn.Total_Pago_Corrente,
        Ffn.Referencia_Externa
    FROM
        mov_Logistica_Fatura Lft
    LEFT OUTER JOIN
        mov_Fatura_Financeira Ffn ON Ffn.IdRegistro_Financeiro = Lft.IdRegistro_Financeiro
    LEFT OUTER JOIN
        mov_Logistica_Taxa Ltx ON Ltx.IdRegistro_Pagamento = Ffn.IdRegistro_Financeiro
    WHERE
        Ffn.Natureza = 0 AND Ltx.Pagar_Para = 5 ) Pag on Pag.IdLogistica_House = Lhs.IdLogistica_House AND Pag.Indice = 1 
WHERE
    Lhs.Situacao_Agenciamento NOT IN (7,4,3)  /*Cancelado, Faturado, Liberado faturamento*/
AND
    Lhs.Demurrage_Detention = 1 
AND
    Lhs.Data_Abertura_Processo > '2025-01-11' /*Data escolhida para filtrar*/
AND
    Lms.Tipo_Operacao = 2 /*Importação*/

 
    