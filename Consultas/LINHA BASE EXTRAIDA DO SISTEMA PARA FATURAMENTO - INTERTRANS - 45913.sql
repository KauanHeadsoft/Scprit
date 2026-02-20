SELECT 
  Tst.Numero_Processo,
  Tst.Responsavel_Operacional,
  Tst.Cliente,
  Tst.Exportador,
  Tst.Despachante,
  Tst.Referencia_Cliente,
  Tst.Consignatario,
  Tst.Booking,
  Tst.Conf,
  Tst.Data_Retirada_Container,
  Tst.Local_Retirada_Container,
  Tst.Local_Entrega_Container,
  Tst.Numero_Container,
  Tst.Deadline_Draft,
  '' as Dummy_1,
  Tst.Envio_Draft_BL,
  Tst.Liberacao_BL, /*deve buscar house*/
  Tst.Deadline_VGM,
  '' as Dummy_2,
  Tst.Envio_VGM,
  Tst.Deadline_Carga,
  '' as Dummy_3,
  Tst.Data_Deposito_Container,
  Tst.Numero_MBL,
  Tst.Numero_HBL,
  Tst.Mercadoria,
  Tst.Navio,
  Tst.Viagem_Navio,
  Tst.Origem,
  Tst.Destino,
  Tst.Pais_Destino,
  Tst.Via,
  Tst.Data_Saida,
  Tst.Fatura_Frete_Compra,
  Tst.Fatura_Locais_Compra,
  Tst.Dias_Em_Aberto_C,
  Tst.Fatura_Frete_Venda,
  Tst.Fatura_Locais_Venda,
  Tst.Data_Chegada,
  Tst.Aviso_Chegada,
  Tst.Companhia_Transporte,
  Tst.Dias_Em_Aberto_V,
  Tst.Agente_Internacional,
  Tst.Valor_Compra_Unitario,
  Tst.Valor_Compra_Total,
  Tst.Free_Detention_Compra,
  Tst.PP_CC_PA,
  Tst.Valor_Venda_Unitaria,
  Tst.Valor_Venda_Total,
  Tst.Free_Dentention_Venda,
  Tst.Qtde_Cntr,
  Tst.Dias_Detention,
  Tst.Profit_USD,
  Tst.Equipamento,
  Tst.Frete_Agente_Pgto,
  Tst.BL_BRL_Pagamento,
  Tst.THC_Pagamento,
  Tst.Total_THC_Pagamento,
  Tst.Taxas_BRL_Pagamento,
  Tst.Taxas_USD_Pagamento,
  Tst.Taxas_EUR_Pagamento,
  Tst.Total_Detention_Pgto,
  Tst.Taxa_Cambio_USD_Pgto,
  Tst.Total_BRL_Pagamento,
  Tst.Data_Pagamento,
  Tst.Frete_Agente_Rcbto,
  Tst.BL_BRL_Recebimento,
  Tst.THC_Recebimento,
  Tst.Total_THC_Recebimento,
  Tst.Taxas_BRL_Recebimento,
  Tst.Taxas_USD_Recebimento,
  Tst.Taxas_EUR_Recebimento,
  Tst.Total_Detention_Rcbto,
  Tst.Taxa_Cambio_USD_Rcbto,
  Tst.Outras_Taxas_BRL,
  Tst.Total_BRL_Recebimento,
  Tst.Data_Recebimento,
  Tst.Frete_C,
  Tst.Locais_C,
  Tst.Fatura,
  Tst.Vencimento_C,
  Tst.Frete_V,
  Tst.Locais_V,
  Tst.Taxas_Banco,
  Tst.Profit_Liquido,
  Tst.Fatura_Cliente,
  Tst.Vencimento_V,
  Tst.Vendedor,
  Tst.Data_Reserva,
  Tst.Observaçoes
