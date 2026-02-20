<Dados_Registro><CommandText>
SELECT
  @Acao = CASE
      WHEN ISNULL(Bloqueado, 0) = 1 THEN 4
      ELSE 0
    END,
  @Mensagem = CAST(CASE
      WHEN ISNULL(Bloqueado, 0) = 1 THEN 'Fatura de Agente em processo FCL requer Conferência Operacional.'
      ELSE NULL
    END as VARCHAR(MAX))
FROM (
  SELECT CASE WHEN EXISTS (
    SELECT 1
    FROM mov_Logistica_House Lhs
    INNER JOIN mov_Logistica_Fatura Lft ON Lft.IdLogistica_House = Lhs.IdLogistica_House
    CROSS JOIN (
        SELECT
            P.value('(Item[@Nome="IdLogistica_Master"]/@Value)[1]', 'INT') as IdMaster,
            P.value('(Item[@Nome="Situacao_Embarque"]/@Value)[1]', 'INT') as NovaSituacao
        FROM @Parametros.nodes('/Parametros/Evento/Campos') as T(P)
    ) Params
    WHERE Lhs.IdLogistica_Master = Params.IdMaster
      AND Params.NovaSituacao = 3
      AND Lhs.Tipo_Carga = 3
      AND Lft.Tipo_Fatura = 3
      AND ISNULL(Lft.Conferido_Operacional, 0) = 0
  ) THEN 1 ELSE 0 END AS Bloqueado
) X
</CommandText></Dados_Registro>