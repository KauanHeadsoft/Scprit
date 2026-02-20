Select DISTINCT top 1
    Lgv.IdLogistica_Viagem,
    Atv.IdAtividade,
    Lhs.IdLogistica_House,
    Lms.IdLogistica_Master,
    CAST(Lhs.Local_Coleta AS VARCHAR(MAX)) AS Local_Coleta,
    CAST(Lhs.Local_Entrega_Origem AS VARCHAR(MAX)) AS Local_Entrega,
    Lhs.Data_Coleta as Data_Coleta,
    Lhs.Data_Entrega_Origem as Chegada,
    --LgvT.Tipo_Viagem,
    --LgvT.Tipo_Servico,
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
--LEFT OUTER JOIN(
--SELECT
--Lgv.IdLogistica_Viagem,
--Lhs.IdLogistica_House,
--case Lgv.Tipo_Servico when 0 then 'Não informado' when 1 then 'Back to back' when 2 then 'Consolidado' end as Tipo_Servico,
--case Lgv.Tipo_Viagem when 1 then 'Coleta' else 'Não pode aparecer' end as Tipo_Viagem
--FROM
--mov_Logistica_Viagem Lgv
--Left Outer Join
--mov_Logistica_House Lhs on Lhs.IdLogistica_House = Lgv.IdLogistica_House
--where
--Lgv.Tipo_Viagem = 1) LgvT on LgvT.IdLogistica_House =  Lhs.IdLogistica_House 
WHERE
Atv.IdAtividade = 1510538


Select DISTINCT top 1
       Atv.IdAtividade,
    Lhs.IdLogistica_House,
    Lms.IdLogistica_Master,
    CAST(Lhs.Local_Coleta AS VARCHAR(MAX)) AS Local_Coleta,
    CAST(Lhs.Local_Entrega_Origem AS VARCHAR(MAX)) AS Local_Entrega,
    Lhs.Data_Previsao_Coleta as Data_Coleta,
    Lhs.Data_Previsao_Entrega_Origem as Chegada,
    LgvT.Tipo_Servico,
     CASE Lgv.Tipo_Servico 
        WHEN 0 THEN '(Não informado)'
        WHEN 1 THEN 'Back to back'
        WHEN 2 THEN 'Consolidado'
        ELSE ''
    END as Tipo_Servico_geral,
    CAST(Mer.Nome AS VARCHAR(MAX)) as Mercadoria,
    CAST(Moe.Nome AS VARCHAR(MAX)) as Moeda,
    Lhs.Metros_Cubicos,
    Lhs.Quantidade_Volumes,
    Lhs.Valor_Mercadoria,
    Lhs.Importancia_Segurada,
    Ord.Nome as Destino,
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
    mov_Logistica_Viagem Lvo on Lvo.IdLogistica_house = Lhs.IdLogistica_House and Lvo.Tipo_Viagem = 1
LEFT OUTER JOIN
    cad_Origem_Destino Oro on Oro.IdOrigem_Destino = Lvo.IdOrigem
LEFT OUTER JOIN
    cad_Origem_Destino Ord on Ord.IdOrigem_Destino = Lvo.IdDestino
LEFT OUTER JOIN
    cad_Mercadoria Mer ON Mer.IdMercadoria = Lhs.IdMercadoria
LEFT OUTER JOIN
    cad_Moeda Moe ON Moe.IdMoeda = Lhs.IdMoeda_Mercadoria
LEFT OUTER JOIN
vis_logistica_prazo Lgp ON Lgp.IdLogistica_House = Lhs.IdLogistica_House and Lgp.IdConfiguracao_Campo_Livre = 141
LEFT OUTER JOIN(
SELECT
Lgv.IdLogistica_Viagem,
Lhs.IdLogistica_House,
case Lgv.Tipo_Servico when 0 then 'Não informado' when 1 then 'Back to back' when 2 then 'Consolidado' end as Tipo_Servico,
case Lgv.Tipo_Viagem when 1 then 'Coleta' else 'Não pode aparecer' end as Tipo_Viagem
FROM
mov_Logistica_Viagem Lgv
Left Outer Join
mov_Logistica_House Lhs on Lhs.IdLogistica_House = Lgv.IdLogistica_House
where
Lgv.Tipo_Viagem = 1) LgvT on LgvT.IdLogistica_House =  Lhs.IdLogistica_House 
WHERE
Atv.IdAtividade = 1510538

Select
    CAST(Tmb.Nome AS VARCHAR(MAX)) as Embalagemm,
    Lgm.Quantidade as Quantidade_Emb,
    Lgm.Altura as Altura_Emb,
    Lgm.Largura as Largura_Emb,
    Lgm.Comprimento as Comprimento_Emb,
    Lgm.Metros_Cubicos as Met_Cub_Emb,
    Lgm.Peso_Liquido as Peso_Liq_Emb,
    Lgm.Peso_Bruto as Peso_But_Emb,
    Lgm.Peso_Cubado as Peso_Cub_Emb
FROM
    mov_Atividade Atv
JOIN
    mov_Logistica_House Lhs ON Lhs.IdProjeto_Atividade = Atv.IdProjeto_Atividade
