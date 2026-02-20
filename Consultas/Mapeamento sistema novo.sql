SELECT
	ROW_NUMBER() OVER(PARTITION BY @@ROWCOUNT ORDER BY @@ROWCOUNT) AS Indice,   
    Clta.Origem,
	Ent.Destino,
    Lhs.Numero_Processo,
	Lhs.Data_Abertura_Processo,
	Lhs.Referencia_Cliente,
	Lhs.Observacao as Status,
	Vnd.Nome as Vendedor,
	Cli.Nome as Cliente,
	Inc.Nome as Incoterm,
	Agd.Nome as Agente_Destino,
	CASE WHEN Lms.Master_Direto = 0 Then 'Não'WHEN Lms.Master_Direto = 1 Then 'Sim'END AS Master_Direto,
	Lms.Numero_Conhecimento,
	(Lmh.Total_Container_20 + Lmh.Total_Container_40) AS Total_Containers,
	Lmh.Equipamentos,
	Ctt.Nome as Armador,
	Oft.Numero_Oferta,
	Lhs.Data_Validade_Taxas,
	Ctf.Observacao as Contrato_Frete,
	Lhs.Referencia_Interna,
	CASE WHEN Lms.Modalidade_Pagamento = 2 Then 'Collect' WHEN Lms.Modalidade_Pagamento = 3 Then 'Prepaid' WHEN Lms.Modalidade_Pagamento = 4 Then 'Prepaid Abroad' End AS Modalidade_Pagamento,
	CASE WHEN Lms.Situacao_Embarque = 0 Then 'Pré-processo' WHEN Lms.Situacao_Embarque = 1 Then 'Aguardando embarque' WHEN Lms.Situacao_Embarque = 2 Then 'Embarcado' WHEN Lms.Situacao_Embarque = 3 Then 'Desembarcado' WHEN Lms.Situacao_Embarque = 4 Then 'Cancelado' WHEN Lms.Situacao_Embarque = 5 Then 'Pendente' WHEN Lms.Situacao_Embarque = 6 Then 'Autorizado' WHEN Lms.Situacao_Embarque = 7 Then 'Coletado' WHEN Lms.Situacao_Embarque = 8 Then 'Entregue' WHEN Lms.Situacao_Embarque = 9 Then 'Aguardando prontidão da mercadoria' WHEN Lms.Situacao_Embarque = 10 Then 'Aguardando Booking' WHEN Lms.Situacao_Embarque = 11 Then 'Finalizado' WHEN Lms.Situacao_Embarque = 12 Then 'Aguardando coleta' WHEN Lms.Situacao_Embarque = 13 Then 'Aguardando entrega'End AS Situacao_Embarque,
	Lms.Numero_Reserva,
	Org.Nome AS Origem,
	Dst.Nome AS Destino,
	Nvi.Nome as Navio,
	Lmm.Viagem_Navio,
	Lms.Data_Previsao_Embarque,
	Lms.Data_Previsao_Desembarque,
	Lms.Data_Embarque,
	Lms.Data_Desembarque,
	Lmm.Data_CE,
	Lhs.Data_Averbacao,
	Lhs.Data_Entrega,
	Lhs.Data_Recebimento_Local as Data_Recebimento_Fat,
	Atv.Data_Inicio as Data_Env_Conf,
	Atd.Data_Inicio as Data_Sol_G_Light,
	Ate.Data_Inicio as Data_Conf_Emb_Cli,
	Ata.Data_Inicio as Data_Conf_Emb_Ag,
	Ati.Data_Inicio as Data_Conf_Des,
	Ddc.Valor_Data as Dl_Cliente,
	Dcc.Valor_Data AS Dl_Carga,
	Dda.Valor_Data as Dl_Armador,
	CASE WHEN Lms.Local_Emissao = 1 THEN 'Destino' WHEN Lms.Local_Emissao = 2 THEN 'Express Release' WHEN Lms.Local_Emissao = 3 THEN 'Origem' WHEN Lms.Local_Emissao = 4 THEN 'Sea Waybill' END Local_Emissao,
	Prm.Data_Referencia,
	Prt.Porto_Transbordo,
	Prt.Data_Prev_Chegada_Trb,
	Prt.Data_Prev_Embarque_Trb,
	Prt.Data_Prev_Desembarque_Trb,
	Prt.Data_Desembarque_Trb,
	Prt.Data_Chegada_Trb,
	/*Solicitar Booking*/
	Soc.Tarefa_Booking,
	Soc.Data_Inicio_Booking,
	Soc.Data_Termino_Booking,
	/*Solicitar Draft*/
	Dra.Tarefa_Draft,
	Dra.Data_Inicio_Draft,
	Dra.Data_Termino_Draft,
	/*CONFIRMAR RECEBIMENTO DE DRAFT*/
	Crd.Tarefa_Recebimento,
	Crd.Data_Inicio_Recebimento,
	Crd.Data_Termino_Recebimento,
	/*Envio do Draft para a companhia de transporte*/
	Ctd.Tarefa_Trans,
	Ctd.Data_Inicio_Trans,
	Ctd.Data_Termino_Trans,
	/*Envio do VGM para a companhia de transporte*/
	Vgm.Tarefa_VGM,
	Vgm.Data_Inicio_VGM,
	Vgm.Data_Termino_VGM,
	/*DUE Desembaraçada*/
	Due.Tarefa_DUE,
	Due.Data_Inicio_DUE,
	Due.Data_Termino_DUE,
	/*Confirmação de desembarque no destino*/
	Cdd.Tarefa_Destino,
	Cdd.Data_Inicio_Destino,
	Cdd.Data_Termino_Destino,
	/*Booking Recebido do armador*/
	Bra.Tarefa_Armador,
	Bra.Data_Inicio_Armador,
	Bra.Data_Termino_Armador,
	/*Faturar Processo*/
	Fat.Tarefa_Fatura,
	Fat.Data_Inicio_Fatura,
	Fat.Data_Termino_Fatura,
	/*Valor Fixo Coleta Origem*/
	Pr1.Valor_Data as Valor_Fixo_Cog,
	/*Valor Fixo Coleta Destino*/
	 Pr2.Valor_Data as Valor_Fixo_Cds,
	/*Data Pagamento*/
	Dpg.Valor_Data_Dpg,
	/*Data Recebimento*/
	Drb.Valor_Data_Drb,
	Lhs.Referencia_Externa,
	Imp.Nome as Importador,
	/*PRAZO BOOKING*/
	ETDb.Valor_Data as Booking_ETD,
	ETAb.Valor_Data as Booking_ETA,
	Ftr.Valor_Data as FUP_Tracking,
	/**/
	Prt.Data_Embarque_Trb,
	Prt.Data_Desembarque_Trb

