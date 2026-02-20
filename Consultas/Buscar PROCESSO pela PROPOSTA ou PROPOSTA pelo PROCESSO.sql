Select
Lhs.Numero_Processo,
Ppf.Numero_Proposta
From
mov_Proposta_Frete Ppf
Left Outer Join
mov_Oferta_Frete Opf on Opf.IdProposta_Frete = Ppf.IdProposta_Frete
Left Outer Join
mov_logistica_house Lhs on Lhs.IdOferta_Frete = Opf.IdOferta_Frete
Where
Ppf.Numero_Proposta Like '%PF02012-26%'
--AND  Lhs.Numero_Processo Like '%%'