Select DISTINCT
    Atv.IdAtividade,
    Lhs.IdLogistica_House,
    Lms.IdLogistica_Master,
    CAST(Lhs.Local_Coleta AS VARCHAR(MAX)) AS Local_Coleta,
    CAST(Lhs.Local_Entrega_Origem AS VARCHAR(MAX)) AS Local_Entrega,
    Lhs.Data_Coleta as Data_Coleta,
    Lhs.Data_Entrega_Origem as Chegada,
    case Lgv.Tipo_Servico when 0 then 'Não informado' when 1 then 'Back to back' when 2 then 'Consolidado' end as Tipo_Servico,
    CAST(Mer.Nome AS VARCHAR(MAX)) as Mercadoria,
    CAST(Moe.Nome AS VARCHAR(MAX)) as Moeda,
    Lhs.Metros_Cubicos,
    Lhs.Quantidade_Volumes,
    Lhs.Valor_Mercadoria,
    Lhs.Importancia_Segurada,
    CASE Lhs.Seguro WHEN 0 THEN 'Não' WHEN 1 THEN 'Sim' END as Seguro,
    CASE Lhs.Carga_Perigosa WHEN 0 THEN 'Não' WHEN 1 THEN 'Sim' END as Carga_Perigosa,
    Lah.Peso_taxado,
    Lhs.Peso_Bruto,
    Lhs.Numero_Processo,
    Lgp.Valor_Data as Deadline
FROM
    mov_Atividade Atv
LEFT OUTER JOIN
    mov_Logistica_House Lhs ON Lhs.IdProjeto_Atividade = Atv.IdProjeto_Atividade
LEFT OUTER JOIN
    mov_Logistica_Master Lms ON Lms.IdLogistica_Master = Lhs.IdLogistica_Master
LEFT OUTER JOIN
    mov_Logistica_Viagem Lgv ON Lgv.IdLogistica_House = Lhs.IdLogistica_House
LEFT OUTER JOIN
    mov_Logistica_Aerea_House Lah ON Lah.IdLogistica_House = Lhs.IdLogistica_House
LEFT OUTER JOIN
    cad_Mercadoria Mer ON Mer.IdMercadoria = Lhs.IdMercadoria
LEFT OUTER JOIN
    cad_Moeda Moe ON Moe.IdMoeda = Lhs.IdMoeda_Mercadoria
LEFT OUTER JOIN
vis_logistica_prazo Lgp ON Lgp.IdLogistica_House = Lhs.IdLogistica_House and Lgp.IdConfiguracao_Campo_Livre = 141
WHERE
Atv.IdAtividade = 56103