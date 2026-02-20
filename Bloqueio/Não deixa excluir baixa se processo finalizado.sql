<Dados_Registro><CommandText>
SELECT
  @Acao = CASE
    WHEN Bloqueado = 1 THEN 5 /* Bloqueado */
    Else 0
  END,
  @Mensagem = CAST(CASE
    WHEN Bloqueado = 1 THEN  'Não pode excluir uma baixa com um processo finalizado'
    Else NULL
  END as VARCHAR(MAX))
FROM
  (SELECT
    CAST(CASE
      WHEN  (Lft.Situacao IS NOT NULL) /*TEM BAIXA*/ and Lhs.Situacao_Agenciamento = 5 /* Finalzizado */ THEN 1
      ELSE 0
    END as Bit) as Bloqueado
  FROM
    (SELECT
      Prm.value('Item[@Nome="IdRegistro_Financeiro"][1]/@Value', 'int') as IdRegistro_Financeiro
    FROM
      @Parametros.nodes('/Parametros/Evento/Campos') as Parametros(Prm)
    )Prm
LEFT OUTER JOIN
  mov_Registro_Financeiro Mfn ON Mfn.IdRegistro_Financeiro = Prm.IdRegistro_Financeiro
LEFT OUTER JOIN
  mov_Fatura_Financeira Ffn ON Ffn.IdRegistro_Financeiro = Prm.IdRegistro_Financeiro
LEFT OUTER JOIN
  mov_Fatura_Financeira_Baixa Ffb ON Ffb.IdFatura_Financeira = Ffn.IdFatura_Financeira
LEFT OUTER JOIN
  vis_Logistica_Fatura Lft ON Lft.IdRegistro_Financeiro = Prm.IdRegistro_Financeiro
LEFT OUTER JOIN
  mov_Logistica_House Lhs ON Lhs.IdLogistica_House = Lft.IdLogistica_House
) Blq
</CommandText></Dados_Registro>
 