Select
  Lft.IdRegistro_Financeiro,
  Lft.IdLogistica_Master,
  Lft.IdLogistica_House,
  Coalesce(Qth.HBL,Lhs.Conhecimentos) As BL,
  Qth.Cntr_bl,
  Rfi.Observacao as Observacao_Financeira,
  Lft.Data,
  Dateadd(dd,datediff(dd,0,GETDATE()),0) as Data_Atual,
  Lft.Numero as Numero_Fatura,
  Mft.Sigla as Moeda,
  Lft.Valor_Original,
  Lhs.Peso_Liquido,
  case when Lft.Natureza = 1 Then Lft.Valor_Total Else -  Lft.Valor_Total End As Valor_Total_Natureza,
  Lhs.Numero_Processo,
  Lft.Valor_Total,
  Cli.Cpf_Cnpj as Cnpj_Cliente,
  Lft.Tipo_Fatura,
  Cli.Cpf_Cnpj,
  Lft.Natureza,
  Coalesce(Atd.Nome, Pft.Nome)  As Pessoa_Fatura,
  Coalesce(Coalesce(Atd.Logradouro,Pft.Logradouro,'') + ', ' + Coalesce(Atd.Numero,Pft.Numero, 'S/N'), 'Sem endereço') as Pessoa_Fatura_Endereco,
  Coalesce(Coalesce(Atm.Nome,Pmn.Nome,'') + ' - ' + Coalesce(Atm.Nome,Puf.Nome,'') + ' - ' + Coalesce(Atd.Cep,Pft.Cep,''), 'Sem endereço') as Pessoa_Fatura_Municipio_UF_CEP,
  Pft.Complemento as Pessoa_Fatura_Complemento,
  Pft.Bairro as Pessoa_Fatura_Bairro,
  Pft.Cep as Pessoa_Fatura_Cep,
  Coalesce(Atd.Cpf_Cnpj,Pft.Cpf_Cnpj) as Pessoa_Fatura_Cnpj,
  Pft.VAT_Number as Pessoa_Fatura_NIF,
  Coalesce (Atd.Correspondencia, Pft.Correspondencia) as Pessoa_Fatura_Correspondencia,
  Puf.Nome as Pessoa_Fatura_UF,
  Puf.Sigla as Pessoa_Fatura_UF_Sigla,
  Pmn.Nome as Pessoa_Fatura_Municipio,
  Pai.Nome as Pessoa_Fatura_Pais,
  Ept.Nome as Exportador,
  Lah.Peso_Taxado,
  Ffn.Total_Pago,
  Emp.Logradouro,
  Emn.Nome as Cidade,
  Pai.Nome as Pais,
  Puf.Nome as UF,
  CONCAT(Emp.Logradouro, ', ', Emn.Nome, ' - ', Puf.Nome, ', ', Pai.Nome) AS Endereco_Completo,
  Ctf.Data_Validade as Validade_Contrato,
  CASE
  Ffn.IdForma_Cobranca
  WHEN 1 THEN 'Fatura'
  WHEN 2 THEN 'Boleto'
  WHEN 3 THEN 'Nota Fiscal'
  WHEN 4 THEN 'Debito Automático'
  WHEN 5 THEN 'Dinheiro'
  WHEN 6 THEN 'Pix'
  else ''
  END as Forma_Cobranca,
  Coalesce(Ept.Logradouro + ', ' + Coalesce(Ept.Numero, 'S/N'), 'Sem endereço') as Exportador_Endereco,
  Ept.Complemento as Exportador_Complemento,
  Ept.Bairro as Exportador_Bairro,
  Ept.Cep as Exportador_Cep,
  Ept.Cpf_Cnpj as Exportador_Cnpj,
  Ept.Correspondencia As Exportador_Correspondencia,
  Euf.Nome as Exportador_UF,
  Emn.Nome as Exportador_Municipio,
  Coalesce(Qth.Importador ,Imp.Nome) as Importador,
  Coalesce(Imp.Logradouro + ', ' + Coalesce(Imp.Numero, 'S/N'), 'Sem endereço') as Importador_Endereco,
  Imp.Complemento as Importador_Complemento,
  Imp.Bairro as Importador_Bairro,
  Imp.Cep as Importador_Cep,
  Imp.Cpf_Cnpj as Importador_Cnpj,
  Imp.Correspondencia As Importador_Correspondencia,
  Iuf.Nome as Importador_UF,
  Imn.Nome as Importador_Municipio,
  Nvi.Nome as Navio,
  Lmm.Viagem_Navio as Numero_Viagem,
  Ctr.Nome as Cia_Transporte,
  Lms.Numero_Reserva as Numero_Booking,
  coalesce(Lms.Data_Embarque,Lms.Data_Previsao_Embarque) As ETD,
  coalesce(Lms.Data_Desembarque,Lms.Data_Previsao_Desembarque) As ETA,
  Lms.Data_Previsao_Embarque,
  Lms.Data_Embarque,
  Lms.Data_Previsao_Desembarque,
  Lms.Data_Desembarque,
  Ffn.Data_Vencimento,
  Ffn.Data_Pagamento,
  Emp.Nome as Empresa,
  Lhs.Referencia_Interna,
  Lhs.Referencia_Cliente,
  Lhs.Referencia_Externa,
  Lhs.Peso_Cubado,
  Lhs.Peso_Bruto,
  Cli.Nome as Cliente,
  Cli.Correspondencia as Cliente_Correpondencia,
  Cli.Fone,
  Lhs.Numero_Processo as Referencia_House,
  Lhs.Conhecimentos as Conhecimento_House,
  Lms.Numero_Conhecimento as Conhecimento_Master,
  Bnc.Nome as Banco,
  Cps.Agencia,
  Cps.Conta,
  Inc.Nome as Incoterm,
  Coalesce(Cps.Agencia + '-' + Coalesce(Cps.Agencia_DV,''),'') as Agencia_dv,
  Coalesce(Cps.Conta + '-' + Coalesce(Cps.Conta_DV,''),'') as Conta_dv,
  Ttl.Cpf_Cnpj as Pessoa_Cnpj,
  Cps.Observacao,
  Mcn.Correspondencia as Emissor_Correspondencia,
  Case 
    When Lms.Tipo_Operacao = 1 Then Agd.Correspondencia
    When Lms.Tipo_Operacao = 2 Then Ago.Correspondencia
  End as Agente_Correspondencia,
  Org.Nome as Origem,
  Dst.Nome as Destino,
  Dtf.Nome as Destino_Final,
  case 
    When Lms.Modalidade_Pagamento = 1 Then 'NÃO INFORMADO'
    When Lms.Modalidade_Pagamento = 2 Then 'COLLECT'
    When Lms.Modalidade_Pagamento = 3 Then 'PREPAID'
    When Lms.Modalidade_Pagamento = 4 Then 'PREPAID ABROAD'
  end as Modalidade_Pagamento_Master,
  case 
    When Lhs.Modalidade_Pagamento = 1 Then 'NÃO INFORMADO'
    When Lhs.Modalidade_Pagamento = 2 Then 'COLLECT'
    When Lhs.Modalidade_Pagamento = 3 Then 'PREPAID'
    When Lhs.Modalidade_Pagamento = 4 Then 'PREPAID ABROAD'
  end as Modalidade_Pagamento_House,
  Lms.Situacao_Embarque,
  CASE
    When Lms.Tipo_Operacao = 1 and Lms.Modalidade_Processo = 1 Then 'EXPORTAÇÃO AÉREA'   
    When Lms.Tipo_Operacao = 1 and Lms.Modalidade_Processo = 2 Then 'EXPORTAÇÃO MARÍTIMA'
    When Lms.Tipo_Operacao = 2 and Lms.Modalidade_Processo = 1 Then 'IMPORTAÇÃO AÉREA'
    When Lms.Tipo_Operacao = 2 and Lms.Modalidade_Processo = 2 Then 'IMPORTAÇÃO MARÍTIMA'
    When Lms.Tipo_Operacao = 1 and Lms.Modalidade_Processo = 3 Then 'EXPORTAÇÃO TERRESTRE'
    When Lms.Tipo_Operacao = 3 and Lms.Modalidade_Processo = 3 Then 'IMPORTAÇÃO TERRESTRE'
