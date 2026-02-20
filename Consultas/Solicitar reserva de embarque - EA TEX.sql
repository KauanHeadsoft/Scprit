SELECT DISTINCT
Atv.IdAtividade,
Lhs.IdLogistica_House,
Lms.IdLogistica_Master,
Lms.Numero_Conhecimento,
Lhs.Referencia_Externa,
Oro.Nome as Origem,
Ord.Nome as Destino,
Lvo.Data_Previsao_Embarque,
Lhs.Numero_Processo,
/*Carga*/
'' as CARGA,
CAST(Mer.Nome AS VARCHAR(MAX)) as Mercadoria,
Lms.Peso_bruto,
Lam.Peso_Taxado,
Lms.Quantidade_Volumes as Volumes,
    CAST(Moe.Nome AS VARCHAR(MAX)) as Moeda,
    Lhs.Metros_Cubicos,
    Lhs.Quantidade_Volumes,
    Lhs.Valor_Mercadoria,
    Lhs.Importancia_Segurada,
    Lhs.Peso_Bruto,
    CASE Lhs.Seguro WHEN 0 THEN 'Não' WHEN 1 THEN 'Sim' END as Seguro,
    CASE Lhs.Carga_Perigosa WHEN 0 THEN 'Não' WHEN 1 THEN 'Sim' END as Carga_Perigosa,
    Lah.Peso_taxado,
'' as EMBALAGEM,
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
'' as TAXAS,
/*Taxas*/
Lte.Nome as Taxa,
Mop.Sigla as Moeda_Pagamento,
Ltx.Valor_Pagamento_Unitario,
Ltx.Valor_Pagamento_Minimo,

case lms.Modalidade_Pagamento when 1 then 'Collect/Prepaid' when 2 then 'Collect' when 3 then 'Prepaid' when 4 then 'Prepaid abroad' end as Modalidade_Pagamento
FROM
    mov_Atividade Atv
LEFT OUTER JOIN
    mov_Logistica_House Lhs ON Lhs.IdProjeto_Atividade = Atv.IdProjeto_Atividade
LEFT OUTER JOIN
    mov_Logistica_Master Lms ON Lms.IdLogistica_Master = Lhs.IdLogistica_Master
LEFT OUTER JOIN
    mov_Logistica_Viagem Lgv ON Lgv.IdLogistica_House = Lhs.IdLogistica_House
LEFT OUTER JOIN
   mov_Logistica_Viagem Lvo on Lvo.IdLogistica_house = Lhs.IdLogistica_House and Lvo.Tipo_Viagem = 4
LEFT OUTER JOIN
    cad_Origem_Destino Oro on Oro.IdOrigem_Destino = Lvo.IdOrigem
LEFT OUTER JOIN
    cad_Origem_Destino Ord on Ord.IdOrigem_Destino = Lvo.IdDestino
LEFT OUTER JOIN
    cad_Mercadoria Mer ON Mer.IdMercadoria = Lhs.IdMercadoria
LEFT OUTER JOIN
    cad_Moeda Moe ON Moe.IdMoeda = Lhs.IdMoeda_Mercadoria
LEFT OUTER JOIN
    mov_Logistica_Embalagem Lgm ON Lgm.IdLogistica_House = Lhs.IdLogistica_House
LEFT OUTER JOIN
    cad_Tipo_Embalagem Tmb ON Tmb.IdTipo_Embalagem = Lgm.IdTipo_Embalagem
LEFT OUTER JOIN
    mov_Logistica_Aerea_Master Lam on Lam.IdLogistica_Master = Lms.IdLogistica_Master
LEFT OUTER JOIN
    mov_Logistica_Taxa Ltx on Ltx.IdLogistica_House = Lhs.IdLogistica_House
LEFT OUTER JOIN
   cad_Taxa_Logistica_Exibicao Lte on Lte.IdTaxa_Logistica_Exibicao = Ltx.IdTaxa_Logistica_Exibicao AND Lte.IdTaxa_Logistica_Exibicao = 4
LEFT OUTER JOIN
    cad_Moeda Mop on Mop.IdMoeda = Ltx.IdMoeda_Pagamento
LEFT OUTER JOIN
    mov_Logistica_Aerea_House Lah ON Lah.IdLogistica_House = Lhs.IdLogistica_House
WHERE
Atv.IdAtividade = 56107



Select
      Lte.Nome as Taxa_Nome,
      Mop.Sigla as Moeda,
      Ltx.Valor_Pagamento_Unitario as Valor_Unitario,
      SUM(Ltx.Valor_Pagamento_Unitario) OVER() as Total_Pagamento_Unitario,
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
    Atv.IdAtividade = :IdAtividade
AND
Ltx.Origem_Taxa = 1
ORDER BY Lte.Nome">