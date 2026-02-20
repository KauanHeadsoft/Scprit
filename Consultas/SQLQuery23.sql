SELECT
CASE /*Buscar o tipo de modalidade do pagamento do comercial*/
WHEN Oft.Modalidade_Pagamento = 0 THEN 'Não definida'
WHEN Oft.Modalidade_Pagamento = 1 THEN 'Prepaid'
WHEN Oft.Modalidade_Pagamento = 2 THEN 'Collect'
WHEN Oft.Modalidade_Pagamento = 3 THEN 'Abroad'
END AS Modalidade_Pagamento,
CASE /*Buscar o tipo de modalidade do recebimento do comercial*/
        WHEN Oft.Modalidade_Recebimento = 0 THEN 'Não definida'
        WHEN Oft.Modalidade_Recebimento = 1 THEN 'Prepaid'
        WHEN Oft.Modalidade_Recebimento = 2 THEN 'Collect'
        WHEN Oft.Modalidade_Recebimento = 3 THEN 'Abroad'
        END AS Modalidade_Recebimento,
CASE 
        WHEN Otf.Modalidade_Pagamento_Master = 0 THEN '(Não informado)'
        WHEN Otf.Modalidade_Pagamento_Master = 1 THEN 'Collect/Prepaid'
        WHEN Otf.Modalidade_Pagamento_Master = 2 THEN 'Collect'
        WHEN Otf.Modalidade_Pagamento_Master = 3 THEN 'Prepaid'
        WHEN Otf.Modalidade_Pagamento_Master = 4 THEN 'Prepaid abroad'
        END AS Modalidade_Pagamento_Master,
CASE 
        WHEN Otf.Modalidade_Pagamento_House = 0 THEN '(Não informado)'
        WHEN Otf.Modalidade_Pagamento_House = 1 THEN 'Collect/Prepaid'
        WHEN Otf.Modalidade_Pagamento_House = 2 THEN 'Collect'
        WHEN Otf.Modalidade_Pagamento_House = 3 THEN 'Prepaid'
        WHEN Otf.Modalidade_Pagamento_House = 4 THEN 'Prepaid abroad'
        END AS Modalidade_Pagamento_House
FROM
mov_Logistica_Taxa Ltx
Left Outer Join	
mov_logistica_house Lhs ON Lhs.idLogistica_House = Ltx.idLogistica_House
Left Outer Join	
mov_oferta_frete_taxa Oft ON Oft.idoferta_frete_taxa = Ltx.idoferta_frete_taxa
Left Outer Join	
mov_oferta_frete Otf ON Otf.IdOferta_Frete = Oft.IdOferta_Frete