End As Tipo_Processo,
  Case
    When Emp.IdPessoa = 1 Then 1
  End as IdLogo_Empresa,
  Cnt.Nome As Funcionario_Faturamento,
  Cnt.Setor As Setor_Faturamento,
  Lho.Numero_Processo as Processo_Origem,
  coalesce(Fad.Nome,Pft.Nome) As Pessoa_Atraves_De,
  Ago.VAT_Number as NIF_Agente,
  Pae.Correspondencia As Agente_Emissor_Corresp,
  Agd.Nome_Fantasia As Agente_Fantasia,
  Oin.Nome as Operacional_Internacional,
  Ccp.Descricao AS CC_Cliente,
  Ccp1.Descricao AS CC_FAM,
  Ccf.Descricao AS CC_Pessoa_Fatura,
  CASE Lhs.Tipo_Carga
	WHEN 0 THEN '(Não especificado)'
	WHEN 1 THEN 'Aéreo'
	WHEN 2 THEN 'Break-Bulk'
	WHEN 3 THEN 'FCL'
	WHEN 4 THEN 'LCL'
	WHEN 5 THEN 'RO-RO'
	WHEN 6 THEN 'Rodoviário'
  END AS Tipo_Carga,
  Mer.Nome AS Mercadoria,
  Lms.IdMoeda_Processo,
  Moe.Nome AS Moeda_Processo,
  CASE Lhs.Seguro
	WHEN 1 THEN 'Sim'
	ELSE 'Não'
  END AS Seguro,
  CASE
    WHEN Lft.Natureza = 1 THEN Ccp1.Descricao
    WHEN Lft.Natureza = 0 THEN Acg.Descricao
    ELSE NULL
  END AS CC_Descricao 
