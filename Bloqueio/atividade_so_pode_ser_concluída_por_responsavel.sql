<Dados_Registro><Mensagem>Atenção!!!</Mensagem><CommandText>
SELECT
@Mensagem =  'Atenção! Você não tem permissão para concluir esta tarefa!',
@Condicao =
    CASE
      WHEN Atv.IdResponsavel IS NULL THEN 0 -- ID do responsavel for nulo/vazio, bloqueia.
      WHEN Fcn.IdPessoa &lt;&gt; Atv.IdResponsavel THEN 0 -- ID da pessoa logada for diferente do responsavel, bloqueia.
      ELSE 1 -- caso nenhuma condição acima seja verdadeiro libera.
    END    
FROM
  mov_Atividade atv  -- tabela de atividade, onde verifica quando é feito alguma alteração no sistema.
Left Outer Join
  cad_Pessoa Psa ON Psa.IdPessoa = Atv.IdResponsavel -- tabela de cad_pessoa para vincular com id_responsavel
Left Outer Join
  #Global_Var Gvr ON Gvr.Variavel LIKE 'IdUsuario' -- variavel para buscar o IdUsuario
JOIN
  vis_Funcionario Fcn ON Fcn.IdUsuario_Correspondente = Cast(Gvr.Valor AS INT)
WHERE
  Atv.IdAtividade = @IdAtividade
</CommandText></Dados_Registro>
-- Kauan Lauer 10-11 - 10:20

-- SMX - Projeto de tarefa 
-- DIVERGÊNCIA FINANCEIRA DE PAGAMENTO AO AGENTE "DV.01" Operacional deve cloncluir.
-- PROCESSO COM DIVERGÊNCIA FINANCEIRA DEBIT EM ANÁLISE COM CS "DV.02" Financeiro, é uma DV de controle, é concluida junto com a DV.01.
-- DIVERGÊNCIA FINANCEIRA CONCLUÍDA ANALISAR PARA SEGUIR COM O PAGAMENTO "DV.03" é gerada quando a DV.01/02 é concluida, mas operacional não pode concluir.