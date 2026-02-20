Select
  ROW_NUMBER() OVER(PARTITION BY @@ROWCOUNT ORDER BY @@ROWCOUNT) as Indice,
  Tbl2.IdLogistica_House,
  Tbl1.IdLogistica_Moeda,
  Tbl1.Lucro_Efetivo,
  Tbl1.Lucro_Estimado,
  Tbl1.Comissao_Vendedor_Efetiva,
  Tbl1.Comissao_Vendedor_Estimada,
  Tbl1.Lucro_Efetivo + Coalesce(Tbl1.Comissao_Vendedor_Efetiva, 0) As Profit_Total_Efetivo,
  Tbl1.Lucro_Estimado + Coalesce(Tbl1.Comissao_Vendedor_Estimada, 0) As Profit_Total_Estimado,
  Tbl1.IdLogistica_House,
  Tbl2.Numero_Processo as Tbl2_Numero_Processo,
  Tbl2.Situacao_Agenciamento as Tbl2_Situacao_Agenciamento,
  Tbl2.IdCliente as Tbl2_IdCliente,
  Tbl3.IdPessoa as Tbl3_IdPessoa,
  Tbl7.Nome as Tbl7_Nome,
  Tbl2.IdEmpresa_Sistema as Tbl2_IdEmpresa_Sistema,
  Tbl22.Nome as Tbl22_Nome,
  Tbl22.IdEmpresa_Sistema as Tbl22_IdEmpresa_Sistema,
  Tbl2.IdLogistica_Master as Tbl2_IdLogistica_Master,
  Tbl30.Modalidade_Processo as Tbl30_Modalidade_Processo,
  Tbl30.Situacao_Embarque as Tbl30_Situacao_Embarque,
  Tbl30.Tipo_Operacao as Tbl30_Tipo_Operacao,
  Tbl2.IdVendedor as Tbl2_IdVendedor,
  Tbl52.IdPessoa as Tbl52_IdPessoa,
  Lvn.Vendedor,
  Lvn.Valor_Pagamento_Total,
  Lcm.Outro_Vendedor,
  Lcm.Valor_Comissao,
  Lcm.Valor_Comissao as Outro_Comissao,
  SUM(Lcm.Valor_Comissao) OVER () AS Outro_Comissao_Total,
  Tbl1.IdMoeda,
  Tbl69.Sigla as Tbl69_Sigla,
  Tbl2.Peso_Cubado,
  Lah.Peso_Taxado,
  Tbl2.Peso_Bruto,
  Tbl2.Metros_Cubicos,
  Tbl2.Total_Conhecimentos,
  Tbl2.Quantidade_Volumes,
  Coalesce(Lmh.Total_Container_20, 0) + Coalesce(Lmh.Total_Container_40, 0) As Total_Equipamentos,
  Coalesce(Lmh.Total_Container_20, 0) + Coalesce(Lmh.Total_Container_40 * 2, 0) As TEUS,
  Tbl2.Peso_Considerado,
  Case
    When Tbl30.Tipo_Operacao = 2 /* Importação */ Then Coalesce(Tbl30.Data_Desembarque, Tbl30.Data_Previsao_Desembarque)
    Else Coalesce(Tbl30.Data_Embarque, Tbl30.Data_Previsao_Embarque)
  End As Data_Competencia
From
  mov_Logistica_Moeda Tbl1
Join
  cad_Moeda Tbl69 on Tbl69.IdMoeda = Tbl1.IdMoeda And Tbl69.Moeda_Corrente = 1
Join
  mov_Logistica_House Tbl2 on Tbl2.IdLogistica_House = Tbl1.IdLogistica_House
Left Outer Join
  cad_Cliente Tbl3 on Tbl3.IdPessoa = Tbl2.IdCliente
Left Outer Join
  cad_Pessoa Tbl7 on Tbl7.IdPessoa = Tbl3.IdPessoa
Left Outer Join
  sys_Empresa_Sistema Tbl22 on Tbl22.IdEmpresa_Sistema = Tbl2.IdEmpresa_Sistema
Left Outer Join
  mov_Logistica_Master Tbl30 on Tbl30.IdLogistica_Master = Tbl2.IdLogistica_Master
Left Outer Join
  cad_Funcionario Tbl52 on Tbl52.IdPessoa = Tbl2.IdVendedor
Left Outer Join
  cad_Pessoa Tbl56 on Tbl56.IdPessoa = Tbl52.IdPessoa
Left Outer Join
  mov_Logistica_Maritima_House Lmh On Lmh.IdLogistica_House = Tbl2.IdLogistica_House
Left Outer Join
  mov_Logistica_Aerea_House Lah On Lah.IdLogistica_House = Tbl2.IdLogistica_House
Left Outer Join (
Select
  Ltx.IdLogistica_House,
  Psr.Nome AS Vendedor,
  Ltx.Valor_Pagamento_Total
from
  mov_Logistica_Taxa Ltx
Left Outer Join
  cad_Taxa_Logistica_Exibicao Tle ON Tle.IdTaxa_Logistica_Exibicao = Ltx.IdTaxa_Logistica_Exibicao
Left Outer Join
  cad_Pessoa Psr ON Psr.IdPessoa = IdPessoa_Pagamento
Where
  Ltx.IdTaxa_Logistica_Exibicao = 13 /*Comissao Vendedor*/
And
  Ltx.Pagar_Para = 7 /*Vendedor*/) Lvn ON Lvn.IdLogistica_House = Tbl2.IdLogistica_House
Left Outer Join (
Select
  Ltx.IdLogistica_House,
  Psr.Nome AS Outro_Vendedor,
  Ltx.Valor_Pagamento_Total AS Valor_Comissao
from
  mov_Logistica_Taxa Ltx
Left Outer Join
  cad_Taxa_Logistica_Exibicao Tle ON Tle.IdTaxa_Logistica_Exibicao = Ltx.IdTaxa_Logistica_Exibicao
Left Outer Join
  cad_Pessoa Psr ON Psr.IdPessoa = IdPessoa_Pagamento
Where
  Ltx.IdTaxa_Logistica_Exibicao = 13 /*Comissao Vendedor*/
And
  Ltx.Pagar_Para = 4 /*Outro Vendedor*/) Lcm ON Lcm.IdLogistica_House = Tbl2.IdLogistica_House
/*Where*/
Where
  Tbl2.Situacao_Agenciamento <> 7
