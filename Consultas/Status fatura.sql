/* Bloqueio */
(
Select
Ffn.IdRegistro_Financeiro,
Min(Ffn.Tipo) As Tipo,
Max(
Case
When Ffn.IdRegistro_Unificador <> 0 Then 4
/* Fatura Unificada */
When Ffn.Situacao In (2, 3) Then 3
/* Fatura com Baixa */
When Ffn.Conferido = 1 Then 2
/* Fatura Conferida */
When (
Rfn.Origem_Lancamento <> 1
/* Interno */
)
And (
Ffn.Tipo = 2
/* Título */
) Then 1
/* Fatura Finalizada */
Else 0
End
) As Bloqueio
From
mov_Fatura_Financeira Ffn
Join mov_Registro_Financeiro Rfn On Rfn.IdRegistro_Financeiro = Ffn.IdRegistro_Financeiro
Group By
Ffn.IdRegistro_Financeiro
) Blq On Blq.IdRegistro_Financeiro = Rfn.IdRegistro_Financeiro