SELECT
    Sus.Nome AS Nome_User_HC,
    Sus.Data_Criacao,
    Pes.Data_Alteracao,
    (SELECT
        CASE
            WHEN COUNT(P2.Data_Alteracao) > 0 THEN 'Sim'
            ELSE 'Nao'
        END
    FROM cad_pessoa P2
    WHERE P2.IdPessoa = Pes.IdPessoa
) AS Foi_Alterado,
    CASE 
   WHEN Trn.idpessoa IS NOT NULL THEN 'Sim'
   ELSE 'Não' 
END AS Vinculo_Trans_Terrestre,
    CASE
   WHEN Cia.IdPessoa IS NOT NULL THEN 'Sim'
   ELSE 'Não'
END AS Vinculo_Cia,
    CASE
   WHEN Cli.IdPessoa IS NOT NULL THEN 'Sim'
   ELSE 'Não'
END AS Vinculo_Cliente,
    CASE
  WHEN Tra.IdPessoa IS NOT NULL THEN 'Sim'
  ELSE 'Não'
END AS Vinculo_Transportadora,
    CASE
  WHEN Fun.IdPessoa IS NOT NULL THEN 'Sim'
  ELSE 'Não'
END AS Vinculo_Funcionario,
    CASE
    WHEN Seg.IdPessoa IS NOT NULL THEN 'Sim'
    ELSE 'Não'
END AS Vinculo_Seguradora,
    CASE
    WHEN Emp.IdPessoa IS NOT NULL THEN 'Sim'
    ELSE 'Não'
END AS Vinculo_Empresa,
    CASE
    WHEN Ban.Idpessoa IS NOT NULL THEN 'Sim'
    ELSE 'Não'
END AS Vinculo_Bancario,
    CASE
    WHEN Ama.IdPessoa IS NOT NULL THEN 'Sim'
    ELSE 'Não'
END AS Vinculo_Agen_Maritima_Aerea,
    CASE
    WHEN Atc.IdPessoa IS NOT NULL THEN 'Sim'
    ELSE 'Não'
END AS Vinculo_Agencia_Carga,
    CASE
    WHEN Asi.IdPessoa IS NOT NULL THEN 'Sim'
    ELSE 'Não'
END AS Vinculo_Asso_Internacional,
    CASE
    WHEN Dsa.IdPessoa IS NOT NULL THEN 'Sim'
    ELSE 'Não'
END AS Vinculo_Desp_Aduaneiro,
    CASE
    WHEN Fbc.IdPessoa IS NOT NULL THEN 'Sim'
    ELSE 'Não'
END AS Vinculo_Fabricante,
    CASE
    WHEN Fnd.IdPessoa IS NOT NULL THEN 'Sim'
    ELSE 'Não'
END AS Vinculo_Fornecedor,
    CASE
    WHEN Nvc.IdPessoa IS NOT NULL THEN 'Sim'
    ELSE 'Não'
END AS Vinculo_NVOCC,
    CASE
    WHEN Rpc.IdPessoa IS NOT NULL THEN 'Sim'
    ELSE 'Não'
END AS Vinculo_Rep_Colaborador,
    CASE
    WHEN Trc.IdPessoa IS NOT NULL THEN 'Sim'
    ELSE 'Não'
END AS Vinculo_Terminal_Container,
CASE
     WHEN Pcl.IdPessoa IS NOT NULL THEN 'Sim'
     ELSE 'Não'
END AS Vinculo_Pes_Cont_Logistica,
    CASE
    WHEN Cli.Cliente = 1 THEN 'Sim'
      ELSE 'Não'
       END AS Cliente,
    CASE
    WHEN Cli.Importador = 1 THEN 'Sim'
    ELSE 'Não'
       END AS Importador,
    CASE
     WHEN Cli.Exportador = 1 THEN 'Sim'
      ELSE 'Não'
       END AS Exportador,
    CASE Cia.Tipo_Aerea
    WHEN 1 THEN 'Sim'
    WHEN 0 THEN 'Não'
    ELSE 'Não'
    END AS Transportadora_Aerea,
    CASE Cia.Tipo_Maritima
     WHEN 1 THEN 'Sim'
    WHEN 0 THEN 'Não'
    ELSE 'Não'
    END AS Transportadora_Maritima,
    CASE Cia.Tipo_Terrestre 
    WHEN 1 THEN 'Sim'
    WHEN 0 THEN 'Não'
    ELSE 'Não'
    END AS Transportadora_Terrestre,
    Pes.IdPessoa,
    Pes.Codigo,
    Cli.Ultima_Alteracao_Vendedor,
    Sus.Data_Ultimo_Login AS Data_Ultimo_Login_Usuario,
    Pes.Nome AS Pessoa,
    Pes.Nome_Fantasia,
    Lhsp.Numero_Processo AS Cliente_Processo,
    Lhsi.Numero_Processo AS Importador_Processo,
    Lhse.Numero_Processo AS Exportador_Processo,
    Lms.Data_Processo,
    Pes.cpf_cnpj AS CPF_CNPJ,
    Pes.Rg_Inscricao_Estadual AS RG_IE,
    COALESCE(Psg.Nome, 'SEM GRUPO') AS Nome_Grupo,
    COALESCE(Stt.Nome, 'SEM SETOR') AS Setor,
    Ctf.Descricao AS Contrato_Financeiro,
    CASE
	WHEN Pes.Ativo = 1 THEN 'ATIVO'
	ELSE 'DESATIVADO'
	END AS Status_Ativo,
    CASE Cli.Tipo_Cliente
        WHEN 1 THEN 'Prospect'
        WHEN 2 THEN 'Cliente'
        WHEN 3 THEN 'CONta declinada'
        WHEN 4 THEN 'Inativo'
        WHEN 5 THEN 'Trabalhando'
        WHEN 6 THEN 'CONta sONho'
        WHEN 7 THEN 'Agente no exterior'
        WHEN 8 THEN 'Pré-vendAS'
        WHEN 9 THEN 'Sem interesse Cliente'
        WHEN 10 THEN 'CadAStro Incompleto'
        WHEN 11 THEN 'Oportunidade'
        WHEN 12 THEN 'Churn'
    END AS Tipo_Cliente
