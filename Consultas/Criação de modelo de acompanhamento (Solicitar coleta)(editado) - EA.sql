SELECT DISTINCT
    Atv.IdAtividade,
    Lhs.IdLogistica_House,
    Lms.IdLogistica_Master,
    CAST(Lhs.Local_Coleta AS VARCHAR(MAX)) AS Local_Coleta,
    CAST(Lhs.Local_Entrega AS VARCHAR(MAX)) AS Local_Entrega,
    Lgv.Data_Previsao_Embarque as Data_Coleta,
    Lgv.Data_Previsao_Desembarque as Chegada,
    CASE Lgv.Tipo_Servico 
        WHEN 2 THEN 'Dedicado / Consolidado / Cabotagem / Rodizio' 
        WHEN 1 THEN 'Back to back / Transbordo' 
        WHEN 0 THEN '(Não informado)' 
    END as Tipo_Servico,
    CAST(Mer.Nome AS VARCHAR(MAX)) as Mercadoria,
    CAST(Moe.Nome AS VARCHAR(MAX)) as Moeda,
    Lhs.Metros_Cubicos,
    Lhs.Quantidade_Volumes,
    Lhs.Valor_Mercadoria,
    Lhs.Importancia_Segurada,
    Lhs.Peso_Bruto,
    CASE Lhs.Seguro WHEN 0 THEN 'Não' WHEN 1 THEN 'Sim' END as Seguro,
    CASE Lhs.Carga_Perigosa WHEN 0 THEN 'Não' WHEN 1 THEN 'Sim' END as Carga_Perigosa,
    Lah.Peso_taxado,
    CAST(Tmb.Nome AS VARCHAR(MAX)) as Embalagemm,
    Lgm.Quantidade as Quantidade_Emb,
    Lgm.Altura as Altura_Emb,
    Lgm.Largura as Largura_Emb,
    Lgm.Comprimento as Comprimento_Emb,
    Lgm.Metros_Cubicos as Met_Cub_Emb,
    Lgm.Peso_Liquido as Peso_Liq_Emb,
    Lgm.Peso_Bruto as Peso_But_Emb,
    Lgm.Peso_Cubado as Peso_Cub_Emb,
    Lhs.Numero_Processo,
    Clv.Valor_Data
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
    mov_Logistica_Embalagem Lgm ON Lgm.IdLogistica_House = Lhs.IdLogistica_House
LEFT OUTER JOIN
    cad_Tipo_Embalagem Tmb ON Tmb.IdTipo_Embalagem = Lgm.IdTipo_Embalagem
LEFT OUTER JOIN
    mov_Logistica_Campo_Livre Cml on Cml.IdLogistica_House = Lhs.IdLogistica_House
LEFT OUTER JOIN
    mov_Campo_Livre Clv on Clv.IdCampo_Livre = Cml.IdCampo_Livre and IdConfiguracao_Campo_Livre= 141
WHERE
    Atv.IdAtividade = 1509438