<Dados_Registro><CommandText>
SELECT
  @Acao = CASE
    WHEN Bloqueado = 1 THEN 2 /*AVISO*/
    ELSE 0
  END,
  @Mensagem = CAST(CASE
    WHEN Bloqueado = 1 THEN 'Atividade gerada sem responsável vinculado, favor verificar.'
    ELSE NULL
  END as VARCHAR(MAX))
FROM
  (SELECT
    CAST(CASE
      WHEN (Prm.IdAtividade IS NOT NULL AND Atv.IdAtividade IS NULL) AND Prm.IdResponsavel IS NULL THEN 1
      ELSE 0
    END as Bit) as Bloqueado
  FROM
    (SELECT
      Prm.value('Item[@Nome="IdAtividade"][1]/@Value', 'int') as IdAtividade,
      Prm.value('Item[@Nome="IdTarefa"][1]/@Value', 'int') as IdTarefa,
      Prm.value('Item[@Nome="Situacao"][1]/@Value', 'int') as Situacao,
      Prm.value('Item[@Nome="IdResponsavel"][1]/@Value', 'int') as IdResponsavel
    FROM
      @Parametros.nodes('/Parametros/Evento/Campos') as Parametros(Prm)
    ) Prm
  LEFT OUTER JOIN 
    mov_Atividade Atv ON Atv.IdAtividade = Prm.IdAtividade
  ) Blq
</CommandText></Dados_Registro>