From
  vis_Logistica_Fatura Lft
Left Outer Join
  cad_Moeda Mft on Mft.IdMoeda = Lft.IdMoeda
Left Outer Join
  cad_Pessoa Pft on Pft.IdPessoa = Lft.IdPessoa
Left Outer Join 
  cad_Conta_Corrente Ccf on Ccf.IdPessoa = Pft.IdPessoa
Left Outer Join
  cad_Municipio Pmn on Pmn.IdMunicipio = Pft.IdMunicipio
Left Outer Join
  cad_Unidade_Federativa Puf on Puf.IdUnidade_Federativa = Pft.IdUnidade_Federativa
Left Outer Join
  cad_Pais Pai on Pai.IdPais = Pft.IdPais
Left Outer Join
  mov_Logistica_House Lhs on Lhs.IdLogistica_House = Lft.IdLogistica_House
Left Outer Join
  cad_Pessoa Ept on Ept.IdPessoa = Lhs.IdExportador
Left Outer Join
  cad_Municipio Emn on Emn.IdMunicipio = Ept.IdMunicipio
Left Outer Join
  cad_Unidade_Federativa Euf on Euf.IdUnidade_Federativa = Ept.IdUnidade_Federativa
Left Outer Join
  cad_Pessoa Imp on Imp.IdPessoa = Lhs.IdImportador
Left Outer Join
  cad_Municipio Imn on Imn.IdMunicipio = Imp.IdMunicipio
Left Outer Join
  cad_Unidade_Federativa Iuf on Iuf.IdUnidade_Federativa = Imp.IdUnidade_Federativa
Left Outer Join
  mov_Logistica_Master Lms on Lms.Idlogistica_Master = Lhs.IdLogistica_Master
Left Outer Join
  mov_Logistica_Maritima_Master Lmm on Lmm.IdLogistica_Master = Lhs.IdLogistica_Master
Left Outer Join
  cad_Pessoa Ago on Ago.IdPessoa = Lms.IdAgente_Origem
