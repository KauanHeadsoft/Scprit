SELECT /*DESTINO*/
    Ofv.IdOferta_Frete,
    Ofr.IdDestino_Final as Destino_Final,
    String_agg(Cast(Dst.Nome as varchar(max)), ' / ') WITHIN GROUP (ORDER BY Ofv.IdDestino) as Destinos,
    String_agg(Cast(Dst.Sigla as VARCHAR(max)), ' / ') WITHIN GROUP (ORDER BY Ofv.IdDestino) as Siglas,
    String_agg(Cast(case Ofv.Tipo_Viagem
        when 1 then 'Coleta'
        when 2 then 'Pré-embarque'
        when 3 then 'Local Recebimento'
        when 4 then 'Embarque inicial'
        when 5 then 'Transbordo / Escala'
        when 6 then 'Destino final'
        when 7 then 'Pós-Entrega'
        else 'Outro'
    end as VARCHAR(MAX)), ' / ') WITHIN GROUP (ORDER BY Ofv.IdDestino) as Tipos_Viagem,
    Ofr.Rota,
    Dsf.Nome as Destino_Final,
    Dst.Nome as Destino
From
    mov_Oferta_Frete_Viagem Ofv
    Left Outer Join
    cad_Origem_Destino Orm on Orm.IdOrigem_Destino = Ofv.IdOrigem
    Left Outer Join
    cad_Origem_Destino Dst on Dst.IdOrigem_Destino = Ofv.IdDestino
    Left Outer Join
    mov_Oferta_Frete Ofr on Ofr.IdOferta_Frete = Ofv.IdOferta_Frete
    Left Outer Join
    cad_Origem_Destino Dsf on Dsf.IdOrigem_Destino = Ofr.IdDestino_Final
Where
Ofv.IdOferta_Frete = 143250
    AND
    Ofv.Tipo_Viagem in (2,5)
    AND
    Ofv.IdDestino <> Ofr.IdDestino_Final 
Group by
    Ofv.IdOferta_Frete,
    Ofr.IdDestino_Final,
    Ofr.Rota,
    Dsf.Nome,
    Dst.Nome
Having
    Sum(Case 
          When Ofv.Tipo_Viagem = 5 /*transbordo*/ Then 1 /*verdadeiro*/ 
          When Ofv.Tipo_Viagem = 4 /*embarque inicial*/ Then 1 /*verdadeiro*/ 
          When Ofv.Tipo_Viagem = 1 /*coleta*/ Then 1 /*verdadeiro*/
          When Ofv.Tipo_Viagem = 3 /*local recebido*/ Then 1 /*verdadeiro*/
          Else 0 /*falso*/ End) > 0 /*falso*/