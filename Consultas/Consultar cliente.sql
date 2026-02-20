SELECT 
    cpf_cnpj,
    Cliente,
    Numero_Oferta,
    Numero_Proposta,
    Data_Proposta,
    Modalidade_Processo,
    Tipo_Operacao
FROM (
    SELECT
        Pes.cpf_cnpj,
        Pes.Nome as Cliente,
        Oft.Numero_Oferta,
        Ppf.Numero_Proposta,
        Ppf.Data_Proposta,
        case Oft.Modalidade_Processo when 1 then 'Aéreo' when 2 then 'Marítimo' when 3 then 'Terrestre' when 4 then 'Air-Air' when 5 then 'Sea-Air' end as Modalidade_Processo,
        case Oft.Tipo_Operacao when 1 then 'Exportação' when 2 then 'Importação' when 3 then 'Nacional' end as Tipo_Operacao,
        ROW_NUMBER() OVER (PARTITION BY Pes.cpf_cnpj ORDER BY Ppf.Data_Proposta ASC) as Ordem
    FROM
        mov_Oferta_Frete Oft
    LEFT OUTER JOIN
        mov_Proposta_Frete Ppf on Ppf.IdProposta_Frete = Oft.IdProposta_Frete
    LEFT OUTER JOIN
        cad_Pessoa Pes on Pes.IdPessoa = Ppf.IdCliente
) as Resultado
WHERE Ordem = 1