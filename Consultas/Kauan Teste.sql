SELECT
Pes.Nome as Cliente, Ven.Nome as Vendedor, Ppf.Data_Proposta, Ppf.Data_Aprovacao, case Ppf.Situacao when 1 then 'Aguardando Aprovação' when 2 then 'Aprovada' when 3 then 'Não Aprovada' when 4 then 'Não Enviada' when 5 then 'Pré-Proposta' when 6 then 'Enviada'
else 'erro 711' end as Situacao /*711 erro de coluna, nome errado, puxando errado*/
FROM
mov_Proposta_Frete Ppf
Left Outer Join
cad_Pessoa Pes on Pes.IdPessoa = Ppf.IdCliente
Left Outer Join
cad_Pessoa Ven on Ven.IdPessoa = Ppf.IdVendedor
/*where*/
