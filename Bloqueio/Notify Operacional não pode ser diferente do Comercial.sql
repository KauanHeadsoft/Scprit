<Dados_Registro><CommandText>
    SELECT
      @Acao = CASE
        WHEN Bloqueado = 1 THEN 5
        ELSE 0
      END,
      @Mensagem = CAST(CASE
        WHEN Bloqueado = 1 THEN 'O Notify do Operacional é diferente do Notify do Comercial.'
        ELSE NULL
      END as VARCHAR(MAX))
    FROM
      (
        SELECT
          CAST(CASE
            WHEN ISNULL(COALESCE(Prm.IdNotify_Tela, Lhs.IdNotify), 0) &lt;&gt; ISNULL(Ofr.IdNotify, 0) THEN 1
            ELSE 0
          END as INT) as Bloqueado
        FROM
          (
            SELECT
              Prm.value('Item[@Nome="IdLogistica_House"][1]/@Value', 'int') as IdLogistica_House,
              Prm.value('Item[@Nome="IdNotify"][1]/@Value', 'int') as IdNotify_Tela
            FROM
              @Parametros.nodes('/Parametros/Evento/Campos') as Parametros(Prm)
          ) Prm
          JOIN mov_Logistica_House Lhs ON Lhs.IdLogistica_House = Prm.IdLogistica_House
          LEFT OUTER JOIN mov_Oferta_Frete Ofr ON Ofr.IdOferta_Frete = Lhs.IdOferta_Frete
      ) Blq
  </CommandText></Dados_Registro>