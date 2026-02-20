SELECT
Lhs.Referencia_Cliente AS Referencia_Cliente,
MAX(Tst.Sigla) as Sigla,
MAX(Tst.Valor_Recebimento_Total) as Valor_Frete_Fcl,
Lhs.Numero_Processo AS Referencia_Tex,
Cne.Numero AS Numero_BL_House,
Lms.Numero_Conhecimento AS Numero_BL_Master,
Orm.Nome AS Origem,
Dst.Nome AS Destino,
Pes.Nome AS Nome_Cliente,
PsaAgencia.Nome AS Armador,
Nvi.Nome AS Navio,
Lms.Data_Previsao_Embarque AS ETD,
Lms.Data_Previsao_Desembarque AS ETA,
SUM(Lme.Quantidade) AS Quantidade_Ctnr,
CAST(Lgt.Navio AS VARCHAR(MAX)) AS Navio_Transbordo,
COALESCE(Fme.Free_Time_House_Destino, '0') AS Free_Time_House_Destino,
Lmc.Number AS Container,
Tf1.Descricao,
CASE
WHEN At1.Situacao = 1 THEN 'Não iniciada' 
WHEN At1.Situacao = 2 THEN 'Em andamento'
WHEN At1.Situacao = 3 THEN 'Paralisada'
WHEN At1.Situacao = 4 THEN 'Concluida'
WHEN At1.Situacao = 5 THEN 'Não realizada'
WHEN At1.Situacao = 6 THEN 'Cancelada'
END AS Concluida_Draft, /*Draft enviado?*/
Tf2.Descricao,
CASE
WHEN At2.Situacao = 1 THEN 'Não iniciada' 
WHEN At2.Situacao = 2 THEN 'Em andamento'
WHEN At2.Situacao = 3 THEN 'Paralisada'
WHEN At2.Situacao = 4 THEN 'Concluida'
WHEN At2.Situacao = 5 THEN 'Não realizada'
WHEN At2.Situacao = 6 THEN 'Cancelada'
END AS Concluida_HBL, /*OHBL enviado?*/
Tf3.Descricao,
CASE
WHEN At3.Situacao = 1 THEN 'Não iniciada' 
WHEN At3.Situacao = 2 THEN 'Em andamento'
WHEN At3.Situacao = 3 THEN 'Paralisada'
WHEN At3.Situacao = 4 THEN 'Concluida'
WHEN At3.Situacao = 5 THEN 'Não realizada'
WHEN At3.Situacao = 6 THEN 'Cancelada'
END AS Concluida_OMBL,/*MBL (MAO) enviado?*/
Tf4.Descricao,
CASE
WHEN At4.Situacao = 1 THEN 'Não iniciada' 
WHEN At4.Situacao = 2 THEN 'Em andamento'
WHEN At4.Situacao = 3 THEN 'Paralisada'
WHEN At4.Situacao = 4 THEN 'Concluida'
WHEN At4.Situacao = 5 THEN 'Não realizada'
WHEN At4.Situacao = 6 THEN 'Cancelada'
END AS Concluida_Manifesto,
CASE
WHEN At5.Situacao = 1 THEN 'Não iniciada' 
WHEN At5.Situacao = 2 THEN 'Em andamento'
WHEN At5.Situacao = 3 THEN 'Paralisada'
WHEN At5.Situacao = 4 THEN 'Concluida'
WHEN At5.Situacao = 5 THEN 'Não realizada'
WHEN At5.Situacao = 6 THEN 'Cancelada'
END AS Originais_Recebidos, /*Originais recebidos?*/
CASE
WHEN Lgp.Valor_Boleano IS NULL THEN 'Não' /*Não marcado*/
WHEN Lgp.Valor_Boleano = 0 THEN 'Não' /*Não marcado*/
ELSE 'Sim'
END AS Ajuste_NCM,
CONVERT(VARCHAR(10), Lgp2.Valor_Data, 103) AS Retificao_CE, /*Retificão CE*/
CONVERT(VARCHAR(10), Lgp3.Valor_Data, 103) AS Conclusao_Retificacao, /*Alteração CE concluida*/
CASE
    WHEN Lhs.Situacao_Agenciamento = 1 THEN 'Processo aberto'
    WHEN Lhs.Situacao_Agenciamento = 2 THEN 'Em andamento'
    WHEN Lhs.Situacao_Agenciamento = 3 THEN 'Liberado faturamento'
    WHEN Lhs.Situacao_Agenciamento = 4 THEN 'Faturado'
    WHEN Lhs.Situacao_Agenciamento = 5 THEN 'Finalizado'
    WHEN Lhs.Situacao_Agenciamento = 6 THEN 'Auditado'
    WHEN Lhs.Situacao_Agenciamento = 7 THEN 'Cancelado'
     END AS Situacao_Agenciamento
