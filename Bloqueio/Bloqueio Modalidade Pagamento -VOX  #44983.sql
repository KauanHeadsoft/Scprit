<Dados_Registro>
  <CommandText>
    SELECT
      @Acao = CASE
        WHEN Bloqueado = 1 THEN 5
        ELSE 0
      END,
      @Mensagem = CAST(
        CASE
          WHEN Bloqueado = 1 THEN 'A Modalidade de Pagamento selecionada diverge da Modalidade da Taxa'
          ELSE NULL
        END AS VARCHAR(MAX)
      )
    FROM
      (
        SELECT
          CAST(
            CASE 
              WHEN Prm.IdTaxa_Logistica_Exibicao IS NULL 
                   AND Prm.Modalidade_Pagamento IS NOT NULL 
                   AND Ltx.IdLogistica_Taxa IS NOT NULL THEN
                CASE
                   WHEN Prm.Modalidade_Pagamento = 3 AND Ltx.Modalidade_Pagamento &lt;&gt; 1 THEN 1
                   WHEN Prm.Modalidade_Pagamento = 2 AND Ltx.Modalidade_Pagamento &lt;&gt; 2 THEN 1
                   WHEN Prm.Modalidade_Pagamento = 4 AND Ltx.Modalidade_Pagamento NOT IN (3, 4) THEN 1

                   ELSE 0
                END
              ELSE 0
            END AS INT
          ) AS Bloqueado
        FROM
          (
            SELECT
              Prm.value('Item[@Nome="IdLogistica_House"][1]/@Value', 'int') AS IdLogistica_House,
              Prm.value('Item[@Nome="IdTaxa_Logistica_Exibicao"][1]/@Value', 'int') AS IdTaxa_Logistica_Exibicao,
              Prm.value('Item[@Nome="Modalidade_Pagamento"][1]/@Value', 'int') AS Modalidade_Pagamento
            FROM
              @Parametros.nodes('/Parametros/Evento/Campos') AS Parametros(Prm)
          ) Prm
          LEFT OUTER JOIN mov_Logistica_House Lhs ON Lhs.IdLogistica_House = Prm.IdLogistica_House
          LEFT OUTER JOIN mov_Logistica_Taxa Ltx ON Ltx.IdLogistica_House = Lhs.IdLogistica_House AND Ltx.IdTaxa_Logistica_Exibicao = 2 /*252*/
      ) Blq
  </CommandText>
</Dados_Registro>