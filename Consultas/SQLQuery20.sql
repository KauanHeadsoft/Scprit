SELECT
IdOferta_frete_taxa,
Valor_pagamento_total,
*
FROM
mov_logistica_taxa Ltx
Left Outer Join
mov_Logistica_house Lhs ON Lhs.Idlogistica_house = Ltx.Idlogistica_house
Where
numero_processo like '%IM1880-25%'
AND
IdTaxa_logistica_exibicao = 252