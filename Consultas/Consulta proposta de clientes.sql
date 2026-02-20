SELECT
Pes.Cpf_Cnpj as CNPJ,
Pes.Nome as Cliente,
Ppf.Data_Proposta, 
Ppf.Data_Aprovacao,
Oft.Numero_Oferta,
case Ppf.Situacao when 1 then 'Aguardando Aprovação' when 2 then 'Aprovada' when 3 then 'Não Aprovada' when 4 then 'Não Enviada' when 5 then 'Pré-Proposta' when 6 then 'Enviada'else 'erro 711' end as Situacao,
case Oft.Tipo_Operacao when 1 then 'Exportação'  when 2 then 'Importação' when 3 then 'Nacional' end as Tipo_Operacao,
case Oft.Modalidade_Processo when 1 then 'Aéreo' when 2 then 'Marítimo' when 3 then 'Terrestre' when 4 then 'Air-Air' when 5 then 'Sea-Air' end as Modalidade_Processo
FROM
mov_Proposta_Frete Ppf
Left Outer Join
cad_Pessoa Pes on Pes.IdPessoa = Ppf.IdCliente
Left Outer Join
cad_Pessoa Ven on Ven.IdPessoa = Ppf.IdVendedor
Left Outer Join
mov_Oferta_Frete Oft on Oft.IdProposta_Frete  = Ppf.IdProposta_Frete
/*where*/
