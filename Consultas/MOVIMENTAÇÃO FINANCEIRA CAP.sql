Select
  Mfc.IdMovimentacao_Categoria,
  Case When Mfc.Natureza = 0 Then -Mfc.Valor_Convertido Else Mfc.Valor_Convertido end As Valor_Convertido,
  Ffn.Referencia_Externa,
  Ttr.Nome as Tipo_Transacao,
  Cfn.Nome as Categoria_Financeira,
  Ffn.Data_Vencimento,
  Mfn.Data As Data_Pagamento,
  Pft.Nome as Pessoa,
  Rfn.Referencia,
  Ccr.Nome As Conta_Corrente,
  Rfn.Numero as Numero_Registro,
  Ffn.Numero_Cobranca,
  COALESCE(Ffn.Numero_Cobranca, Rfn.Numero) as Num_Cobraca_Registro
From
  mov_Movimentacao_Financeira_Categoria Mfc
Left Outer Join
  mov_Fatura_Financeira_Baixa Ffb on Ffb.IdFatura_Financeira_Baixa = Mfc.IdFatura_Financeira_Baixa
Left Outer Join
  mov_Fatura_Financeira Ffn on Ffn.IdFatura_Financeira = Ffb.IdFatura_Financeira
Left Outer Join
  mov_Movimentacao_Financeira Mfn on Mfn.IdMovimentacao_Financeira = Mfc.IdMovimentacao_Financeira
Left Outer Join
  mov_Registro_Financeiro Rfn on Rfn.IdRegistro_Financeiro = Ffn.IdRegistro_Financeiro
Left Outer Join
  cad_Tipo_Transacao Ttr on Ttr.IdTipo_Transacao = Rfn.IdTipo_Transacao
Left Outer Join
  cad_Categoria_Financeira Cfn on Cfn.IdCategoria_Financeira = Mfc.IdCategoria_Financeira
Left Outer Join
  cad_Pessoa Pft on Pft.IdPessoa = Rfn.IdPessoa
Left Outer Join
  cad_Conta_Corrente Ccr on Ccr.IdConta_Corrente = Mfn.IdConta_Corrente
/*Where*/
