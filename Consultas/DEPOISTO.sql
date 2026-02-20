Select
  Ltx.IdRegistro_Recebimento,
  Ltx.IdLogistica_Taxa,
  Mrc.Sigla as Moeda,
  Ltx.Valor_Recebimento_Unitario,
  Ltx.Quantidade_Recebimento,
  Ltx.Valor_Recebimento_Total,
  Tle.Nome as Taxa,
  Ffn.Total_Desconto,
  Ffn.Total_Acrescimo,
  Tle.Nome_Internacional as Taxa_Internacional,
  case When Ltx.Tipo_Recebimento = 1 Then ' ' /*(Sem cobrança)*/
        When Ltx.Tipo_Recebimento = 2 Then ' ' /*Processo*/
        When Ltx.Tipo_Recebimento = 3 Then  ' ' /*Peso Cubado*/
        When Ltx.Tipo_Recebimento = 4 Then  ' ' /*Peso Taxado*/
        When Ltx.Tipo_Recebimento = 5 Then  ' ' /*Peso Bruto*/
        When Ltx.Tipo_Recebimento = 6 Then  ' ' /*Metro Cubico*/
        When Ltx.Tipo_Recebimento = 7 Then  ' ' /*Conhecimento*/
        When Ltx.Tipo_Recebimento = 8 Then  ' ' /*invoice*/
        When Ltx.Tipo_Recebimento = 9 Then  ' ' /*Volumes*/
        When Ltx.Tipo_Recebimento = 10 Then  ' ' /*Equipamento*/
        When Ltx.Tipo_Recebimento = 11 Then  ' ' /*Equipamento*/
        When Ltx.Tipo_Recebimento = 12 Then  ' ' /*Teu*/
        When Ltx.Tipo_Recebimento = 13 Then  ' %' /*Percentual*/
        When Ltx.Tipo_Recebimento = 14 Then  ' '
        When Ltx.Tipo_Recebimento = 15 Then  ' ' /*Via Master*/
        When Ltx.Tipo_Recebimento = 16 Then  ' ' /*Via house*/
        When Ltx.Tipo_Recebimento = 17 Then  ' ' /*Peso Considerado*/
  end as Valor_Unitario_Tipo,
  Cast(Case
    When Ltx.IdMoeda_Recebimento = Lft.IdMoeda Then 1
    When (Ltx.IdMoeda_Recebimento = Lfc.IdMoeda_Origem) And (Lft.IdMoeda = Lfc.IdMoeda_Destino) Then Lfc.Fator_Conversao
    When (Ltx.IdMoeda_Recebimento = Lfc.IdMoeda_Destino) And (Lft.IdMoeda = Lfc.IdMoeda_Origem) Then Round(1 / Lfc.Fator_Conversao, 6)
    Else 0
  End As Float) As Fator,
  Round((Ltx.Valor_Recebimento_Total *  
   Case
     When Ltx.IdMoeda_Recebimento = Lft.IdMoeda Then 1
     When (Ltx.IdMoeda_Recebimento = Lfc.IdMoeda_Origem) And (Lft.IdMoeda = Lfc.IdMoeda_Destino) Then Lfc.Fator_Conversao
     When (Ltx.IdMoeda_Recebimento = Lfc.IdMoeda_Destino) And (Lft.IdMoeda = Lfc.IdMoeda_Origem) Then Round(1 / Lfc.Fator_Conversao, 6)
     Else 0
   End), 2) As Valor_Corrente,
   Eqm.Descricao as Ue
From
  mov_Logistica_Taxa Ltx
Left Outer Join
  vis_Logistica_Fatura Lft On Lft.IdRegistro_Financeiro = Ltx.IdRegistro_Recebimento
Left Outer Join
  mov_Fatura_Financeira Ffn on Ffn.IdRegistro_Financeiro = Ltx.IdRegistro_Recebimento
Left Outer Join
  mov_Logistica_Fatura_Conversao Lfc On (Lfc.IdLogistica_Fatura = Lft.IdRegistro_Financeiro)
    And ((Ltx.IdMoeda_Recebimento = Lfc.IdMoeda_Origem) And (Lft.IdMoeda = Lfc.IdMoeda_Destino)
    Or (Ltx.IdMoeda_Recebimento = Lfc.IdMoeda_Destino) And (Lft.IdMoeda = Lfc.IdMoeda_Origem))
Left Outer Join
  cad_Moeda Mrc On Mrc.IdMoeda = Ltx.IdMoeda_Recebimento
Left Outer Join
  cad_Taxa_Logistica_Exibicao Tle on Tle.IdTaxa_Logistica_Exibicao = Ltx.IdTaxa_Logistica_Exibicao
Left Outer Join
  cad_Equipamento_Maritimo Eqm on Eqm.IdEquipamento_Maritimo = Ltx.IdEquipamento_Maritimo
Where
  Ltx.IdRegistro_Recebimento = 28616
  And
  Tle.Nome &lt;&gt;  'DEPOSITO'