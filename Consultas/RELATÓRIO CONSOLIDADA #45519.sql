Select
  ROW_NUMBER() OVER(ORDER BY @@ROWCOUNT) AS Indice,
  Cli.Nome as Cliente,
  Lhs.Numero_Processo,
  Lhs.Data_Abertura_Processo,
  Org.Nome as Origem,
  Dst.Nome as Destino,
  Ago.Nome as Agente_Origem,
  Agd.Nome as Agente_Destino,
  Lhs.Quantidade_Volumes,
  Lhs.Metros_Cubicos,
  Lhs.Peso_Bruto,
  Lms.Data_Previsao_Embarque,
  Lms.Data_Previsao_Desembarque,
  Case Lah.Tipo_Servico_Aereo When 0 Then '(Não informado)' When 1 Then 'Back to Back' When 2 Then 'Consolidado' End as Tipo_Servico,
  Nvs.Descricao as Nivel_Servico,
  Case Lhs.Situacao_Agenciamento When 1 Then 'Processo aberto' When 2 Then 'Em andamento' When 3 Then 'Liberado faturamento' When 4 Then 'Faturado' When 5 Then 'Auditado' When 6 Then 'Finalizado' When 7 Then 'Cancelado' End as Situacao_Agenciamento,
  Lhs.Data_Coleta,
  Lhs.Data_Entrega
From
  mov_Logistica_House Lhs 
Left Outer Join
  mov_Logistica_Master Lms on Lms.IdLogistica_Master = Lhs.IdLogistica_Master
Left Outer Join
  cad_Pessoa Cli on Cli.IdPessoa = Lhs.IdCliente
Left Outer Join
  cad_Origem_Destino Org on Org.IdOrigem_Destino = Lms.IdOrigem
Left Outer Join
  cad_Origem_Destino Dst on Dst.IdOrigem_Destino = Lms.IdDestino
Left Outer Join
  cad_Pessoa Ago on Ago.IdPessoa = Lms.IdAgente_Origem
Left Outer Join
  cad_Pessoa Agd on Agd.IdPessoa = Lms.IdAgente_Destino
Left Outer Join
  mov_Logistica_Aerea_House Lah on Lah.IdLogistica_House = Lhs.IdLogistica_House
Left Outer Join
  cad_Nivel_Servico_Aereo Nvs on Nvs.IdNivel_Servico_Aereo = Lah.IdNivel_Servico_Aereo
/*WHERE*/
Where
  Year(Lhs.Data_Abertura_Processo) >= 2023 
And 
  (Lms.Modalidade_Processo = 1 /*AÉREO*/ and Lms.Tipo_Operacao = 2 /*IMPO*/)
