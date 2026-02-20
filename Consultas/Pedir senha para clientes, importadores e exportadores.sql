<Dados_Registro><CommandText>
SELECT
  @Acao = CASE
    WHEN Bloqueado = 1 THEN 4 /*SOLICITAR SENHA*/
    WHEN Bloqueado = 2 THEN 4 /*SOLICITAR SENHA*/
    WHEN Bloqueado = 3 THEN 4 /*SOLICITAR SENHA*/
    ELSE 0
  END,
  @Mensagem = CAST(CASE
    WHEN Bloqueado = 1 THEN '[#43999] Cliente'+CHAR(10)+Cast(Blq.Cliente as varchar(max))+CHAR(10)+'precisa de aprovação para seguir com o processo, checar com a gerência.'
    WHEN Bloqueado = 2 THEN '[#43999] Importador'+CHAR(10)+Cast(Blq.Importador as varchar(max))+CHAR(10)+'precisa de aprovação para seguir com o processo, checar com a gerência.'
    WHEN Bloqueado = 3 THEN '[#43999] Cliente/Importador'+CHAR(10)+Cast(Blq.Cliente as varchar(max))+CHAR(10)+'precisa de aprovação para seguir com o processo, checar com a gerência.'
    ELSE null
  END as varchar(MAX))
FROM (
  SELECT
    CAST(CASE
      WHEN Prm.Situacao = 2
      and ISNULL(Pfr.Situacao, 0) &lt;&gt; 2
      and (Pfr.IdCliente in (54495/*BELL VALLEY*/, 56376/*SS IMPORTACAO*/, 64549 /*IQBC PRODUTOS*/, 67645 /*MONDO CHILE*/, 68933 /*SEI DO BRASI*/)
      and COALESCE(Ofr.IdImportador, 0) not in (54495/*BELL VALLEY*/, 56376/*SS IMPORTACAO*/, 64549 /*IQBC PRODUTOS*/, 67645 /*MONDO CHILE*/, 68933 /*SEI DO BRASI*/)) THEN 1 /*CLIENTE*/
      WHEN Prm.Situacao = 2
      and ISNULL(Pfr.Situacao, 0) &lt;&gt; 2
      and (COALESCE(Ofr.IdImportador, 0) in (54495/*BELL VALLEY*/, 56376/*SS IMPORTACAO*/, 64549 /*IQBC PRODUTOS*/, 67645 /*MONDO CHILE*/, 68933 /*SEI DO BRASI*/)
      and Pfr.IdCliente not in (54495/*BELL VALLEY*/, 56376/*SS IMPORTACAO*/, 64549 /*IQBC PRODUTOS*/, 67645 /*MONDO CHILE*/, 68933 /*SEI DO BRASI*/)) THEN 2 /*IMPORTADOR*/
      WHEN Prm.Situacao = 2
      and ISNULL(Pfr.Situacao, 0) &lt;&gt; 2
      and (COALESCE(Ofr.IdImportador, 0) in (54495/*BELL VALLEY*/, 56376/*SS IMPORTACAO*/, 64549 /*IQBC PRODUTOS*/, 67645 /*MONDO CHILE*/, 68933 /*SEI DO BRASI*/)
      and Pfr.IdCliente in (54495/*BELL VALLEY*/, 56376/*SS IMPORTACAO*/, 64549 /*IQBC PRODUTOS*/, 67645 /*MONDO CHILE*/, 68933 /*SEI DO BRASI*/)) THEN 3 /*CLIENTE E IMPORTADOR*/
      ELSE 0
    END as int) as Bloqueado,
    Cli.Nome as Cliente,
    Imp.Nome as Importador
  FROM (
    SELECT
      Prm.value('Item[@Nome="IdProposta_Frete"][1]/@Value', 'int') as IdProposta_Frete,
	    Prm.value('Item[@Nome="Situacao"][1]/@Value', 'int') as Situacao
    FROM
      @Parametros.nodes('/Parametros/Evento/Campos') as Parametros(Prm)
) Prm
LEFT OUTER JOIN
  mov_Proposta_Frete Pfr on Pfr.IdProposta_Frete = Prm.IdProposta_Frete
LEFT OUTER JOIN
  mov_Oferta_Frete Ofr on Ofr.IdProposta_Frete = Prm.IdProposta_Frete
LEFT OUTER JOIN
  cad_Pessoa Cli on Cli.IdPessoa = Pfr.IdCliente
LEFT OUTER JOIN
  cad_Pessoa Imp on Imp.IdPessoa = Ofr.IdImportador
) Blq
</CommandText></Dados_Registro>