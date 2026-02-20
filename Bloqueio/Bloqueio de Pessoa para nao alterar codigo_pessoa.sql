<Dados_Registro>
  <CommandText>
    SELECT
      @Acao = CASE
        WHEN Bloqueado = 1 THEN 5 -- 5 = Bloquear
        Else 0
      END,
      @Mensagem = CAST(
        CASE
          WHEN Bloqueado = 1 THEN 'Não é permitido alterar o campo do Codigo! #44877'
          Else NULL
        END as VARCHAR(MAX)
      )
    FROM
      (
        SELECT
          CAST(
            CASE
             
              WHEN Psa.IdPessoa IS NOT NULL THEN
               CASE
                  WHEN ISNULL(Psa.Codigo, '') &lt;&gt; ISNULL(Prm.Codigo_Pessoa, '') THEN 1 -- 1 = Bloquear
                  ELSE 0 -- 0 = Permitir 
                END
              ELSE 0
            END as INT
          ) as Bloqueado
        FROM
          (
            SELECT
              Prm.value('Item[@Nome="IdPessoa"][1]/@Value', 'int') as IdPessoa,
              Prm.value('Item[@Nome="Codigo"][1]/@Value', 'VarChar(Max)') as Codigo_Pessoa
            FROM
              @Parametros.nodes('/Parametros/Evento/Campos') as Parametros(Prm)
          ) Prm
          LEFT OUTER JOIN cad_Pessoa Psa ON Psa.IdPessoa = Prm.IdPessoa
      ) Blq
  </CommandText>
</Dados_Registro>