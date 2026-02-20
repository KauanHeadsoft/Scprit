SELECT
Lhs.Referencia_Cliente as Referencia_Cliente,
Lhs.Numero_Processo as Referencia_Tex,
Cne.Numero as Numero_BL_House,
Lms.Numero_Conhecimento as Numero_BL_Master,
Orm.Nome as Origem,
Dst.Nome as Destino,
Pes.Nome as Nome_Cliente,
Cia.nome as Armador,
Nvi.Nome as Navio,
Lms.Data_Previsao_Embarque as ETD,
Lms.Data_Previsao_Desembarque as ETA,
SUM(Lme.Quantidade) AS Quantidade_Ctnr,
CAST(Lgt.Navio AS VARCHAR(MAX)) AS Navio_Transbordo,
Lmc.Free_Time_House as Free_Time_House,
Lmc.Number as Container,
Tf1.Descricao,
CASE
WHEN At1.Situacao = 4 THEN 'Sim' /*concluida*/
ELSE 'Não'
END AS Concluida_Draft,
Tf2.Descricao,
CASE
WHEN At2.Situacao = 4 THEN 'Sim' /*concluida*/
ELSE 'Não'
END AS Concluida_HBL,
Tf3.Descricao,
CASE
WHEN At3.Situacao = 4 THEN 'Sim' /*concluida*/
ELSE 'Não'
END AS Concluida_OMBL,
Tf4.Descricao,
CASE
WHEN At4.Situacao = 4 THEN 'Sim' /*concluida*/
ELSE 'Não'
END AS Concluida_Manifesto,
CASE
WHEN Lgp.Valor_Boleano IS NULL THEN 'Não' /*Não marcado*/
WHEN Lgp.Valor_Boleano = 0 THEN 'Não' /*Não marcado*/
ELSE 'Sim'
END AS Ajuste_NCM,
Lgp2.Valor_Data AS Retificação_CE,
Lgp3.Valor_Data AS Conclusão_Retificacao
FROM
mov_logistica_house as Lhs
left outer join
cad_Pessoa Pes ON Pes.IdPessoa = Lhs.IdCliente
left outer join
mov_logistica_master Lms ON Lms.IdLogistica_Master = Lhs.IdLogistica_Master
left outer join
mov_Conhecimento_Embarque Cne ON Cne.IdLogistica_House = Lhs.IdLogistica_House
left outer join
cad_Origem_Destino Orm ON Orm.IdOrigem_Destino = Lms.IdOrigem
left outer join
cad_Origem_Destino Dst ON Dst.IdOrigem_Destino = Lms.IdDestino
left outer join
cad_pessoa Cia ON Cia.IdPessoa = Lms.IdCompanhia_Transporte
Left Outer Join	
mov_Logistica_Maritima_Equipamento Lme on Lme.IdLogistica_House = Lhs.IdLogistica_House 
left outer join
cad_Navio Nav ON Nav.IdNavio = Lms.IdCompanhia_Transporte
Left Outer Join	(
SELECT
Lmc.IdLogistica_House,
STRING_AGG(Lmc.Number, ' / ') as Number,
Lmc.Free_Time_House
FROM
mov_Logistica_Maritima_Container Lmc
GROUP BY
Lmc.IdLogistica_House,
Lmc.Free_Time_House
) Lmc on Lmc.IdLogistica_House = Lhs.IdLogistica_House
left outer join(
SELECT	
Lgv.IdLogistica_House,
STRING_AGG(Nat.Nome, ' / ') as Navio
FROM
mov_Logistica_viagem Lgv
left outer join
cad_Navio Nat ON Nat.IdNavio = Lgv.IdNavio
WHERE
Lgv.Tipo_Viagem = 5
GROUP BY
Lgv.IdLogistica_House
)Lgt on Lgt.IdLogistica_House = Lhs.IdLogistica_House
Left Outer Join
mov_Logistica_Maritima_Master Lmm on Lmm.IdLogistica_Master = Lhs.IdLogistica_Master
Left Outer Join
cad_Navio Nvi on Nvi.IdNavio = Lmm.IdNavio
Left Outer Join
mov_Atividade At1 on At1.IdProjeto_Atividade = Lhs.IdProjeto_Atividade and At1.IdTarefa = 839 /*Envio do Draft ao cliente para aprovação*/
Left Outer Join
cad_Tarefa Tf1 on Tf1.IdTarefa = At1.IdTarefa
Left Outer Join
mov_Atividade At2 on At2.IdProjeto_Atividade = Lhs.IdProjeto_Atividade and At2.IdTarefa = 844 /*Enviar HBL original ao cliente*/
Left Outer Join
cad_Tarefa Tf2 on Tf2.IdTarefa = At2.IdTarefa
Left Outer Join
mov_Atividade At3 on At3.IdProjeto_Atividade = Lhs.IdProjeto_Atividade and At3.IdTarefa = 1266 /*Envio OMBL editado ao cliente (MAO)*/
Left Outer Join
cad_Tarefa Tf3 on Tf3.IdTarefa = At3.IdTarefa
Left Outer Join
mov_Atividade At4 on At4.IdProjeto_Atividade = Lhs.IdProjeto_Atividade and At4.IdTarefa = 1335 /*Envio do Manifesto de baldeação*/
Left Outer Join
cad_Tarefa Tf4 on Tf4.IdTarefa = At4.IdTarefa
left outer join
vis_logistica_prazo Lgp ON Lgp.IdLogistica_House = Lhs.IdLogistica_House and Lgp.IdConfiguracao_Campo_Livre = 216 /*Ajuste NCM*/
left outer join
vis_logistica_prazo Lgp2 ON Lgp2.IdLogistica_House = Lhs.IdLogistica_House and Lgp2.IdConfiguracao_Campo_Livre = 215 /*Retificação de CE*/
left outer join
vis_logistica_prazo Lgp3 ON Lgp3.IdLogistica_House = Lhs.IdLogistica_House and Lgp3.IdConfiguracao_Campo_Livre = 217 /*Conclusão retificação*/
/*WHERE*/
WHERE
Pes.IdPessoa = 49971 /*ABW*/
AND
Lms.Modalidade_Processo = 2 /*Maritimo*/
AND
Lms.Tipo_Operacao= 2 /*importacao*/
GROUP BY
Lhs.Referencia_Cliente,
Lhs.Numero_Processo,
Cne.Numero,
Lms.Numero_Conhecimento,
Orm.Nome,
Dst.Nome,
Pes.Nome,
Cia.nome,
Lms.Data_Previsao_Embarque,
Lms.Data_Previsao_Desembarque,
Lmc.Free_Time_House,
Tf1.Descricao,
At1.Situacao,
Tf2.Descricao,
At2.Situacao,
Tf3.Descricao,
At3.Situacao,
Tf4.Descricao,
At4.Situacao,
Lgp.Valor_Boleano,
Lgp2.Valor_Data,
Lgp3.Valor_Data,
Lgt.Navio,
Lmc.Number,
Nvi.Nome
