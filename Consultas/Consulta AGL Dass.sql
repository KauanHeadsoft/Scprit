SELECT
Lhs.Numero_Processo AS Referencia_Agente, /*Referencia Agente Origem*/
Lhs.Referencia_Cliente AS Referencia_Dass, /*Referencia Cliente*/
Cli.Nome AS Cliente, /*Cliente topo Pag*/
Des.Nome AS Despachante, /*Despachante Adianeiro*/
Imp.Nome AS Importador, /*Importador**/
Exp.Nome AS Exportador, /*Exportador*/
	CASE
WHEN Lhs.Tipo_Carga = 1 THEN 'Aereo'
WHEN Lhs.Tipo_Carga = 3 THEN 'FCL'
WHEN Lhs.Tipo_Carga = 4 THEN 'LCL'
	ELSE NULL
	END AS Tipo_Carga, /*Verificar tipo de carga*/
Lmc.Equipamento AS Equipamento, /*tem uma string para juntas os nomes dos equipamentos na mesma linha*/
Lmc.Number AS Container, /*tem uma string para juntas os numeros dos containeres na mesma linha*/
Lmm.Numero_CE, /*Mercante*/
FORMAT(Lmm.Data_CE, 'dd-MM-yyyy') AS [Data CE],
Cia.Nome AS Armador, /*Armador transportadora pode ser pessoa*/
Lms.Numero_Conhecimento AS MBL, 
Cne.Numero AS HBL,
--FORMAT(Lms.Data_Previsao_Embarque, 'dd-MM-yyyy') AS [Previsao Embarque],
--FORMAT(Lms.Data_Embarque, 'dd-MM-yyyy') AS [Data Embarque],
Orm.Nome AS [Porto Origem],
Dst.Nome AS [Porto Destino],
--FORMAT(Lms.Data_Previsao_Desembarque, 'dd-MM-yyyy') AS [Previsao Desembarque],
--FORMAT(Lms.Data_Desembarque, 'dd-MM-yyyy') AS [Data Desembarque],
Lmc.Free_Time_House AS [Free Time House],
Lgt.[PREVISAO EMBARQUE],
Lgt.[DATA EMBARQUE],
Lgt.[PREVISAO DESEMBARQUE],
Lgt.[DATA DESEMBARQUE]


FROM
mov_logistica_house AS Lhs
left outer join
mov_logistica_master Lms ON Lms.IdLogistica_Master = Lhs.IdLogistica_Master
left outer join
cad_pessoa Cli ON Cli.IdPessoa = Lhs.IdCliente
left outer join
cad_pessoa Des ON Des.IdPessoa = Lhs.IdDespachante_Aduaneiro
left outer join
cad_pessoa Imp ON Imp.IdPessoa = Lhs.IdImportador
left outer join
cad_pessoa Agt ON Agt.IdPessoa = Lms.IdAgente_Origem
left outer join
cad_pessoa Exp ON Exp.IdPessoa = Lhs.IdExportador
left outer join(
	SELECT
Lmc.IdLogistica_House,
STRING_AGG(Lmc.Number, ' / ') AS Number,
Lmc.Free_Time_House,
STRING_AGG(Eqm.Descricao, ' / ') AS Equipamento
	FROM
mov_Logistica_Maritima_Container Lmc
Left Outer Join
cad_equipamento_maritimo Eqm ON Eqm.IdEquipamento_Maritimo = Lmc.IdEquipamento_Maritimo
	GROUP BY
Lmc.IdLogistica_House,
Lmc.Free_Time_House
)Lmc ON Lmc.IdLogistica_House = Lhs.IdLogistica_House
left outer join
mov_Logistica_Maritima_Master Lmm ON Lmm.IdLogistica_Master = Lhs.IdLogistica_Master
left outer join
cad_pessoa Cia ON Cia.IdPessoa = Lms.IdCompanhia_Transporte
left outer join
mov_conhecimento_embarque Cne ON Cne.IdLogistica_House = Lhs.IdLogistica_House
left outer join
cad_origem_destino Orm ON Orm.IdOrigem_Destino = Lms.IdOrigem
left outer join
cad_origem_destino Dst ON Dst.IdOrigem_Destino = Lms.IdDestino


left outer join(
	SELECT	
		Lgv.IdLogistica_House,
		STRING_AGG(Nat.Nome, ' / ') as Navio,
		STRING_AGG(FORMAT(Lgv.Data_Previsao_Embarque, 'dd-MM-yyyy'), ' / ') AS [PREVISAO EMBARQUE],
		STRING_AGG(CONVERT(VARCHAR(10), Lgv.Data_Embarque, 105), ' / ') AS [DATA EMBARQUE],
		STRING_AGG(CONVERT(VARCHAR(10), Lgv.Data_Previsao_Desembarque, 105), ' / ') AS [PREVISAO DESEMBARQUE],
		STRING_AGG(CONVERT(VARCHAR(10), Lgv.Data_Desembarque, 105), ' / ') AS [DATA DESEMBARQUE]
	FROM
		mov_Logistica_viagem Lgv
		left outer join
cad_Navio Nat ON Nat.IdNavio = Lgv.IdNavio
	WHERE
		Lgv.Tipo_Viagem = 5
	GROUP BY
		Lgv.IdLogistica_House,
		Nat.Nome
)Lgt on Lgt.IdLogistica_House = Lhs.IdLogistica_House


WHERE
Lms.Modalidade_Processo = 2 /*Maritimo*/
AND
Lhs.Referencia_Cliente LIKE '%Dass%'

--AND
--Lhs.Numero_Processo = 'IM0728-25' /*Processo para teste 'remover esse filtro no final do teste'*/