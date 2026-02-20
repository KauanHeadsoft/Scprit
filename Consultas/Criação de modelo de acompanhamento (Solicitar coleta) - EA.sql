SELECT
Lgv.Local_Coleta,
Lgv.Local_Entrega,
Lgv.Data_Previsao_Embarque as Data_Coleta,
Lgv.Data_Previsao_Desembarque as Chegada,
case Lgv.Tipo_Servico when 2 then 'Dedicado / Consolidado / Cabotagem / Rodizio' when 1 then 'Back to back / Transbordo' when 0 then '(Não informado)' end as Tipo_Servico
FROM
mov_Atividade Atv
Left Outer Join
  mov_Logistica_House Lhs on Lhs.IdProjeto_Atividade = Atv.IdProjeto_Atividade
Left Outer Join
  mov_Logistica_Master Lms on Lms.IdLogistica_Master = Lhs.IdLogistica_Master
Left Outer Join
	mov_Logistica_Viagem Lgv on Lgv.IdLogistica_House = Lhs.IdLogistica_House
  where
  Atv.IdAtividade = 58162