<DataSet><Parameters><Item Name="IdOferta_Frete" Type="ftInteger"/></Parameters><CommandText>
WITH Contagem_Transbordos AS (
    SELECT
        IdOferta_Frete,
        COUNT(*) as Qtd_Transbordo
    FROM
        mov_Oferta_Frete_Viagem
    WHERE
        Tipo_Viagem = 5
    GROUP BY
        IdOferta_Frete
)

SELECT
    Ofv.IdOferta_Frete,
    String_agg(Cast(
        CASE
            WHEN Ct.Qtd_Transbordo = 1 THEN Orm.Nome
            ELSE Dst.Nome
        END
    as varchar(max)), ' / ') WITHIN GROUP (ORDER BY Ofv.IdOrigem) as Destinos,
    String_agg(Cast(
        CASE
            WHEN Ct.Qtd_Transbordo = 1 THEN Orm.Sigla
            ELSE Dst.Sigla
        END
    as VARCHAR(max)), ' / ') WITHIN GROUP (ORDER BY Ofv.IdOrigem) as Siglas,
    String_agg(Cast(
        CASE Ofv.Tipo_Viagem
            WHEN 1 THEN 'Coleta'
            WHEN 2 THEN 'Pré-embarque'
            WHEN 3 THEN 'Local Recebimento'
            WHEN 4 THEN 'Embarque inicial'
            WHEN 5 THEN 'Transbordo / Escala'
            WHEN 6 THEN 'Destino final'
            WHEN 7 THEN 'Pós-Entrega'
            ELSE 'Outro'
        END
    as VARCHAR(MAX)), ' / ') WITHIN GROUP (ORDER BY Ofv.IdOrigem) as Tipos_Viagem,
    Ofr.Rota,
    String_agg(Cast(
        CASE
            WHEN Ct.Qtd_Transbordo = 1 THEN Orm.Nome
            ELSE Dst.Nome
        END
    as varchar(max)), ' / ') WITHIN GROUP (ORDER BY Ofv.IdOrigem) as Destino
FROM
    mov_Oferta_Frete_Viagem Ofv
    LEFT OUTER JOIN cad_Origem_Destino Orm ON Orm.IdOrigem_Destino = Ofv.IdOrigem
    LEFT OUTER JOIN cad_Origem_Destino Dst ON Dst.IdOrigem_Destino = Ofv.IdDestino
    LEFT OUTER JOIN mov_Oferta_Frete Ofr ON Ofr.IdOferta_Frete = Ofv.IdOferta_Frete
    LEFT OUTER JOIN cad_Origem_Destino Dsf ON Dsf.IdOrigem_Destino = Ofr.IdDestino_Final
    LEFT OUTER JOIN Contagem_Transbordos Ct ON Ct.IdOferta_Frete = Ofv.IdOferta_Frete
WHERE
    Ofv.IdOferta_Frete =  :IdOferta_Frete
    AND Ofv.Tipo_Viagem IN (2, 5)
 
GROUP BY
    Ofv.IdOferta_Frete,
    Ofr.Rota,
    Dsf.Nome,
    Ct.Qtd_Transbordo
HAVING
    Sum(Case
          When Ofv.Tipo_Viagem = 5 /*transbordo*/ Then 1 /*verdadeiro*/
          When Ofv.Tipo_Viagem = 4 /*embarque inicial*/ Then 1 /*verdadeiro*/
          When Ofv.Tipo_Viagem = 1 /*coleta*/ Then 1 /*verdadeiro*/
          When Ofv.Tipo_Viagem = 3 /*local recebido*/ Then 1 /*verdadeiro*/
          Else 0 /*falso*/ End) &gt; 0 /*falso*/
          </CommandText></DataSet>