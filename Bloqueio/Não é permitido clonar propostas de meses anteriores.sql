<Dados_Registro><CommandText>
SELECT
  @Acao = CASE
    WHEN Bloqueado = 1 THEN 5 -- Bloqueia a operação
    ELSE 0
  END,
  @Mensagem = CAST(CASE
    WHEN Bloqueado = 1 THEN 'Não é permitido clonar propostas de meses anteriores.'
    ELSE NULL
  END as varchar(MAX))
FROM
(
  SELECT
    CASE
      -- PASSO 1: Verifica se existe um ID de origem
      WHEN Prm.IdProposta_Original IS NOT NULL 
           AND EXISTS (
             -- PASSO 2: Busca a proposta ORIGINAL no banco para ver a data dela
             SELECT 1
             FROM mov_Proposta_Frete Pfr WITH(NOLOCK)
             WHERE 
               Pfr.IdProposta_Frete = Prm.IdProposta_Original -- Pega a proposta pai pelo ID
               AND (
                 MONTH(Pfr.Data_Proposta) &lt;&gt; MONTH(GETDATE()) -- Se o Mês for diferente de hoje
                 OR YEAR(Pfr.Data_Proposta) &lt;&gt; YEAR(GETDATE()) -- Ou se o Ano for diferente de hoje
               )
           )
      THEN 1 -- Bloqueado (Datas não batem)
      ELSE 0 -- Liberado (Mesmo mês/ano)
    END as Bloqueado
  FROM
  (
    -- Leitura do XML para pegar o ID da proposta que está sendo clonada
    SELECT
      T.C.value('(Item[@Nome="IdProposta_Original"]/@Value)[1]', 'int') as IdProposta_Original
    FROM
      @Parametros.nodes('/Parametros/Evento/Campos') as T(C)
  ) Prm
) Blq
</CommandText></Dados_Registro>