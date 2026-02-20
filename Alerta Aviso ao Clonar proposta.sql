<Dados_Registro><CommandText>
SELECT
  @Acao = CASE
    WHEN Bloqueado = 1 THEN 2 /* 2 - Exibir aviso */
    Else 0
  END,
    @Mensagem = CAST(CASE
    WHEN Bloqueado = 1 THEN 'Essa proposta foi clonada, por favor se atente aos campos CLIENTE, IMPORTADOR, EXPORTADOR, VENDEDOR, DATA DE VALIDAE DA PROPOSTA e VALIDADE DO CONTRATO DO CLIENTE para garantir que todas as informações estão corretas.'
    Else NULL
  END as VARCHAR(MAX))
FROM
  (SELECT
    CAST(CASE
      WHEN 
        Prm.IdProposta_Original IS NOT NULL THEN 1
      Else 0
    END as Bit) as Bloqueado
  FROM
    (
    SELECT
      Prm.value('Item[@Nome="IdProposta_Original"][1]/@Value', 'int') as IdProposta_Original
    FROM
      @Parametros.nodes('/Parametros/Evento/Campos') as Parametros(Prm)
    ) Prm
  ) Blq
</CommandText></Dados_Registro>