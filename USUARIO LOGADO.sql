<Dados_Registro><CommandText>
Declare
        @IdUsuario_Logado Int  
     Set
        @IdUsuario_Logado = (Select
                                  Gvr.Valor
                                 From
                                  #Global_Var Gvr
                                 Where
                                   Gvr.Variavel like 'IdUsuario')
SELECT
  @Acao = CASE
    WHEN Bloqueado =1 THEN 5
    Else 0
  END,
    @Mensagem = CAST(CASE
    WHEN Bloqueado = 1 THEN '[Var#01] - Está Proposta não é sua' +' '+ Blq.Usuario_Logado
    Else NULL
  END as VARCHAR(MAX))
FROM
    (
     SELECT
        CAST(CASE
            WHEN Oft.Modalidade_Processo = 1 /*Aereo*/ and (Fnc.IdPessoa &lt;&gt; Par.IdResponsavel) THEN 1
            Else 0
        END as Int) as Bloqueado,
     Fnc.Nome As Usuario_Logado
    FROM
        (
  SELECT
        Prm.value('Item[@Nome="IdLogistica_House"][1]/@Value', 'int') as IdLogistica_House,
        Prm.value('Item[@Nome="IdOferta_Frete"][1]/@Value', 'int') as IdOferta_Frete
    FROM
        @Parametros.nodes('/Parametros/Evento/Campos') as Parametros(Prm)
  ) Prm
  Left Outer Join
    mov_Oferta_Frete Oft on Oft.IdOferta_Frete = Prm.IdOferta_Frete
  Left Outer Join 
    mov_Proposta_Frete Pft on Pft.IdProposta_Frete = Oft.IdProposta_Frete
  Left Outer Join
    mov_Projeto_Atividade_Responsavel Par on Par.IdProjeto_Atividade = Pft.IdProjeto_Atividade and Par.IdPapel_Projeto = 2 /*Operacional*/
  Left Outer Join
    vis_Funcionario Fnc on Fnc.IdUsuario_Correspondente = @IdUsuario_Logado
) Blq
</CommandText></Dados_Registro>