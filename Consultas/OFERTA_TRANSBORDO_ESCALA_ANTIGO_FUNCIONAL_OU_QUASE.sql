<DataSet><Parameters><Item Name="IdOferta_Frete" Type="ftInteger"/></Parameters><CommandText>
SELECT
    Ofv.IdOferta_Frete,
    Ofr.IdDestino_Final as Destino_Final,
    STRING_AGG(CAST(Dst.Nome as varchar(max)), ' / ') WITHIN GROUP (ORDER BY Ofv.IdDestino) as Destinos,
    STRING_AGG(CAST(Dst.Sigla AS VARCHAR(MAX)), ' / ') WITHIN GROUP (ORDER BY Ofv.IdDestino) AS Siglas,
    STRING_AGG(CAST(case Ofv.Tipo_Viagem
        when 1 then 'Coleta'
        when 2 then 'Pré-embarque'
        when 3 then 'Local Recebimento'
        when 4 then 'Embarque inicial'
        when 5 then 'Transbordo / Escala'
        when 6 then 'Destino final'
        when 7 then 'Pós-Entrega'
        else 'Outro'
    end AS VARCHAR(MAX)), ' / ') WITHIN GROUP (ORDER BY Ofv.IdDestino) as Tipos_Viagem
FROM
    mov_Oferta_Frete_Viagem Ofv
    Left Outer Join
    cad_Origem_Destino Orm on Orm.IdOrigem_Destino = Ofv.IdOrigem
    Left Outer Join
    cad_Origem_Destino Dst on Dst.IdOrigem_Destino = Ofv.IdDestino
    Left Outer Join
    mov_Oferta_Frete Ofr on Ofr.IdOferta_Frete = Ofv.IdOferta_Frete
    Left Outer Join
    cad_Origem_Destino Dsf on Dsf.IdOrigem_Destino = Ofr.IdDestino_Final
WHERE
Ofv.IdOferta_Frete = :IdOferta_Frete
    AND
    Ofv.Tipo_Viagem in (2,3,4,5,6)
    AND
    Ofv.IdDestino &lt;&gt; Ofr.IdDestino_Final 
GROUP BY
    Ofv.IdOferta_Frete,
    Ofr.IdDestino_Final
HAVING
    SUM(CASE WHEN Ofv.Tipo_Viagem = 5 THEN 1 ELSE 0 END) &gt; 0
    </CommandText></DataSet>