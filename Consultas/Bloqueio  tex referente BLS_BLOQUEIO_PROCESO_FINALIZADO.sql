Select
Ffb.IdFatura_Financeira_Baixa,
case Lhs.Situacao_Agenciamento when 5 then 'Finalizado' end as Processo,
case Lhs.Situacao_Agenciamento when 5 then 'Bloqueado, não pode excluir' else 'Liberado para exlcuir' end as bloqueio
From 
    mov_Logistica_House Lhs
Left Outer Join
    mov_Logistica_Fatura Lft on Lft.IdLogistica_House = Lhs.IdLogistica_House
Left Outer Join
    mov_Fatura_Financeira Fft on Fft.IdRegistro_Financeiro = Lft.IdRegistro_Financeiro
left Outer Join 
    mov_Fatura_Financeira_Baixa ffb on Ffb.IdFatura_Financeira = Fft.IdFatura_Financeira 
Where
Lhs.Situacao_Agenciamento = 5
and
Ffb.IdFatura_Financeira_Baixa = 2000
