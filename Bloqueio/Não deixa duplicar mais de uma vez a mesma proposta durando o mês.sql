SELECT
  @Acao = CASE
    WHEN Bloqueado = 1 THEN 5
    ELSE 0
  END,
  @Mensagem = CAST(CASE
    WHEN Bloqueado = 1 THEN 'Não é permitido clonar mais de duas propostas iguais no mês'
    ELSE NULL
  END as varchar(MAX))
FROM
(
  SELECT
    CASE
      WHEN Prm.IdProposta_Original IS NOT NULL 
           AND (
             SELECT COUNT(1)
             FROM mov_Proposta_Frete Pfr WITH(NOLOCK)
             WHERE 
               Pfr.IdProposta_Original = Prm.IdProposta_Original
               AND MONTH(Pfr.Data_Proposta) = MONTH(GETDATE()) -- Valida Mês Atual
               AND YEAR(Pfr.Data_Proposta) = YEAR(GETDATE())   -- Valida Ano Atual
           ) >= 2
      THEN 1
      ELSE 0
    END as Bloqueado
  FROM
  (
    SELECT
      T.C.value('(Item[@Nome="IdProposta_Original"]/@Value)[1]', 'int') as IdProposta_Original
    FROM
      @Parametros.nodes('/Parametros/Evento/Campos') as T(C)
  ) Prm
) Blq