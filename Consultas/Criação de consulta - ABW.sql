SELECT
Lhs.Referencia_Cliente as Referencia_Cliente,
Lhs.Referencia_Interna as Referencia_Tex,
Cne.Numero as Numero_BL_House,
Lgv.Numero_Conhecimento as Numero_BL_Master,
Orm.Nome as Origem,
Dst.Nome as Destino,
Pes.Nome as Nome_Cliente,
Cia.nome as Armador,
Lms.Data_Previsao_Embarque as ETD,
Lms.Data_Previsao_Desembarque as ETA,
Lmh.Containers as Containers,
COALESCE(Lmh.Total_Container_20, 0) + COALESCE(Lmh.Total_Container_40, 0) AS Quantidade_Containeres,
Nav.Nome as Navio,
Lmc.Free_Time_House as Free_Time_House,
Nat.Nome as Navio_Transbordo

FROM
mov_logistica_house as Lhs
left outer join
cad_Pessoa Pes ON Pes.IdPessoa = Lhs.IdCliente
left outer join
mov_logistica_master Lms ON Lms.IdLogistica_Master = Lhs.IdLogistica_Master
left outer join
mov_Conhecimento_Embarque Cne ON Cne.IdLogistica_House = Lhs.IdLogistica_House
left outer join
mov_Logistica_Viagem Lgv ON Lgv.IdLogistica_House = Lhs.IdLogistica_House
left outer join
cad_Origem_Destino Orm ON Orm.IdOrigem_Destino = Lms.IdOrigem
left outer join
cad_Origem_Destino Dst ON Dst.IdOrigem_Destino = Lms.IdDestino
left outer join
cad_pessoa Cia ON Cia.IdPessoa = Lms.IdCompanhia_Transporte
left outer join
mov_Logistica_Maritima_House Lmh ON Lmh.IdLogistica_House = Lhs.IdLogistica_House
left outer join
cad_Navio Nav ON Nav.IdNavio = Lms.IdCompanhia_Transporte
left outer join
mov_Logistica_Maritima_Container Lmc ON Lmc.IdLogistica_House = Lhs.IdLogistica_House
left outer join
mov_logistica_viagem Lgt ON Lgt.IdLogistica_House = Lhs.IdLogistica_House AND Lgt.Tipo_Viagem = 5
left outer join
cad_Navio Nat ON Nat.IdNavio = Lgt.IdNavio
where
Pes.IdPessoa = 49971
AND
Lms.Modalidade_Processo = 2
AND
Lms.Tipo_Operacao= 2