FROM
	mov_Logistica_House Lhs
LEFT OUTER JOIN
	mov_Logistica_Master Lms ON Lms.IdLogistica_Master = Lhs.IdLogistica_Master
LEFT OUTER JOIN
	mov_Logistica_Moeda Lmd ON Lmd.IdLogistica_House = Lhs.IdLogistica_House AND Lmd.IdMoeda = 110
LEFT OUTER JOIN
	cad_Pessoa Vnd ON Vnd.IdPessoa = Lhs.IdVendedor
LEFT OUTER JOIN
	mov_Logistica_Maritima_Master Lmm ON Lmm.IdLogistica_Master = Lms.IdLogistica_Master
LEFT OUTER JOIN
	mov_Logistica_Maritima_House Lmh on Lmh.IdLogistica_House= Lhs.IdLogistica_House
LEFT OUTER JOIN
	cad_Empresa Emp ON Emp.IdEmpresa_Sistema = Lhs.IdEmpresa_Sistema
LEFT OUTER JOIN 
	cad_Pessoa Agd ON Agd.IdPessoa = Lms.IdAgente_Destino
LEFT OUTER JOIN
	cad_Pessoa Eps ON Eps.IdPessoa = Emp.IdPessoa
LEFT OUTER JOIN
	cad_Pessoa Imp ON Imp.IdPessoa = Lhs.IdImportador
LEFT OUTER JOIN
	cad_Pessoa Cli ON Cli.IdPessoa = Lhs.IdCliente
LEFT OUTER JOIN
	cad_Incoterm Inc ON Inc.IdIncoterm = Lhs.IdIncoterm
LEFT OUTER JOIN
	cad_Pessoa Ctt ON Ctt.IdPessoa = Lms.IdCompanhia_Transporte
LEFT OUTER JOIN
	mov_Oferta_Frete Oft ON Oft.IdOferta_Frete = Lhs.IdOferta_Frete