FROM
    cad_pessoa Pes
    LEFT OUTER JOIN
    mov_logistica_house Lhs ON Lhs.IdCliente = Pes.IdPessoa
    LEFT OUTER JOIN
    mov_logistica_mASter Lms ON Lms.IdLogistica_MASter = Lhs.IdLogistica_MASter
    LEFT OUTER JOIN
    cad_cliente Cli ON Cli.IdPessoa = Pes.IdPessoa
    LEFT OUTER JOIN
    cad_Companhia_Transporte Cia ON Cia.IdPessoa  = Pes.IdPessoa
    LEFT OUTER JOIN
    cad_Pessoa_Grupo Psg ON Psg.IdPessoa_Grupo  = Pes.IdPessoa_Grupo
    LEFT OUTER JOIN
    cad_Setor Stt ON Stt.IdSetor = Pes.IdSetor
    LEFT OUTER JOIN
    cad_CONtrato_Financeiro Ctf ON Ctf.IdCONtrato_Financeiro  = Pes.IdCONtrato_Financeiro
    LEFT OUTER JOIN
    cad_transportadora Tra ON Tra.IdPessoa = Pes.IdPessoa
    LEFT OUTER JOIN
    cad_FunciONario Fun ON Fun.IdPessoa = Pes.IdPessoa
    LEFT OUTER JOIN
    cad_banco_agencia Ban ON Ban.IdPessoa = Pes.IdPessoa
    LEFT OUTER JOIN
    cad_Agencia_Maritima_Aerea Ama ON Ama.idpessoa = Pes.IdPessoa
    LEFT OUTER JOIN
    cad_agente_carga Atc ON Atc.Idpessoa = Pes.IdPessoa
    LEFT OUTER JOIN
    cad_ASsociacao_InternaciONal ASi ON ASi.idpessoa = Pes.IdPessoa
    LEFT OUTER JOIN
    cad_Despachante_Aduaneiro Dsa ON Dsa.idpessoa = Pes.IdPessoa
    LEFT OUTER JOIN
    cad_fabricante Fbc ON Fbc.idpessoa = Pes.IdPessoa
    LEFT OUTER JOIN
    cad_fornecedor Fnd ON Fnd.idpessoa = Pes.IdPessoa
    LEFT OUTER JOIN
    cad_nvocc Nvc ON Nvc.idpessoa = Pes.IdPessoa
    LEFT OUTER JOIN
    cad_Representante_Colaborador Rpc ON Rpc.idpessoa = Pes.IdPessoa
    LEFT OUTER JOIN
    cad_Terminal_CONtainer Trc ON Trc.idpessoa = Pes.IdPessoa
    LEFT OUTER JOIN 
    cad_Pessoa_Contrato_Logistica Pcl ON Pcl.IdPessoa = Pes.IdPessoa
    LEFT OUTER JOIN
    (SELECT
        Lhs.IdCliente,
        STRING_AGG(Lhs.Numero_Processo, ' / ') AS Numero_Processo
    FROM
        mov_Logistica_House Lhs
    GROUP BY
    Lhs.IdCliente) Lhsp ON Lhsp.IdCliente = Cli.IdPessoa
    LEFT OUTER JOIN
    (SELECT
        Lhs.IdImportador,
        STRING_AGG(Lhs.Numero_Processo, ' / ') AS Numero_Processo
    FROM
        mov_Logistica_House Lhs
    GROUP BY
    Lhs.IdImportador) Lhsi ON Lhsi.IdImportador = Pes.IdPessoa
    LEFT OUTER JOIN
    (SELECT
        Lhs.IdExportador,
        STRING_AGG(Lhs.Numero_Processo, ' / ') AS Numero_Processo
    FROM
        mov_Logistica_House Lhs
    GROUP BY
    Lhs.IdExportador) Lhse ON Lhse.IdExportador = Pes.IdPessoa
    LEFT OUTER JOIN
    sys_usuario Sus ON Sus.Idusuario = Pes.IdPessoa
    LEFT OUTER JOIN
    cad_transportadora Trn ON  Trn.idpessoa = Pes.IdPessoa
    LEFT OUTER JOIN
    cad_fornecedor Frn ON Frn.idpessoa = Pes.IdPessoa
    LEFT OUTER JOIN
    cad_Seguradora Seg ON Seg.IdPessoa = Pes.IdPessoa
    LEFT OUTER JOIN
    cad_empresa Emp ON Emp.IdPessoa = Pes.IdPessoa
/*WHERE*/
ORDER BY
Lms.Numero_Processo ASC