FROM
mov_logistica_house AS Lhs
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
cad_Agencia_Maritima_Aerea Ama ON Ama.IdPessoa = Lms.IdAgencia_Maritima_Aerea
Left Outer Join 
cad_Pessoa PsaAgencia ON PsaAgencia.IdPessoa = Ama.IdPessoa
Left Outer Join	
mov_Logistica_Maritima_Equipamento Lme ON Lme.IdLogistica_House = Lhs.IdLogistica_House 
left outer join
cad_Navio Nav ON Nav.IdNavio = Lms.IdCompanhia_Transporte
Left Outer Join	(
SELECT
Lmc.IdLogistica_House,
STRING_AGG(Lmc.Number, ' / ') AS Number,
Lmc.Free_Time_House
FROM
mov_Logistica_Maritima_Container Lmc
GROUP BY
Lmc.IdLogistica_House,
Lmc.Free_Time_House
) Lmc on Lmc.IdLogistica_House = Lhs.IdLogistica_House
LEFT OUTER JOIN 
(SELECT
    Lme.IdLogistica_House,
    STRING_AGG(Lme.Free_Time_House_Destino, ' / ') AS Free_Time_House_Destino
FROM
    mov_Logistica_Maritima_Equipamento Lme
GROUP BY
    Lme.IdLogistica_House) Fme ON Fme.IdLogistica_House = Lhs.IdLogistica_House
left outer join
(SELECT	
Lgv.IdLogistica_House,
STRING_AGG(Nat.Nome, ' / ') AS Navio
FROM
mov_Logistica_viagem Lgv
left outer join
cad_Navio Nat ON Nat.IdNavio = Lgv.IdNavio
WHERE
Lgv.Tipo_Viagem = 5
GROUP BY
Lgv.IdLogistica_House
)Lgt ON Lgt.IdLogistica_House = Lhs.IdLogistica_House
Left Outer Join
mov_Logistica_Maritima_Master Lmm ON Lmm.IdLogistica_Master = Lhs.IdLogistica_Master
Left Outer Join
cad_Navio Nvi ON Nvi.IdNavio = Lmm.IdNavio
Left Outer Join
mov_Atividade At1 ON At1.IdProjeto_Atividade = Lhs.IdProjeto_Atividade and At1.IdTarefa = 839 /*Envio do Draft ao cliente para aprova??o*/
Left Outer Join
cad_Tarefa Tf1 ON Tf1.IdTarefa = At1.IdTarefa
Left Outer Join
mov_Atividade At2 ON At2.IdProjeto_Atividade = Lhs.IdProjeto_Atividade and At2.IdTarefa = 844 /*Enviar HBL original ao cliente*/
Left Outer Join
cad_Tarefa Tf2 ON Tf2.IdTarefa = At2.IdTarefa
Left Outer Join
mov_Atividade At3 ON At3.IdProjeto_Atividade = Lhs.IdProjeto_Atividade and At3.IdTarefa = 1266 /*Envio OMBL editado ao cliente (MAO)*/
Left Outer Join
cad_Tarefa Tf3 ON Tf3.IdTarefa = At3.IdTarefa
Left Outer Join
mov_Atividade At4 ON At4.IdProjeto_Atividade = Lhs.IdProjeto_Atividade and At4.IdTarefa = 1335 /*Envio do Manifesto de baldea??o*/
Left Outer Join
mov_Atividade At5 ON At5.IdProjeto_Atividade = Lhs.IdProjeto_Atividade and At5.IdTarefa = 946 /*Confirmar recebimento dos documentos originais*/
Left Outer Join
cad_Tarefa Tf4 ON Tf4.IdTarefa = At4.IdTarefa
left outer join
vis_logistica_prazo Lgp ON Lgp.IdLogistica_House = Lhs.IdLogistica_House and Lgp.IdConfiguracao_Campo_Livre = 216 /*Ajuste NCM*/
left outer join
vis_logistica_prazo Lgp2 ON Lgp2.IdLogistica_House = Lhs.IdLogistica_House and Lgp2.IdConfiguracao_Campo_Livre = 215 /*Retifica??o de CE*/
left outer join
vis_logistica_prazo Lgp3 ON Lgp3.IdLogistica_House = Lhs.IdLogistica_House and Lgp3.IdConfiguracao_Campo_Livre = 217 /*Conclus?o retifica??o*/
left outer join
(select
Ltx.IdLogistica_House,
Ltx.Valor_Recebimento_Total,
Rcbto.Sigla
from
  mov_Logistica_Taxa Ltx
left outer join
  cad_Moeda Rcbto on Rcbto.IdMoeda = Ltx.IdMoeda_Recebimento
  Where Ltx.IdTaxa_Logistica_Exibicao = 2 /*frete*/) Tst on Tst.IdLogistica_House = Lhs.IdLogistica_House
/*WHERE*/
WHERE
Pes.IdPessoa IN (
        62161,
        58934,
        59126,
        59100,
        59460,
        59066,
        62772,
        49971 ) /*BEL MICRO E ABW*/
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
    PsaAgencia.Nome,
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
    Nvi.Nome,
    Pes.IdPessoa,
    Lhs.Situacao_Agenciamento,
    At5.Situacao,
    Fme.Free_Time_House_Destino
ORDER BY
Lms.Data_Previsao_Desembarque DESC,
Pes.IdPessoa ASC