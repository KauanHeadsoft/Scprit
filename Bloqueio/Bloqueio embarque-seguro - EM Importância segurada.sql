<Dados_Registro><CommandText>
/*REQ #34180*/
SELECT
  @Acao = CASE WHEN Bloqueado = 1 THEN 5 Else 0 END, /* 5 = bloqueio */ 
  @Mensagem = CAST(CASE Bloqueado
    WHEN 1 THEN 'Processo com seguro e sem importância segurada lançada'
    Else NULL
  END as VARCHAR(MAX))
FROM
  (
  SELECT
    CASE
      WHEN Prm.Seguro = 1 AND (Lhs.Importancia_Segurada IS NULL OR Lhs.Importancia_Segurada Like '0.00') THEN 1
      ELSE 0
    END as Bloqueado
  FROM
    (
    SELECT
    Prm.value('Item[@Nome="IdLogistica_House"][1]/@Value', 'int') as IdLogistica_House,
    Prm.value('Item[@Nome="Seguro"][1]/@Value', 'Int') as Seguro
    FROM
        @Parametros.nodes('/Parametros/Evento/Campos') as Parametros(Prm)
  ) Prm
  LEFT OUTER JOIN 
    mov_Logistica_House Lhs on Lhs.IdLogistica_House = Prm.IdLogistica_House
) Blq
</CommandText></Dados_Registro>