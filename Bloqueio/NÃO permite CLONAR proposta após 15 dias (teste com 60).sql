<Dados_Registro><CommandText>
SELECT
  @Acao = CASE
    WHEN Bloqueado = 1 THEN 5 /*BLOQUEADO*/
    ELSE 0
  END,
  @Mensagem = CAST(CASE
    WHEN Bloqueado = 1 THEN '[#44086] Proposta Original aberta a mais de 60 dias, clonagem indisponível!'
    ELSE NULL
  END as varchar(MAX))
FROM
(
  SELECT
    CAST(CASE
      WHEN 
        Prm.IdProposta_Original is not null
        and EXISTS (
          SELECT 1
          FROM
            mov_Proposta_Frete Pfr  
          WHERE
            DATEDIFF(DAY, Pfr.Data_Proposta, GETDATE()) &gt; 60
            and Pfr.IdProposta_Frete = Prm.IdProposta_Original
        ) THEN 1
      ELSE 0
    END as int) as Bloqueado
  FROM
  (
    SELECT
      Prm.value('Item[@Nome="IdProposta_Frete"][1]/@Value', 'int') as IdProposta_Frete,
      Prm.value('Item[@Nome="IdProposta_Original"][1]/@Value', 'int') as IdProposta_Original
    FROM
      @Parametros.nodes('/Parametros/Evento/Campos') as Parametros(Prm)
  ) Prm
) Blq
</CommandText></Dados_Registro>