Left Outer Join
  cad_Pessoa Agd on Agd.IdPessoa = Lms.IdAgente_Destino
Left Outer Join
  cad_Navio Nvi on Nvi.IdNavio = Lmm.IdNavio
Left Outer Join
  mov_Viagem_Navio Vnv on Vnv.IdViagem_Navio = Lmm.IdViagem_Navio
Left Outer Join
  mov_Fatura_financeira Ffn on Ffn.IdRegistro_Financeiro = Lft.IdRegistro_Financeiro
Left Outer Join
  cad_Empresa Eps on Eps.IdEmpresa_Sistema = Lhs.IdEmpresa_Sistema
Left Outer Join
  cad_Pessoa Emp on Emp.IdPessoa = Eps.IdPessoa
Left Outer Join
  cad_Pessoa Cli on Cli.IdPessoa = Lhs.IdCliente  
Left Outer Join
  vis_Companhia_Transporte Ctr on Ctr.IdPessoa = Lms.IdCompanhia_Transporte
Left Outer Join
  cad_Conta_Corrente Cps on Cps.IdConta_Corrente = Lft.IdConta_Pessoa
Left Outer Join
  cad_Banco Bnc on Bnc.IdBanco = Cps.IdBanco
Left Outer Join
  cad_Pessoa Ttl on Ttl.IdPessoa = Cps.IdPessoa
Left Outer Join
cad_Contrato_Financeiro Ctf on Ctf.IdContrato_Financeiro = Emp.IdContrato_Financeiro
Left Outer Join
	  (Select
	  ROW_NUMBER () Over(Partition By Lhs.IdLogistica_House Order By Lhs.IdLogistica_House) As Indice,
	  Lhs.IdLogistica_House,
	  Nvo.Nome, 
	  Nvo.Nome_Fantasia,
	  Nvo.Codigo_Serpro,
	  Mfc.IdAgente_Desconsolidador,
	  Nvo.Correspondencia
	From
	  mov_Mercante_Manifesto_Carga Mfc
	Join
	  vis_NVOCC Nvo on Nvo.IdPessoa = Mfc.IdNVOCC
	Join
	  mov_Mercante_Conhecimento Mcn on Mcn.IdMercante_Manifesto_Carga = Mfc.IdMercante_Manifesto_Carga
	Join
	  mov_Conhecimento_Embarque Cem on Cem.IdConhecimento_Embarque = Mcn.IdConhecimento_Embarque
	Join
	  mov_Logistica_House Lhs on Lhs.IdLogistica_House = Cem.IdLogistica_House) Mcn on Mcn.IdLogistica_House = Lhs.IdLogistica_House And Mcn.Indice = 1
Left Outer Join
  cad_Origem_Destino Org on Org.IdOrigem_Destino = Lms.IdOrigem
Left Outer Join
  cad_Origem_Destino Dst on Dst.IdOrigem_Destino = Lms.IdDestino
Left Outer Join
  cad_Origem_Destino Dtf on Dtf.IdOrigem_Destino = Lms.IdDestino_Final
Left Outer Join
  cad_Mercadoria Mer On Mer.IdMercadoria = Lhs.IdMercadoria
Left Outer Join
  cad_Moeda Moe On Moe.IdMoeda = Lms.IdMoeda_Processo
Left Outer Join
  (Select
    Pac.IdProjeto_Atividade,
	  Pcn.Nome,
	  Pcn.Email,
	  Pcn.Fone,
	  Str.Nome AS Setor,
	  Rank() Over (Partition By Pac.IdProjeto_Atividade Order By Pcn.Nome) As Ranking
  From  
    mov_Projeto_Atividade_Contato Pac
  Join
    mov_Projeto_Atividade_Grupo_Envio Pge on Pge.IdProjeto_Atividade_Contato = Pac.IdProjeto_Atividade_Contato And Pge.IdGrupo_Envio_Mensagem = 30  /*Faturamento Interno*/
  Join
    cad_Pessoa_Contato Pcn on Pcn.IdPessoa_Contato = Pac.IdPessoa_Contato And Pcn.IdPessoa = 1 
  Left Outer Join
    cad_Setor Str on Str.IdSetor = Pcn.IdSetor
  ) Cnt On Cnt.IdProjeto_Atividade = Lhs.IdProjeto_Atividade And Cnt.Ranking = 1 