FROM 
(SELECT 
  Lhs.Data_Abertura_Processo,
  Lhs.Numero_Processo,
  Rsp.Nome AS Responsavel_Operacional,
  Cli.Nome AS Cliente,
  Exp.Nome AS Exportador,
  Dpc.Nome AS Despachante,
  Lhs.Referencia_Cliente,
  Imp.Nome AS Consignatario,
  Lms.Numero_Reserva AS Booking,
  CASE WHEN Lms.Numero_Reserva IS NULL THEN 'NÃO' ELSE 'SIM' END Conf,
  Lmc.Data_Retirada_Container,
  Trr.Nome AS Local_Retirada_Container,
  Tra.Nome AS Local_Entrega_Container,
  Lmc.Numero_Container,
  Drc.Valor_Data as Deadline_Draft,
  '' AS Envio_Draft_BL,
  CASE 
    WHEN Bil.Originals = 1 THEN 'Destino' 
    WHEN Bil.Originals = 2 THEN 'Express release' 
    WHEN Bil.Originals = 3 THEN 'Origem' 
    WHEN Bil.Originals = 4 THEN 'Sea waybill' 
    WHEN Bil.Originals = 5 THEN 'Outro' 
  END AS Liberacao_BL,
  '' AS Deadline_VGM,
  '' AS Envio_VGM,
  '' AS Deadline_Carga,
  Lmc.Data_Deposito_Container,
  Lms.Numero_Conhecimento AS Numero_MBL,
  Lhs.Conhecimentos AS Numero_HBL,
  Mer.Nome AS Mercadoria,
  Nav.Nome AS Navio,
  Lmm.Viagem_Navio,
  Org.Nome AS Origem,
  Dst.Nome AS Destino,
  Pdt.Nome AS Pais_Destino,
  Ult.Nome AS Via,
  Lms.Data_Embarque AS Data_Saida,
  '' AS Fatura_Frete_Compra,
  '' AS Fatura_Locais_Compra,
  '' AS Dias_Em_Aberto_C,
  '' AS Fatura_Frete_Venda,
  '' AS Fatura_Locais_Venda,
  Lms.Data_Desembarque AS Data_Chegada,
  Lms.Data_Previsao_Desembarque as Data_Previsao_Chegada, /*campo adicionado*/
  Lms.Transit_Time AS Aviso_Chegada,
  Cia.Nome AS Companhia_Transporte,
  '' AS Dias_Em_Aberto_V, 
  Agd.Nome AS Agente_Internacional,
  Vlp.Valor_Pagamento_Unitario AS Valor_Compra_Unitario,
  Vlt.Valor_Compra_Total,
  Lmc.Free_Detention_Compra,
  CASE 
    WHEN Lms.Modalidade_Pagamento = 1 THEN 'Collect/Prepaid'
    WHEN Lms.Modalidade_Pagamento = 2 THEN 'Collect'
    WHEN Lms.Modalidade_Pagamento = 3 THEN 'Prepaid'
    WHEN Lms.Modalidade_Pagamento = 4 THEN 'Prepaid abroad'
  END AS PP_CC_PA,
  Vlp.Valor_Recebimento_Unitario AS Valor_Venda_Unitaria,
  Vlt.Valor_Venda_Total,
  Lmc.Free_Dentention_Venda,
  Cnt.Qtde_Cntr,
  Lmc.Dias_Detention,
  (Vlt.Valor_Venda_Total - Vlt.Valor_Compra_Total) AS Profit_USD,
  Eqm.Descricao AS Equipamento,
  Fra.Valor_Compra_Total AS Frete_Agente_Pgto,
  Lib.Valor_Compra_Total AS BL_BRL_Pagamento,
  Thc.Valor_Pagamento_Unitario AS THC_Pagamento,
  Thc.Valor_Compra_Total AS Total_THC_Pagamento,
  Txs.Taxas_BRL_Pagamento,
  Txu.Taxas_USD_Pagamento,
  Txe.Taxas_EUR_Pagamento,
  Lmc.Total_Detention_Pagamento AS Total_Detention_Pgto,
  '' AS Taxa_Cambio_USD_Pgto,
  Ttb.Total_BRL_Pagamento,
  '' AS Data_Pagamento,
  Frv.Valor_Venda_Total AS Frete_Agente_Rcbto,
  Lir.Valor_Venda_Total AS BL_BRL_Recebimento,
  Thr.Valor_Recebimento_Unitario AS THC_Recebimento,
  Thr.Valor_Venda_Total AS Total_THC_Recebimento,
  Txr.Taxas_BRL_Recebimento, 
  Tru.Taxas_USD_Recebimento,
  Tre.Taxas_EUR_Recebimento,
  Lmc.Total_Detention_Recebimento AS Total_Detention_Rcbto,
  '' AS Taxa_Cambio_USD_Rcbto,
  '' AS Outras_Taxas_BRL,
  Trc.Total_BRL_Recebimento,
  '' AS Data_Recebimento,
  '' AS Frete_C,
  '' AS Locais_C, 
  '' AS Fatura,
  '' AS Vencimento_C,
  '' AS Frete_V,
  '' AS Locais_V, 
  '' AS Taxas_Banco,
  (Trc.Total_BRL_Recebimento - Ttb.Total_BRL_Pagamento) AS Profit_Liquido,
  '' AS Fatura_Cliente,
  '' AS Vencimento_V,
  Vnd.Nome AS Vendedor,
  '' AS Data_Reserva,
  Ctf.Numero_Contrato AS Observaçoes 
FROM 
  mov_Logistica_House Lhs 
LEFT OUTER JOIN 
  mov_Logistica_Master Lms on Lms.IdLogistica_Master = Lhs.IdLogistica_Master
LEFT OUTER JOIN 
  mov_Logistica_Maritima_Master Lmm on Lmm.IdLogistica_Master = Lms.IdLogistica_Master
LEFT OUTER JOIN 
  cad_Navio Nav on Nav.IdNavio = Lmm.IdNavio
LEFT OUTER JOIN 
  vis_Bill_Lading Bil on Bil.IdLogistica_House = Lhs.IdLogistica_House 
LEFT OUTER JOIN 
  mov_Contrato_Frete Ctf on Ctf.IdContrato_Frete = Lhs.IdContrato_Frete
LEFT OUTER JOIN
  mov_Projeto_Atividade Pat on Pat.IdProjeto_Atividade = Lhs.IdProjeto_Atividade
LEFT OUTER JOIN
  mov_Projeto_Atividade_Responsavel Par on Par.IdProjeto_Atividade = Pat.IdProjeto_Atividade And Par.IdPapel_Projeto = 2 /*OPERACIONAL*/
LEFT OUTER JOIN 
  cad_Pessoa Rsp on Rsp.IdPessoa = Par.IdResponsavel
LEFT OUTER JOIN 
  cad_Pessoa Cli on Cli.IdPessoa = Lhs.IdCliente
LEFT OUTER JOIN 
  cad_Pessoa Exp on Exp.IdPessoa = Lhs.IdExportador
LEFT OUTER JOIN 
  cad_Pessoa Dpc on Dpc.IdPessoa = Lhs.IdDespachante_Aduaneiro
LEFT OUTER JOIN 
  cad_Pessoa Imp on Imp.IdPessoa = Lhs.IdImportador /*Consignatário*/
LEFT OUTER JOIN 
  cad_Pessoa Vnd on Vnd.IdPessoa = Lhs.IdVendedor
LEFT OUTER JOIN 
  (SELECT 
    ROW_NUMBER() OVER(PARTITION BY Lmc.IdLogistica_House ORDER BY Lmc.IdLogistica_Maritima_Container DESC) AS Indice,
    Lmc.IdLogistica_House,
    Lmc.Data_Descarga_Retirada AS Data_Retirada_Container,
    Lmc.Number AS Numero_Container,
    Lmc.Data_Devolucao AS Data_Deposito_Container,
    Lmc.Free_Time_Master AS Free_Detention_Compra,
    Lmc.Free_Time_House AS Free_Dentention_Venda,
    DATEDIFF(DAY, Lmc.Data_Descarga_Retirada, Lmc.Data_Devolucao) + 1 AS Dias_Detention,
    ((DATEDIFF(DAY, Lmc.Data_Incidencia_Pagamento, Lmc.Data_Devolucao) + 1) - Lmc.Free_Time_Master) AS Total_Detention_Pagamento,
    ((DATEDIFF(DAY, Lmc.Data_Incidencia_Recebimento, Lmc.Data_Devolucao) + 1) - Lmc.Free_Time_House) AS Total_Detention_Recebimento
  FROM
    mov_Logistica_Maritima_Container Lmc) Lmc on Lmc.IdLogistica_House = Lhs.IdLogistica_House AND Lmc.Indice = 1   
LEFT OUTER JOIN 
  cad_Pessoa Tra on Tra.IdPessoa = Lmm.IdTerminal_Atracacao
LEFT OUTER JOIN 
  cad_Pessoa Trr on Trr.IdPessoa = Lmm.IdTerminal_Retirada_Redestinar
LEFT OUTER JOIN 
  vis_Logistica_Prazo Drc On (Drc.IdLogistica_House = Lhs.IdLogistica_House) And (Drc.Identificador Like 'DEADLINE_DRAFT_CLIENTE')
LEFT OUTER JOIN 
  cad_Mercadoria Mer on Mer.IdMercadoria = Lhs.IdMercadoria
LEFT OUTER JOIN 
  cad_Origem_Destino Org on Org.IdOrigem_Destino = Lms.IdOrigem
LEFT OUTER JOIN 
  cad_Origem_Destino Dst on Dst.IdOrigem_Destino = Lms.IdDestino 
LEFT OUTER JOIN 
  cad_Pais Pdt on Pdt.IdPais = Dst.IdPais
LEFT OUTER JOIN 
  cad_Origem_Destino Dsf on Dsf.IdOrigem_Destino = Lms.IdDestino_Final
LEFT OUTER JOIN 
  mov_Logistica_Viagem Lvg on Lvg.IdLogistica_House = Lhs.IdLogistica_House AND Lvg.Ultima_Viagem = 1 
LEFT OUTER JOIN 
  cad_Origem_Destino Ult on Ult.IdOrigem_Destino = Lvg.IdOrigem
LEFT OUTER JOIN 
  cad_Pessoa Cia on Cia.IdPessoa = Lms.IdCompanhia_Transporte
LEFT OUTER JOIN 
  cad_Pessoa Agd on Agd.IdPessoa = Lms.IdAgente_Destino
/*VALOR UNITARIO DA TAXA DO FRETE*/
LEFT OUTER JOIN 
  (SELECT 
    Ltx.IdLogistica_House,
    Tle.Nome As Taxa,
    /*PAGAMENTO*/
    Mpg.Sigla AS Moeda_Frete_Pagamento,
    Ltx.Valor_Pagamento_Unitario,
    Ltx.Valor_Pagamento_Total,
    /*RECEBIMENTO*/
    Mrc.Sigla AS Moead_Frete_Recebimento,
    Ltx.Valor_Recebimento_Unitario,
    Ltx.Valor_Recebimento_Total
  FROM 
    vis_Logistica_taxa Ltx
  LEFT OUTER JOIN 
    cad_Taxa_Logistica_Exibicao Tle on Tle.IdTaxa_Logistica_Exibicao = Ltx.IdTaxa_Logistica_Exibicao 
  LEFT OUTER JOIN 
    cad_Moeda Mpg on Mpg.IdMoeda = Ltx.IdMoeda_Pagamento
  LEFT OUTER JOIN 
    cad_Moeda Mrc on Mrc.IdMoeda = Ltx.IdMoeda_Recebimento
  WHERE 
    Tle.IdTaxa_Logistica_Exibicao = 2 /*FRETE MARITIMO*/) Vlp on Vlp.IdLogistica_House = Lhs.IdLogistica_House 
LEFT OUTER JOIN
   (SELECT 
    Ltx.IdLogistica_House,
    /*PAGAMENTO*/
    SUM(Ltx.Valor_Pagamento_Total) AS Valor_Compra_Total,
    /*RECEBIMENTO*/
    SUM(Ltx.Valor_Recebimento_Total) AS Valor_Venda_Total
  FROM 
    vis_Logistica_taxa Ltx
  LEFT OUTER JOIN 
    cad_Taxa_Logistica_Exibicao Tle on Tle.IdTaxa_Logistica_Exibicao = Ltx.IdTaxa_Logistica_Exibicao 
  LEFT OUTER JOIN 
    cad_Moeda Mpg on Mpg.IdMoeda = Ltx.IdMoeda_Pagamento
  LEFT OUTER JOIN 
    cad_Moeda Mrc on Mrc.IdMoeda = Ltx.IdMoeda_Recebimento
  WHERE 
    Ltx.Origem_Taxa = 1 /*Frete*/
  GROUP BY 
    Ltx.IdLogistica_House) Vlt on Vlt.IdLogistica_House = Lhs.IdLogistica_House
LEFT OUTER JOIN 
  (SELECT 
     Lmc.IdLogistica_House,
     COUNT(Lmc.IdLogistica_Maritima_Container) AS Qtde_Cntr
   FROM 
     mov_Logistica_Maritima_Container Lmc 
   GROUP BY 
     Lmc.IdLogistica_House) Cnt on Cnt.IdLogistica_House = Lhs.IdLogistica_House 
LEFT OUTER JOIN  
  mov_Logistica_Maritima_Equipamento Lme on Lme.IdLogistica_House = Lhs.IdLogistica_House 
LEFT OUTER JOIN 
  cad_Equipamento_Maritimo Eqm on Eqm.IdEquipamento_Maritimo = Lme.IdEquipamento_Maritimo
LEFT OUTER JOIN 
  (SELECT 
  Ltx.IdLogistica_House,
  SUM(Ltx.Valor_Pagamento_Total) AS Valor_Compra_Total
FROM 
  vis_Logistica_taxa Ltx
WHERE 
  Ltx.Pagar_Para = 3 /*AGENTE NO DESTINO*/
GROUP BY 
  Ltx.IdLogistica_House) Fra on Fra.IdLogistica_House = Lhs.IdLogistica_House /*TOTAL DE PAGAMENTO PARA O AGENTE NO DESTINO*/
LEFT OUTER JOIN 
  (SELECT 
  Ltx.IdLogistica_House,
  Ltx.Valor_Pagamento_Total AS Valor_Compra_Total
FROM 
  vis_Logistica_taxa Ltx
WHERE 
  Ltx.IdTaxa_Logistica_Exibicao = 6 /*LIBERAÇÃO DE BL*/) Lib on Lib.IdLogistica_House = Lhs.IdLogistica_House  /*TOTAL DE PAGAMENTO DA TAXA LIBERAÇÃO DE BL*/ 
LEFT OUTER JOIN 
  (SELECT 
  Ltx.IdLogistica_House,
  Ltx.Valor_Pagamento_Unitario,
  Ltx.Valor_Pagamento_Total AS Valor_Compra_Total
FROM 
  vis_Logistica_taxa Ltx
WHERE 
  (Ltx.IdTaxa_Logistica_Exibicao in (113,7,49)) /*THC ORIGEM - CAPATAZIA FCL - LCL*/) Thc on Thc.IdLogistica_House = Lhs.IdLogistica_House  /*TOTAL DE PAGAMENTO DA TAXA THC ORIGEM*/ 
LEFT OUTER JOIN 
  (SELECT 
  Ltx.IdLogistica_House,
  SUM(Ltx.Valor_Pagamento_Total) AS Taxas_BRL_Pagamento
FROM 
  vis_Logistica_taxa Ltx
WHERE 
  Ltx.Origem_Taxa = 2 /*ORIGEM*/
  AND Ltx.IdMoeda_Pagamento = 20 /*BRL*/
  AND Ltx.IdTaxa_Logistica_Exibicao not in (2, 6, 7, 49, 113) /*FRETE - BL - THC/CAPATAZIA FCL - LCL*/
GROUP BY 
  Ltx.IdLogistica_House) Txs on Txs.IdLogistica_House = Lhs.IdLogistica_House /*TOTAL PAGAMENTO DAS TAXAS DE ORIGEM EM BRL*/
LEFT OUTER JOIN 
  (SELECT 
  Ltx.IdLogistica_House,
  SUM(Ltx.Valor_Pagamento_Total) AS Taxas_USD_Pagamento
FROM 
  vis_Logistica_taxa Ltx
WHERE 
  Ltx.Origem_Taxa = 2 /*ORIGEM*/
  AND Ltx.IdMoeda_Pagamento = 141 /*USD*/
GROUP BY 
  Ltx.IdLogistica_House) Txu on Txu.IdLogistica_House = Lhs.IdLogistica_House /*TOTAL PAGAMENTO DAS TAXAS DE ORIGEM EM USD*/
LEFT OUTER JOIN 
  (SELECT 
  Ltx.IdLogistica_House,
  SUM(Ltx.Valor_Pagamento_Total) AS Taxas_EUR_Pagamento
FROM 
  vis_Logistica_taxa Ltx
WHERE 
  Ltx.Origem_Taxa = 2 /*ORIGEM*/
  /*AND Ltx.IdMoeda_Pagamento = 43 /*EUR*/ REQ #45683*/
GROUP BY 
  Ltx.IdLogistica_House) Txe on Txe.IdLogistica_House = Lhs.IdLogistica_House /*TOTAL PAGAMENTO DAS TAXAS DE ORIGEM EM EUR*/
LEFT OUTER JOIN
  (SELECT 
  Ltx.IdLogistica_House,
  SUM(Ltx.Valor_Pagamento_Corrente) AS Total_BRL_Pagamento
FROM 
  vis_Logistica_taxa Ltx
GROUP BY 
  Ltx.IdLogistica_House) Ttb on Ttb.IdLogistica_House = Lhs.IdLogistica_House /*TOTAL DAS TAXAS DE PAGAMENTO EM BRL*/
LEFT OUTER JOIN 
  (SELECT 
    Ltx.IdLogistica_House,
    SUM(Ltx.Valor_Recebimento_Total) AS Valor_Venda_Total
  FROM 
    vis_Logistica_taxa Ltx
  WHERE 
    Ltx.Receber_De = 2 /*AGENTE NO DESTINO*/
  GROUP BY 
    Ltx.IdLogistica_House) Frv on Frv.IdLogistica_House = Lhs.IdLogistica_House /*TOTAL DE RECEBIMENTO PARA O AGENTE NO DESTINO*/
LEFT OUTER JOIN 
  (SELECT 
    Ltx.IdLogistica_House,
    Ltx.Valor_Recebimento_Total AS Valor_Venda_Total
  FROM 
    vis_Logistica_taxa Ltx
  WHERE 
    Ltx.IdTaxa_Logistica_Exibicao = 6 /*LIBERAÇÃO DE BL*/) Lir on Lir.IdLogistica_House = Lhs.IdLogistica_House  /*TOTAL DE RECEBIMENTO DA TAXA LIBERAÇÃO DE BL*/ 
LEFT OUTER JOIN 
  (SELECT 
    Ltx.IdLogistica_House,
    Ltx.Valor_Recebimento_Unitario,
    Ltx.Valor_Recebimento_Total AS Valor_Venda_Total
  FROM 
    vis_Logistica_taxa Ltx
  WHERE 
    (Ltx.IdTaxa_Logistica_Exibicao in (113,7,49)) /*THC ORIGEM - CAPATAZIA FCL - LCL*/) Thr on Thr.IdLogistica_House = Lhs.IdLogistica_House  /*TOTAL DE RECEBIMENTO DA TAXA THC ORIGEM*/ 
LEFT OUTER JOIN 
  (SELECT 
    Ltx.IdLogistica_House,
    SUM(Ltx.Valor_Recebimento_Total) AS Taxas_BRL_Recebimento
  FROM 
    vis_Logistica_taxa Ltx
  WHERE 
    Ltx.Origem_Taxa = 2 /*ORIGEM*/
    AND Ltx.IdMoeda_Recebimento = 20 /*BRL*/
    AND Ltx.IdTaxa_Logistica_Exibicao not in (2, 6, 7, 49, 113) /*FRETE - BL - THC/CAPATAZIA FCL - LCL*/
  GROUP BY 
    Ltx.IdLogistica_House) Txr on Txr.IdLogistica_House = Lhs.IdLogistica_House /*TOTAL RECEBIMENTO DAS TAXAS DE ORIGEM EM BRL*/
LEFT OUTER JOIN 
  (SELECT 
    Ltx.IdLogistica_House,
    SUM(Ltx.Valor_Recebimento_Total) AS Taxas_USD_Recebimento
  FROM 
    vis_Logistica_taxa Ltx
  WHERE 
    Ltx.Origem_Taxa = 2 /*ORIGEM*/
    AND Ltx.IdMoeda_Recebimento = 141 /*USD*/
  GROUP BY 
    Ltx.IdLogistica_House) Tru on Tru.IdLogistica_House = Lhs.IdLogistica_House /*TOTAL RECEBIMENTO DAS TAXAS DE ORIGEM EM USD*/
LEFT OUTER JOIN 
  (SELECT 
    Ltx.IdLogistica_House,
    SUM(Ltx.Valor_Recebimento_Total) AS Taxas_EUR_Recebimento
  FROM 
    vis_Logistica_taxa Ltx
  WHERE 
    Ltx.Origem_Taxa = 2 /*ORIGEM*/
    /*AND Ltx.IdMoeda_Recebimento = 43 /*EUR*/ REQ #45683*/
  GROUP BY 
    Ltx.IdLogistica_House) Tre on Tre.IdLogistica_House = Lhs.IdLogistica_House /*TOTAL RECEBIEMNTO DAS TAXAS DE ORIGEM EM EUR*/
LEFT OUTER JOIN
  (SELECT 
    Ltx.IdLogistica_House,
    SUM(Ltx.Valor_Recebimento_Corrente) AS Total_BRL_Recebimento
  FROM 
    vis_Logistica_taxa Ltx
  GROUP BY 
    Ltx.IdLogistica_House) Trc on Trc.IdLogistica_House = Lhs.IdLogistica_House /*TOTAL DAS TAXAS DE PAGAMENTO EM BRL*/
  WHERE 
    Lms.Data_Embarque >= DATEADD(DAY, -30, GETDATE())
) Tst
/*WHERE*/
