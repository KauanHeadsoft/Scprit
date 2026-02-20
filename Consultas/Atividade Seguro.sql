<Dados_Registro><Mensagem>Atenção!!!</Mensagem><CommandText>
Select
  @Mensagem =  'Atenção! Necessário marcar o seguro na guia carga! #44611',
 @Condicao =
    CASE
      WHEN Pfc.Seguro= 0 THEN 0 -- verifica se o campo está em '0' se sim, bloqueia
      ELSE 1 -- caso esteja flegado o campo de seguro '1' ele libera para concluir
    END    
From
  mov_Atividade atv -- busca da atividade
Left Outer Join
  mov_Proposta_Frete Pft on Pft.IdProjeto_Atividade = Atv.IdProjeto_Atividade -- faz a junção do idprojeto_atividade com, o mov_atividade
Left OUTER JOIN
    mov_Proposta_Frete_Carga Pfc ON Pfc.IdProposta_Frete = Pft.IdProposta_Frete -- verifico qual é a proposta pelo id 
Where
  Atv.IdAtividade = @IdAtividade
</CommandText></Dados_Registro>
-- Kauan Lauer 10-11 16:44
-- Kauan Lauer 11-11 10:00