Left Outer Join
  mov_Registro_Financeiro Rfi on Rfi.IdRegistro_Financeiro = Lft.IdRegistro_Financeiro
Left Outer Join
  cad_Pessoa Atd on Atd.IdPessoa = Rfi.IdAtraves_De
Left Outer Join
  cad_Municipio Atm on Atm.IdMunicipio = Atd.IdMunicipio
Left Outer Join
  cad_Unidade_Federativa Pat on Pat.IdUnidade_Federativa = Atd.IdUnidade_Federativa
Left Outer Join
  mov_Logistica_House Lho on Lho.IdLogistica_House = Lhs.IdProcesso_Origem
Left Outer Join
  cad_Incoterm Inc on Inc.IdIncoterm = Lhs.IdIncoterm
Left Outer Join
  cad_Pessoa Fad on Fad.IdPessoa = Lft.IdAtraves_De
Left Outer Join
  mov_Logistica_Aerea_House Lah on Lah.IdLogistica_House = Lhs.IdLogistica_House
Left Outer Join
  vis_Logistica_Campo_Livre Age On (Age.IdLogistica_House = Lhs.IdLogistica_House) And (Age.IdConfiguracao_Campo_Livre = 243) /*Agente Emissor*/
Left Outer Join
  cad_Pessoa Pae on Pae.Nome Like Age.Valor_Texto
Left Outer Join
  mov_Projeto_Atividade_Responsavel Par on Par.IdProjeto_Atividade = Lhs.IdProjeto_Atividade and (Par.IdPapel_Projeto = 4) /*Operacional internacional*/
Left Outer Join
  cad_Pessoa Oin on Oin.IdPessoa = Par.IdResponsavel
Left Outer Join(
  Select top 1
  Ltx.IdLogistica_House,
  Imp.Nome as Importador,
  Cem.Numero as HBL,
  Qtd.Cntr_bl
From
  mov_Logistica_Taxa Ltx
Join
  mov_Conhecimento_Embarque Cem on Cem.IdConhecimento_Embarque = Ltx.IdConhecimento_Embarque
Left Outer Join
  cad_Pessoa Imp on Imp.IdPessoa = Cem.IdImportador
Left Outer Join (
    Select
      Lmc.IdConhecimento_Embarque,
      Sum(Case
        When Lmc.Embarcado in (1) Then 0
        Else 1
      End) as Cntr_bl
    From
      mov_Logistica_Maritima_Container Lmc
    Group By
      Lmc.IdConhecimento_Embarque) Qtd on Qtd.IdConhecimento_Embarque = Cem.IdConhecimento_Embarque
) Qth on Qth.IdLogistica_House = Lft.IdLogistica_House
  Left Outer Join 
    cad_Conta_Corrente Ccp on Ccp.IdPessoa = Emp.IdPessoa And Ccp.Padrao = 1 and Emp.IdPessoa = 1
  Left Outer Join 
    cad_Conta_Corrente Ccp1 on Ccp1.IdPessoa = Emp.IdPessoa And Ccp1.IdConta_Corrente = 6 and Emp.IdPessoa = 1
Left Outer Join 
  (
  SELECT
  Lft.IdRegistro_Financeiro,
  Ccf.Descricao
  FROM
    vis_Logistica_Fatura Lft
  Left Outer Join
    cad_Pessoa Pft on Pft.IdPessoa = Lft.IdPessoa
  Left Outer Join 
    cad_Conta_Corrente Ccf on Ccf.IdPessoa = Pft.IdPessoa
  WHERE
    Lft.IdTipo_Transacao = 3 /*acerto agentes*/
  ) Acg on Acg.IdRegistro_Financeiro = Lft.IdRegistro_Financeiro
Where
  Lft.IdRegistro_Financeiro = 8346
