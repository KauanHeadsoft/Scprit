<Dados_Registro><CommandText>
/*
Desenvolvido por: Victor Oliveira
Chamado: 31489
Editado por: Kauan Lauer
Chamado: 46230
*/
SELECT
  @Acao = CASE
    WHEN Bloqueado = 1 THEN 5 /* bloqueado exibir aviso */
    Else 0
  END,
  @Mensagem = CAST(CASE
    WHEN Bloqueado = 1 THEN '[002] Essa proposta não tem nenhum contato externo OPERACIONAL AGENTE!'
    Else NULL
  END as VARCHAR(MAX))
FROM
  (
  SELECT
    CAST(CASE
      WHEN Prm.IdLogistica_House IS NOT NULL
        AND Prm.IdOferta_Frete IS NOT NULL
        AND (Ofr.Tipo_Operacao = 2  /*1-Exportação  2-Importação  3-Nacional*/ AND Ofr.Modalidade_Processo = 2 /*1-Aéreo  2-Marítimo   3-Terrestre*/ AND Ofr.Master_Direto = 0) /*Não*/
         AND (SELECT
				COUNT(Pag.IdGrupo_Envio_Mensagem)
			FROM 
				mov_Oferta_Frete Ofr 
			LEFT OUTER JOIN 
				mov_Proposta_Frete Pfr on Pfr.IdProposta_Frete = Ofr.IdProposta_Frete
			LEFT OUTER JOIN
				mov_Projeto_Atividade_Contato Pac ON Pac.IdProjeto_Atividade = Pfr.IdProjeto_Atividade
			LEFT OUTER JOIN
				mov_Projeto_Atividade_Grupo_Envio Pag On Pag.IdProjeto_Atividade_Contato = Pac.IdProjeto_Atividade_Contato AND Pag.IdGrupo_Envio_Mensagem = 8 /* OPERACIONAL AGENTE*/
			WHERE
				Ofr.IdOferta_Frete = Prm.IdOferta_Frete) = 0 THEN 1
      ELSE 0
    END as int) as Bloqueado
  FROM
    (
    SELECT
      Prm.value('Item[@Nome="IdLogistica_House"][1]/@Value', 'int') as IdLogistica_House,
      Prm.value('Item[@Nome="IdOferta_Frete"][1]/@Value', 'int') as IdOferta_Frete
    FROM
      @Parametros.nodes('/Parametros/Evento/Campos') as Parametros(Prm)
    ) Prm
LEFT OUTER JOIN
                mov_Oferta_Frete Ofr on Ofr.IdOferta_Frete = Prm.IdOferta_Frete           
  ) Blq
</CommandText></Dados_Registro>