LEFT OUTER JOIN
	mov_Contrato_Frete Ctf ON Ctf.IdContrato_Frete = Oft.IdContrato_Frete
LEFT OUTER JOIN
	cad_Origem_Destino Org ON Org.IdOrigem_Destino = Lms.IdOrigem
LEFT OUTER JOIN
	cad_Origem_Destino Dst ON Dst.IdOrigem_Destino = Lms.IdDestino
LEFT OUTER JOIN
	cad_Navio Nvi ON Nvi.IdNavio = Lmm.IdNavio
LEFT OUTER JOIN
	mov_Atividade Atv ON Atv.IdProjeto_Atividade = Lhs.IdProjeto_Atividade AND Atv.IdTarefa = 362
LEFT OUTER JOIN
	mov_Atividade Atd ON Atd.IdProjeto_Atividade = Lhs.IdProjeto_Atividade AND Atd.IdTarefa = 873
LEFT OUTER JOIN
	mov_Atividade Ate ON Ate.IdProjeto_Atividade = Lhs.IdProjeto_Atividade AND Ate.IdTarefa = 365
LEFT OUTER JOIN
	mov_Atividade Ata ON Ata.IdProjeto_Atividade = Lhs.IdProjeto_Atividade AND Ata.IdTarefa = 369
LEFT OUTER JOIN
	mov_Atividade Ati ON Ati.IdProjeto_Atividade = Lhs.IdProjeto_Atividade AND Ati.IdTarefa = 28
LEFT OUTER JOIN
	vis_Logistica_Prazo Ddc ON Ddc.IdLogistica_House = Lhs.IdLogistica_House AND Ddc.Identificador = 'Deadline_Draft_Cliente'
LEFT OUTER JOIN
	vis_Logistica_Prazo Dda ON Dda.IdLogistica_House = Lhs.IdLogistica_House AND Dda.Identificador = 'DeadLine_Draft_Armador'
LEFT OUTER JOIN
	vis_Logistica_Prazo Dcc ON Dcc.IdLogistica_House = Lhs.IdLogistica_House AND Dcc.Identificador = 'Deadline_Lib_Carga_Cliente'
Left Outer Join
    vis_Logistica_Prazo Pr1 on Pr1.IdLogistica_House = Lhs.IdLogistica_House and Pr1.Identificador = 'Coleta_Origem'
Left Outer Join
    vis_Logistica_Prazo Pr2 on Pr2.IdLogistica_House = Lhs.IdLogistica_House and Pr2.Identificador = 'Coleta_Destino'
Left Outer Join
    vis_Logistica_Prazo ETDb on ETDb.IdLogistica_House = Lhs.IdLogistica_House and ETDb.Identificador = 'ETD_Booking'
Left Outer Join
    vis_Logistica_Prazo ETAb on ETAb.IdLogistica_House = Lhs.IdLogistica_House and ETAb.Identificador = 'ETA_Booking'
