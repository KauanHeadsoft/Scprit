--SELECT
--Moe.Sigla,
--Lhs.Numero_Processo,
--Ltx.Valor_Pagamento_Unitario
--FROM
--mov_Atividade Atv
--Left Outer Join
--mov_logistica_house Lhs ON Lhs.IdLogistica_House = Ltx.IdLogistica_House

--Left Outer Join
--cad_moeda Moe ON Moe.IdMoeda = Ltx.IdMoeda_Pagamento
--WHERE
--Ltx.IdTaxa_Logistica_Exibicao IN (6,/*BL FEE*/ 85 /*EX*/)
--AND
--Lhs.Numero_Processo like '%AGLIM4022-25%'



SELECT DISTINCT
  Tx1.IdLogistica_House,
  Tx1.Pessoa_Fatura AS Pessoa_BL,
  Tx1.Moeda AS Moeda_BL,
  Tx1.Taxa_Internacional AS Taxa_Internacional_BL,
  Tx1.Fator AS Fator_BL,
  Tx2.Moeda AS Moeda_EX,
  Tx2.Taxa_Internacional AS Taxa_Internacional_EX,
  Tx2.Fator AS Fator_EX,
  Tx1.Email,
  Tx1.Numero_Processo
FROM
  mov_Atividade Atv
  Left Outer Join mov_Logistica_House Lhs on Lhs.IdProjeto_Atividade = Atv.IdProjeto_Atividade
  Left Outer Join mov_Logistica_Master Lms on Lms.IdLogistica_Master = Lhs.IdLogistica_Master
  Left outer join cad_pessoa Eml ON Eml.IdPessoa = Lhs.IdCliente
  
  -- SUB-CONSULTA 1 (TAXA 6) COM DISTINCT
  Left Outer Join (
    SELECT DISTINCT
      Ltx.IdLogistica_House,
      Pes.Nome as Pessoa_Fatura,
      Mrc.Sigla AS Moeda,
      Tle.Nome_Internacional AS Taxa_Internacional,
      Cast(
        Case
          When Ltx.IdMoeda_Pagamento = Lft.IdMoeda Then 1
          When (Ltx.IdMoeda_Pagamento = Lfc.IdMoeda_Origem) And (Lft.IdMoeda = Lfc.IdMoeda_Destino) Then Lfc.Fator_Conversao
          When (Ltx.IdMoeda_Pagamento = Lfc.IdMoeda_Destino) And (Lft.IdMoeda = Lfc.IdMoeda_Origem) Then Round(1 / Lfc.Fator_Conversao, 6)
          Else 0
        End As Float
      ) As Fator,
      Tle.IdTaxa_Logistica_Exibicao,
      Pes.email,
      Lhs.Numero_Processo
    FROM
      mov_Logistica_Taxa Ltx
      Left Outer Join cad_Moeda Mrc On Mrc.IdMoeda = Ltx.IdMoeda_Pagamento
      Left Outer Join vis_Logistica_Fatura Lft On Lft.IdRegistro_Financeiro = Ltx.IdRegistro_Pagamento
      Left Outer Join mov_Logistica_House Lhs on Lhs.IdLogistica_House = Ltx.IdLogistica_House
      Left Outer Join mov_Logistica_Master Lms on Lms.IdLogistica_Master = Lhs.IdLogistica_Master
      Left Outer Join mov_Logistica_Fatura_Conversao Lfc On (Lfc.IdLogistica_Fatura = Lft.IdRegistro_Financeiro)
      And (
        (Ltx.IdMoeda_Pagamento = Lfc.IdMoeda_Origem) And (Lft.IdMoeda = Lfc.IdMoeda_Destino)
        Or (Ltx.IdMoeda_Pagamento = Lfc.IdMoeda_Destino) And (Lft.IdMoeda = Lfc.IdMoeda_Origem)
      )
      Left Outer Join cad_Taxa_Logistica_Exibicao Tle on Tle.IdTaxa_Logistica_Exibicao = Ltx.IdTaxa_Logistica_Exibicao
      left outer join cad_pessoa Pes ON Pes.IdPessoa = Lft.IdPessoa
    Where
      Lft.IdPessoa = Lms.IdCompanhia_Transporte
      AND Tle.IdTaxa_Logistica_Exibicao IN (6)
  ) Tx1 on Tx1.IdLogistica_House = Lhs.IdLogistica_House
  
  -- SUB-CONSULTA 2 (TAXA 85) COM DISTINCT
  Left Outer Join (
    SELECT DISTINCT
      Ltx.IdLogistica_House,
      Pes.Nome as Pessoa_Fatura,
      Mrc.Sigla AS Moeda,
      Tle.Nome_Internacional AS Taxa_Internacional,
      Cast(
        Case
          When Ltx.IdMoeda_Pagamento = Lft.IdMoeda Then 1
          When (Ltx.IdMoeda_Pagamento = Lfc.IdMoeda_Origem) And (Lft.IdMoeda = Lfc.IdMoeda_Destino) Then Lfc.Fator_Conversao
          When (Ltx.IdMoeda_Pagamento = Lfc.IdMoeda_Destino) And (Lft.IdMoeda = Lfc.IdMoeda_Origem) Then Round(1 / Lfc.Fator_Conversao, 6)
          Else 0
        End As Float
      ) As Fator,
      Tle.IdTaxa_Logistica_Exibicao
    FROM
      mov_Logistica_Taxa Ltx
      Left Outer Join cad_Moeda Mrc On Mrc.IdMoeda = Ltx.IdMoeda_Pagamento
      Left Outer Join vis_Logistica_Fatura Lft On Lft.IdRegistro_Financeiro = Ltx.IdRegistro_Pagamento
      Left Outer Join mov_Logistica_House Lhs on Lhs.IdLogistica_House = Ltx.IdLogistica_House
      Left Outer Join mov_Logistica_Master Lms on Lms.IdLogistica_Master = Lhs.IdLogistica_Master
      Left Outer Join mov_Logistica_Fatura_Conversao Lfc On (Lfc.IdLogistica_Fatura = Lft.IdRegistro_Financeiro)
      And (
        (Ltx.IdMoeda_Pagamento = Lfc.IdMoeda_Origem) And (Lft.IdMoeda = Lfc.IdMoeda_Destino)
        Or (Ltx.IdMoeda_Pagamento = Lfc.IdMoeda_Destino) And (Lft.IdMoeda = Lfc.IdMoeda_Origem)
      )
      Left Outer Join cad_Taxa_Logistica_Exibicao Tle on Tle.IdTaxa_Logistica_Exibicao = Ltx.IdTaxa_Logistica_Exibicao
      left outer join cad_pessoa Pes ON Pes.IdPessoa = Lft.IdPessoa
    WHERE
      Lft.IdPessoa = Lms.IdCompanhia_Transporte
      AND Tle.IdTaxa_Logistica_Exibicao IN (85)
  ) Tx2 on Tx2.IdLogistica_House = Lhs.IdLogistica_House
WHERE
Atv.IdAtividade = 2908006
  --Lhs.Numero_Processo like '%AGLIM4022-25%'