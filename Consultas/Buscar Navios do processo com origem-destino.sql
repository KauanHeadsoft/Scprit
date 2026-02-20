SELECT 
	Lhs.IdLogistica_House,
	Lvg.IdLogistica_Viagem,
	Nvi.Nome AS Navio,
	Lvg.Numero_Controle AS Reserva,
	Lvg.Viagem_Voo,
	Org.Nome AS Origem,
	Dst.Nome AS Destino,
	Coalesce(Lvg.Data_Previsao_DesEmbarque,Lvg.Data_Desembarque) as ETA,
        Case When Lvg.Data_Embarque is null then Coalesce(Lvg.Data_Previsao_Embarque,Lvg.Data_Embarque) else Lvg.Data_Embarque End as ETD,
	DATEDIFF(dd,Lvg.Data_Previsao_Embarque, Lvg.Data_Previsao_Desembarque) AS Transit_Time
FROM
	mov_Atividade Atv
LEFT OUTER JOIN
  mov_Logistica_House Lhs on Lhs.IdProjeto_Atividade = Atv.IdProjeto_Atividade
LEFT OUTER JOIN
	mov_Logistica_Viagem Lvg ON Lvg.IdLogistica_House = Lhs.IdLogistica_House
LEFT OUTER JOIN
  cad_Origem_Destino Org on Org.IdOrigem_Destino = Lvg.IdOrigem
LEFT OUTER JOIN
  cad_Origem_Destino Dst on Dst.IdOrigem_Destino = Lvg.IdDestino
JOIN
  cad_Navio Nvi on Nvi.IdNavio = Lvg.IdNavio
Where
  Atv.IdAtividade = 54172  --:IdAtividade">

