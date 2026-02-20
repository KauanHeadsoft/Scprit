SELECT
  Lms.Modalidade_Pagamento AS Master_Original,
  Ltx.Modalidade_Pagamento AS Taxa_Original,
  CASE 
     WHEN Ltx.Modalidade_Pagamento = 1 THEN 3
     WHEN Ltx.Modalidade_Pagamento = 2 THEN 2 
     WHEN Ltx.Modalidade_Pagamento = 3 THEN 4 
     ELSE Ltx.Modalidade_Pagamento
  END AS Taxa_Traduzida,

  CASE
    WHEN Lms.Modalidade_Pagamento <> 
         CASE 
           WHEN Ltx.Modalidade_Pagamento = 1 THEN 3
           WHEN Ltx.Modalidade_Pagamento = 2 THEN 2
           WHEN Ltx.Modalidade_Pagamento = 3 THEN 4
           ELSE Ltx.Modalidade_Pagamento
         END
    THEN 'Diferente'
    ELSE 'Igual'
  END AS Status_Bloqueio

FROM
  mov_logistica_taxa Ltx
  LEFT OUTER JOIN mov_logistica_house Lhs ON Lhs.IdLogistica_House = Ltx.IdLogistica_House
  LEFT OUTER JOIN mov_logistica_master Lms ON Lms.IdLogistica_Master = Lhs.IdLogistica_Master
WHERE
  Lhs.Numero_Processo LIKE '%IM0945-25%'
  AND Ltx.IdTaxa_Logistica_Exibicao = 252