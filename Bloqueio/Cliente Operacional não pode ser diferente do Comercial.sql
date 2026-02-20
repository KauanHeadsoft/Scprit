<Dados_Registro><CommandText>
SELECT 
  @Acao = CASE
    WHEN Bloqueado = 1 THEN 5 /*Bloqueio*/
    Else 0
  END,
  @Mensagem = CAST(CASE
    WHEN Bloqueado = 1 THEN 'Atenção! Cliente do Operacional está divergente do Cliente Comercial.'
    Else NULL
  END as VARCHAR(MAX))
FROM
(
  SELECT
    CAST(CASE
      WHEN Lhs.IdCliente &lt;&gt; Pfr.IdCliente THEN 1
      Else 0
    END as Int) as Bloqueado
  FROM
    (
    SELECT
      Prm.value('Item[@Nome="IdLogistica_Master"][1]/@Value', 'int') as IdLogistica_Master,
      Prm.value('Item[@Nome="Data_Embarque"][1]/@Value', 'Date') as Data_Embarque
    FROM
      @Parametros.nodes('/Parametros/Evento/Campos') as Parametros(Prm)
  ) Prm
LEFT OUTER JOIN 
  mov_Logistica_Master Lms ON Lms.IdLogistica_Master = Prm.IdLogistica_Master
LEFT OUTER JOIN 
  mov_Logistica_House Lhs on Lhs.IdLogistica_Master = Lms.IdLogistica_Master 
LEFT OUTER JOIN 
  mov_Oferta_Frete Ofr on Ofr.IdOferta_Frete = Lhs.IdOferta_Frete
LEFT OUTER JOIN 
  mov_Proposta_Frete Pfr on Pfr.IdProposta_Frete = Ofr.IdProposta_Frete
) Blq
</CommandText></Dados_Registro>