JOIN
    mov_Logistica_Embalagem Lgm ON Lgm.IdLogistica_House = Lhs.IdLogistica_House
LEFT OUTER JOIN
    cad_Tipo_Embalagem Tmb ON Tmb.IdTipo_Embalagem = Lgm.IdTipo_Embalagem
WHERE
    Atv.IdAtividade =1511981








    Select
    Lte.Nome as Taxa_Nome,
    Mop.Sigla as Moeda,
    Ltx.Valor_Pagamento_Unitario as Valor_Unitario,
    SUM(Ltx.Valor_Pagamento_Unitario) OVER() as Total_Pagamento_Unitario,
     SUM(Ltx.Valor_Pagamento_Total) OVER() as Total_Pagamento_Total,
    Ltx.valor_Pagamento_Minimo as Valor_Minimo,
    Txl.Tipo
FROM
    mov_Atividade Atv
JOIN
    mov_Logistica_House Lhs ON Lhs.IdProjeto_Atividade = Atv.IdProjeto_Atividade
JOIN
    mov_Logistica_Taxa Ltx ON Ltx.IdLogistica_House = Lhs.IdLogistica_House
LEFT JOIN
    cad_Taxa_Logistica_Exibicao Lte ON Lte.IdTaxa_Logistica_Exibicao = Ltx.IdTaxa_Logistica_Exibicao
LEFT JOIN
    cad_Moeda Mop ON Mop.IdMoeda = Ltx.IdMoeda_Pagamento
LEFT JOIN
    cad_Taxa_Logistica Txl on Txl.IdTaxa_Logistica =  Lte.IdTaxa_Logistica
WHERE
    Atv.IdAtividade = 1512932
AND
Ltx.Origem_Taxa = 1
ORDER BY Lte.Nome





SELECT
    Atv.IdAtividade,
    Lhs.IdLogistica_House,
    Lms.IdLogistica_Master,
    CAST(Lhs.Local_Coleta AS VARCHAR(MAX)) AS Local_Coleta,
    CAST(Lhs.Local_Entrega_Origem AS VARCHAR(MAX)) AS Local_Entrega,
    Lhs.Data_Previsao_Coleta AS Data_Coleta,
    Lhs.Data_Previsao_Entrega_Origem AS Chegada,
    COALESCE(Lvc.Tipo_Servico_Desc, '(Não informado)') AS Tipo_Servico_Coleta,
    CAST(Mer.Nome AS VARCHAR(MAX)) AS Mercadoria,
    CAST(Moe.Nome AS VARCHAR(MAX)) AS Moeda,
    Lhs.Metros_Cubicos,
    Lhs.Quantidade_Volumes,
    Lhs.Valor_Mercadoria,
    Lhs.Importancia_Segurada,
    Ord.Nome AS Destino,
    CASE Lhs.Seguro WHEN 0 THEN 'Não' WHEN 1 THEN 'Sim' END AS Seguro,
    CASE Lhs.Carga_Perigosa WHEN 0 THEN 'Não' WHEN 1 THEN 'Sim' END AS Carga_Perigosa,
    Lah.Peso_taxado,
    Lhs.Peso_Bruto,
    Lhs.Numero_Processo,
    Lgp.Valor_Data AS Deadline
FROM
    mov_Atividade Atv
LEFT OUTER JOIN
    mov_Logistica_House Lhs ON Lhs.IdProjeto_Atividade = Atv.IdProjeto_Atividade
LEFT OUTER JOIN
    mov_Logistica_Master Lms ON Lms.IdLogistica_Master = Lhs.IdLogistica_Master
LEFT OUTER JOIN
    mov_Logistica_Aerea_House Lah ON Lah.IdLogistica_House = Lhs.IdLogistica_House
LEFT OUTER JOIN
    cad_Mercadoria Mer ON Mer.IdMercadoria = Lhs.IdMercadoria
LEFT OUTER JOIN
    cad_Moeda Moe ON Moe.IdMoeda = Lhs.IdMoeda_Mercadoria
LEFT OUTER JOIN
    vis_logistica_prazo Lgp ON Lgp.IdLogistica_House = Lhs.IdLogistica_House AND Lgp.IdConfiguracao_Campo_Livre = 141
LEFT OUTER JOIN (
    -- Subconsulta para obter as informações da viagem de 'Coleta' de forma única por House
    SELECT
        lv.IdLogistica_House,
        MAX(CASE lv.Tipo_Servico WHEN 0 THEN '(Não informado)' WHEN 1 THEN 'Back to back' WHEN 2 THEN 'Consolidado' END) AS Tipo_Servico_Desc,
        MAX(lv.IdOrigem) AS IdOrigem_Coleta,
        MAX(lv.IdDestino) AS IdDestino_Coleta
    FROM
        mov_Logistica_Viagem lv
    WHERE
        lv.Tipo_Viagem = 1 -- Filtrar para viagens do tipo 'Coleta'
    GROUP BY
        lv.IdLogistica_House
) Lvc ON Lvc.IdLogistica_House = Lhs.IdLogistica_House
LEFT OUTER JOIN
    cad_Origem_Destino Ord ON Ord.IdOrigem_Desino = Lvc.IdDestino_Coleta
WHERE
    Atv.IdAtividade = 1510538;
