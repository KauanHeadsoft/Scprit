<Dados_Registro><CommandText>
SELECT
  @Acao = CASE
    WHEN Bloqueado = 1 THEN 5 /* bloqueado exibir aviso */
    Else 0
  END,
  @Mensagem = CAST(CASE
    WHEN Bloqueado = 1 THEN 'Favor preencher o valor da mercadoria.'
    Else NULL
  END as VARCHAR(MAX))
FROM
  (
  SELECT
    CAST(CASE
      WHEN (Prm.IdLogistica_House IS NOT NULL) AND (Prm.Valor_Mercadoria IS NULL) THEN 1
      ELSE 0
    END as int) as Bloqueado
  FROM
    (
    SELECT
      Prm.value('Item[@Nome="IdLogistica_House"][1]/@Value', 'int') as IdLogistica_House,
      Prm.value('Item[@Nome="Valor_Mercadoria"][1]/@Value', 'numeric') as Valor_Mercadoria
    FROM
      @Parametros.nodes('/Parametros/Evento/Campos') as Parametros(Prm)
    ) Prm
  JOIN 
    mov_Logistica_House Lhs ON Lhs.IdLogistica_House = Prm.IdLogistica_House
  LEFT OUTER JOIN
    mov_Logistica_Master Lms ON Lms.IdLogistica_Master = Lhs.IdLogistica_Master
  ) Blq
</CommandText></Dados_Registro>