LEFT OUTER JOIN
(
  SELECT 
  Lft.IdLogistica_House, 
  Ffn.Data_Vencimento,
  Lft.Data_Faturamento,
  Rfn.Data_Referencia,
  Ffn.Data_Pagamento,
  Sum(Ffn.Valor) Total_Valores 
  FROM 
  mov_Fatura_Financeira Ffn
  LEFT OUTER JOIN
    mov_Logistica_Fatura Lft ON Lft.IdRegistro_Financeiro = Ffn.IdRegistro_Financeiro and Lft.Tipo_Fatura = 1 /*Pagamento Armador*/
  LEFT OUTER JOIN
    mov_Registro_Financeiro Rfn ON Rfn.IdRegistro_Financeiro = Ffn.IdRegistro_Financeiro
  GROUP BY Lft.IdLogistica_House, Ffn.Data_Vencimento,Lft.Data_Faturamento,Rfn.Data_Referencia, Ffn.Data_Pagamento
) Prm ON Prm.IdLogistica_House = Lhs.IdLogistica_House
/*TODOS OS SUBSELECT REFERENTE A ATIVIDADES, ABAIXO*/
LEFT OUTER JOIN (
	SELECT 
	  Lhs.IdLogistica_House,
	  Lhs.Numero_Processo,
	  Taf.Descricao AS Tarefa_Booking,
	  Atv.Data_Inicio AS Data_Inicio_Booking,
	  Atv.Previsao_Inicio AS Previsao_Inicio_Booking,
	  Atv.Previsao_Termino AS Previsao_Termino_Booking,
	  Atv.Data_Termino AS Data_Termino_Booking
	FROM 
	  mov_Logistica_House Lhs
	left outer join 
	  mov_Atividade Atv on Atv.IdProjeto_Atividade = Lhs.IdProjeto_Atividade and Atv.IdTarefa = 361 /*SOLICITAR BOOKING*/ 
	left outer join 
	  cad_Tarefa Taf on Taf.IdTarefa = Atv.IdTarefa) Soc on Soc.IdLogistica_House = Lhs.IdLogistica_House
	left outer join 
	  (SELECT 
	  Lhs.IdLogistica_House,
	  Lhs.Numero_Processo,
	  Taf.Descricao AS Tarefa_Draft,
	  Atv.Previsao_Inicio Previsao_Inicio_Draft,
	  Atv.Data_Inicio AS Data_Inicio_Draft,
	  Atv.Previsao_Termino AS Previsao_Termino_Draft,
	  Atv.Data_Termino AS Data_Termino_Draft
	FROM 
	  mov_Logistica_House Lhs
left outer join 
  mov_Atividade Atv on Atv.IdProjeto_Atividade = Lhs.IdProjeto_Atividade and Atv.IdTarefa = 474 /*SOLICITAR DRAFT*/
left outer join 
  cad_Tarefa Taf on Taf.IdTarefa = Atv.IdTarefa) Dra on Dra.IdLogistica_House = Lhs.IdLogistica_House
Left Outer Join
  mov_Conhecimento_Embarque Cem on Cem.IdLogistica_House = Lhs.IdLogistica_House
left outer join 
  (SELECT 
  Lhs.IdLogistica_House,
  Lhs.Numero_Processo,
  Atv.IdTarefa,
  Taf.Descricao AS Tarefa_Recebimento,
  Atv.Previsao_Inicio AS Previsao_Inicio_Recebimento,
  Atv.Data_Inicio AS Data_Inicio_Recebimento,
  Atv.Previsao_Termino AS Previsao_Termino_Recebimento,
  Atv.Data_Termino AS Data_Termino_Recebimento
FROM 
  mov_Logistica_House Lhs
left outer join 
  mov_Atividade Atv on Atv.IdProjeto_Atividade = Lhs.IdProjeto_Atividade and Atv.IdTarefa =  713 /*CONFIRMAR RECEBIMENTO DO DRAFT*/
left outer join 
  cad_Tarefa Taf on Taf.IdTarefa = Atv.IdTarefa) Crd on Crd.IdLogistica_House = Lhs.IdLogistica_House
left outer join 
  (SELECT 
  Lhs.IdLogistica_House,
  Lhs.Numero_Processo,
  Atv.IdTarefa,
  Taf.Descricao AS Tarefa_Trans,
  Atv.Previsao_Inicio AS Previsao_Inicio_Trans,
  Atv.Data_Inicio AS Data_Inicio_Trans,
  Atv.Previsao_Termino AS Previsao_Termino_Trans,
  Atv.Data_Termino AS Data_Termino_Trans
FROM 
  mov_Logistica_House Lhs
left outer join 
  mov_Atividade Atv on Atv.IdProjeto_Atividade = Lhs.IdProjeto_Atividade and Atv.IdTarefa =  475 /*ENVIO DO DRAFT PARA COMPANHIA DE TRANSPORTE*/
left outer join 
  cad_Tarefa Taf on Taf.IdTarefa = Atv.IdTarefa) Ctd on Ctd.IdLogistica_House = Lhs.IdLogistica_House
left outer join 
  (SELECT 
  Lhs.IdLogistica_House,
  Lhs.Numero_Processo,
  Atv.IdTarefa,
  Taf.Descricao AS Tarefa_VGM,
  Atv.Previsao_Inicio AS Previsao_Inicio_VGM,
  Atv.Data_Inicio AS Data_Inicio_VGM,
  Atv.Previsao_Termino AS Previsao_Termino_VGM,
  Atv.Data_Termino AS Data_Termino_VGM
FROM 
  mov_Logistica_House Lhs
left outer join 
  mov_Atividade Atv on Atv.IdProjeto_Atividade = Lhs.IdProjeto_Atividade and Atv.IdTarefa =  894 /*Envio do VGM para a companhia de transporte*/
left outer join 
  cad_Tarefa Taf on Taf.IdTarefa = Atv.IdTarefa) Vgm on Vgm.IdLogistica_House = Lhs.IdLogistica_House
