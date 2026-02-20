SELECT /*ok*/
    max(case when Par.IdPapel_Projeto = 3 then Pes.IdPessoa end) as Id_Comercial,
    max(case when Par.IdPapel_Projeto = 3 then Pes.Nome end) as Comercial,
    max(case when Par.IdPapel_Projeto = 6 then Pes.IdPessoa end) as Id_Inside_Sales,
    max(case when Par.IdPapel_Projeto = 6 then Pes.Nome end) as Inside_Sales,
    Lhs.Numero_Processo
FROM
    mov_Projeto_Atividade_Responsavel Par
LEFT OUTER JOIN
    cad_Pessoa Pes on Pes.IdPessoa = Par.IdResponsavel
LEFT OUTER JOIN
    mov_Projeto_Atividade Pja on Pja.IdProjeto_Atividade = Par.IdProjeto_Atividade
LEFT OUTER JOIN
    mov_Logistica_House Lhs on Lhs.IdProjeto_Atividade = Pja.IdProjeto_Atividade
where
    Lhs.Situacao_Agenciamento IN (1, 2, 3, 4)
group by
    Lhs.Numero_Processo
having
    max(case when Par.IdPapel_Projeto = 3 then Par.IdResponsavel end) = 54500



    UPDATE /*ok*/
    mov_Projeto_Atividade_Responsavel
set
    IdResponsavel = 55939
where
    IdPapel_Projeto = 6
    AND IdResponsavel = 54726
    AND IdProjeto_Atividade IN (
        SELECT
            Pja.IdProjeto_Atividade
        FROM
            mov_Projeto_Atividade Pja
        INNER JOIN
            mov_Logistica_House Lhs on Lhs.IdProjeto_Atividade = Pja.IdProjeto_Atividade
        INNER JOIN
            mov_Projeto_Atividade_Responsavel Par_Comercial on Par_Comercial.IdProjeto_Atividade = Pja.IdProjeto_Atividade
        where
            Lhs.Situacao_Agenciamento IN (1, 2, 3, 4)
            AND Par_Comercial.IdPapel_Projeto = 3
            AND Par_Comercial.IdResponsavel = 54500
    )



    UPDATE /*ok*/ 
    mov_Projeto_Atividade_Responsavel
SET
    IdResponsavel = 55939
where
    IdPapel_Projeto = 6
    AND IdProjeto_Atividade IN (
        SELECT
            Pja.IdProjeto_Atividade
        FROM
            mov_Projeto_Atividade Pja
        INNER JOIN
            mov_Logistica_House Lhs on Lhs.IdProjeto_Atividade = Pja.IdProjeto_Atividade
        INNER JOIN
            mov_Projeto_Atividade_Responsavel Par_Comercial on Par_Comercial.IdProjeto_Atividade = Pja.IdProjeto_Atividade
        where
            Lhs.Situacao_Agenciamento IN (1, 2, 3, 4)
            AND Par_Comercial.IdPapel_Projeto = 3
            AND Par_Comercial.IdResponsavel = 54500
    )






    UPDATE Par
SET 
    Par.IdResponsavel = 55939 /*kauan*/  /*aqui é onde vai inserir o novo responsavel?*/
FROM 
    mov_Projeto_Atividade_Responsavel Par
INNER JOIN 
    mov_Projeto_Atividade Pja on Pja.IdProjeto_Atividade = Par.IdProjeto_Atividade
INNER JOIN 
    mov_Logistica_House Lhs on Lhs.IdProjeto_Atividade = Pja.IdProjeto_Atividade
where 
    Lhs.Numero_Processo = 'EM0232-25'
    AND Par.IdResponsavel = 54500 /*victor*/ /*aqui é onde ele vai buscar se o resposavel 'analista' é o responsavel?*/




    SELECT
    Par.IdResponsavel,
    Pes.Nome,
    Par.IdPapel_Projeto,
    Lhs.Numero_Processo
FROM
    mov_Projeto_Atividade_Responsavel Par
INNER JOIN
    cad_Pessoa Pes on Pes.IdPessoa = Par.IdResponsavel
INNER JOIN
    mov_Projeto_Atividade Pja on Pja.IdProjeto_Atividade = Par.IdProjeto_Atividade
INNER JOIN
    mov_Logistica_House Lhs on Lhs.IdProjeto_Atividade = Pja.IdProjeto_Atividade
where
    Lhs.Numero_Processo = 'EM0232-25'



    SELECT
     max(case when Par.IdPapel_Projeto = 2 then Pes.IdPessoa end) as Id_Analista,
     max(case when Par.IdPapel_Projeto = 2 then Pes.Nome end) as Analista,
     max(case when Par.IdPapel_Projeto = 5 then Pes.IdPessoa end) as Id_assistente,
     max(case when Par.IdPapel_Projeto = 5 then Pes.Nome end) as assistente,
   Lhs.Numero_Processo
FROM
    mov_Projeto_Atividade_Responsavel Par
Left Outer Join
    cad_Pessoa Pes on Pes.IdPessoa = Par.IdResponsavel
Left Outer Join
    mov_Projeto_Atividade Pja on Pja.IdProjeto_Atividade = Par.IdProjeto_Atividade
Left Outer Join
    mov_Logistica_House Lhs on Lhs.IdProjeto_Atividade = Pja.IdProjeto_Atividade
where
    Lhs.Situacao_Agenciamento IN (1, 2, 3, 4)
group by
    Lhs.Numero_Processo
having
    max(case when Par.IdPapel_Projeto = 2 then Par.IdResponsavel end) = 117117




UPDATE Par
SET
    Par.IdResponsavel = 118757 /*fernanda*/ /*id que vai trocar*/
FROM
    mov_Projeto_Atividade_Responsavel Par
INNER JOIN
    mov_Projeto_Atividade Pja ON Pja.IdProjeto_Atividade = Par.IdProjeto_Atividade
INNER JOIN
    mov_Logistica_House Lhs ON Lhs.IdProjeto_Atividade = Pja.IdProjeto_Atividade
INNER JOIN
    mov_Projeto_Atividade_Responsavel Par_Analista ON Par_Analista.IdProjeto_Atividade = Pja.IdProjeto_Atividade
WHERE
    Lhs.Numero_Processo = 'SMXIM044631'
    AND Par.IdPapel_Projeto = 5
    AND Par_Analista.IdPapel_Projeto = 2
    AND Par_Analista.IdResponsavel = 117117 /*andressa*/ /**/