left outer join 
  (SELECT 
  Lhs.IdLogistica_House,
  Lhs.Numero_Processo,
  Atv.IdTarefa,
  Taf.Descricao AS Tarefa_DUE,
  Atv.Previsao_Inicio AS Previsao_Inicio_DUE,
  Atv.Data_Inicio AS Data_Inicio_DUE,
  Atv.Previsao_Termino AS Previsao_Termino_DUE,
  Atv.Data_Termino AS Data_Termino_DUE
FROM 
  mov_Logistica_House Lhs
left outer join 
  mov_Atividade Atv on Atv.IdProjeto_Atividade = Lhs.IdProjeto_Atividade and Atv.IdTarefa =  876 /*DUE Desembaraçada*/
left outer join 
  cad_Tarefa Taf on Taf.IdTarefa = Atv.IdTarefa) Due on Due.IdLogistica_House = Lhs.IdLogistica_House
left outer join 
  (SELECT 
  Lhs.IdLogistica_House,
  Lhs.Numero_Processo,
  Atv.IdTarefa,
  Taf.Descricao AS Tarefa_Armador,
  Atv.Previsao_Inicio AS Previsao_Inicio_Armador,
  Atv.Data_Inicio Data_Inicio_Armador,
  Atv.Previsao_Termino AS Previsao_Termino_Armador,
  Atv.Data_Termino AS Data_Termino_Armador
FROM 
  mov_Logistica_House Lhs
left outer join 
  mov_Atividade Atv on Atv.IdProjeto_Atividade = Lhs.IdProjeto_Atividade and Atv.IdTarefa =  938 /*Booking Recebido do armador*/
left outer join 
  cad_Tarefa Taf on Taf.IdTarefa = Atv.IdTarefa) Bra on Bra.IdLogistica_House = Lhs.IdLogistica_House

left outer join 
  (SELECT 
  Lhs.IdLogistica_House,
  Lhs.Numero_Processo,
  Atv.IdTarefa,
  Taf.Descricao AS Tarefa_Destino,
  Atv.Previsao_Inicio AS Previsao_Inicio_Destino,
  Atv.Data_Inicio AS Data_Inicio_Destino,
  Atv.Previsao_Termino AS Previsao_Termino_Destino,
  Atv.Data_Termino AS Data_Termino_Destino
FROM 
  mov_Logistica_House Lhs
left outer join 
  mov_Atividade Atv on Atv.IdProjeto_Atividade = Lhs.IdProjeto_Atividade and Atv.IdTarefa =  373 /*Confirmação de desembarque no destino*/
left outer join 
  cad_Tarefa Taf on Taf.IdTarefa = Atv.IdTarefa) Cdd on Cdd.IdLogistica_House = Lhs.IdLogistica_House
left outer join 
  (SELECT 
  Lhs.IdLogistica_House,
  Lhs.Numero_Processo,
  Atv.IdTarefa,
  Taf.Descricao AS Tarefa_Fatura,
  Atv.Previsao_Inicio AS Previsao_Inicio_Fatura,
  Atv.Data_Inicio AS Data_Inicio_Fatura,
  Atv.Previsao_Termino AS Previsao_Termino_Fatura,
  Atv.Data_Termino AS Data_Termino_Fatura
FROM 
  mov_Logistica_House Lhs
left outer join 
  mov_Atividade Atv on Atv.IdProjeto_Atividade = Lhs.IdProjeto_Atividade and Atv.IdTarefa =  529 /*Faturar Processo*/
left outer join 
  cad_Tarefa Taf on Taf.IdTarefa = Atv.IdTarefa) Fat on Fat.IdLogistica_House = Lhs.IdLogistica_House
Left Outer Join(
  SELECT
    Lgv.IdLogistica_Viagem,
    Lgv.IdLogistica_House,
    Lgv.Numero_Controle,
    Lgv.Numero_Conhecimento,
    Lgv.Situacao_Embarque,
    Lgv.Data_Previsao_Embarque as Data_Prev_Embarque_Trb,
    Lgv.Data_Previsao_Desembarque as Data_Prev_Desembarque_Trb,
    Nvi.Nome as Navio_Transbordo,
    Lgv.Data_Embarque as Data_Embarque_Trb,
    Van.Data_Previsao_Desembarque AS Data_Prev_Chegada_Trb,
    Van.Data_Desembarque AS Data_Chegada,
    Lgv.Viagem_Voo as Viagem,
    Lgv.Data_Desembarque as Data_Desembarque_Trb,
    Lgv.Data_Desembarque as Data_Chegada_Trb,
    Lgv.Observacao,
    Org.Nome as Porto_Transbordo,
    Dst.Nome as Porto_Desembarque,
    Rank() Over (Partition By Lgv.IdLogistica_House Order By Lgv.IdLogistica_House, Van.Data_Previsao_Desembarque Desc, Lgv.IdLogistica_Viagem)As Ranking
  FROM
    mov_Logistica_Viagem Lgv
  JOIN
    mov_Logistica_Viagem Van on Van.IdLogistica_House = Lgv.IdLogistica_House AND Van.Sequencia = Lgv.Sequencia - 1
  Left Outer Join
    cad_Navio Nvi on Nvi.IdNavio = Lgv.IdNavio
  Left Outer Join
    cad_Origem_Destino Org on Org.IdOrigem_Destino = Lgv.IdOrigem
  Left Outer Join
    cad_Origem_Destino Dst on Dst.IdOrigem_Destino = Lgv.IdDestino

  WHERE
  Lgv.Tipo_Viagem = 5 /*Transbordo Escala*/) Prt on Prt.IdLogistica_House = Lhs.IdLogistica_House And Prt.Ranking = 1
/*INICIO CAMPO LIVRE*/
Left Outer Join (
  SELECT
  Lhs.IdLogistica_House,
  Mcl.Valor_Data AS Valor_Data_Dpg
FROM
  mov_Campo_Livre Mcl
Left Outer Join
  mov_Logistica_prazo Lpz ON Lpz.IdCampo_Livre = Mcl.IdCampo_Livre
Left Outer Join
  mov_Logistica_House Lhs ON Lhs.IdLogistica_House = Lpz.IdLogistica_House
Left Outer Join
  mov_Logistica_Master Lms ON Lms.IdLogistica_Master = Lhs.IdLogistica_Master

Where
  Mcl.IdConfiguracao_Campo_Livre = 152) Dpg ON Dpg.IdLogistica_House = Lhs.IdLogistica_House /*Data Pagamento*/
Left Outer Join (
  SELECT
  Lhs.IdLogistica_House,
  Mcl.Valor_Data AS Valor_Data_Drb
FROM
  mov_Campo_Livre Mcl
Left Outer Join
  mov_Logistica_prazo Lpz ON Lpz.IdCampo_Livre = Mcl.IdCampo_Livre
Left Outer Join
  mov_Logistica_House Lhs ON Lhs.IdLogistica_House = Lpz.IdLogistica_House
Left Outer Join
  mov_Logistica_Master Lms ON Lms.IdLogistica_Master = Lhs.IdLogistica_Master

Where
  Mcl.IdConfiguracao_Campo_Livre = 153) Drb ON Drb.IdLogistica_House = Lhs.IdLogistica_House /*Data Pagamento*/
Left Outer Join
    vis_Logistica_Prazo Ftr on Ftr.IdLogistica_House = Lhs.IdLogistica_House and Ftr.Identificador = 'FUP_Tracking'
Left Outer Join(
	Select
		Lgv.IdLogistica_House,
		Orm.Nome as Origem
	From
		mov_Logistica_Viagem Lgv
	Left Outer Join
		cad_Origem_Destino Orm on Orm.IdOrigem_Destino = Lgv.IdOrigem
	Where
		COALESCE(Lgv.Tipo_Viagem, 4) IN (1, 4/*Coleta*/)) Clta on Clta.IdLogistica_House = Lhs.IdLogistica_House

Left Outer Join(
	Select
		Lgv.IdLogistica_House,
		Dst.Nome as Destino
	From
		mov_Logistica_Viagem Lgv
	Left Outer Join
		cad_Origem_Destino Dst on Dst.IdOrigem_Destino = Lgv.IdDestino
	Where
		Lgv.Tipo_viagem = 8/*Entrega*/
) Ent on Ent.IdLogistica_House = Lhs.IdLogistica_House
/*WHERE*/