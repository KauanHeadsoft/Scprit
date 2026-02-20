SELECT
Lhs.Numero_Processo,
Lhs.Data_Abertura_Processo,
Pes.Nome AS Nome_Cliente,
Ven.Nome AS Vendedor,

CASE
	WHEN Lms.Tipo_Operacao = 1 THEN 'Exportacao'
	WHEN Lms.Tipo_Operacao = 2 THEN 'Importacao'
	WHEN Lms.Tipo_Operacao = 3 THEN 'Nacional'
	END AS Tipo_Operacao,
CASE
	WHEN Lms.Modalidade_Processo = 1 THEN 'Aereo'
	WHEN Lms.Modalidade_Processo = 2 THEN 'Maritimo'
	WHEN Lms.Modalidade_Processo = 3 THEN 'Terrestre'
	END AS Modalidade
FROM
mov_logistica_house Lhs
left outer join
cad_pessoa Pes ON Pes.IdPessoa = Lhs.IdCliente
left outer join
mov_Logistica_Master Lms ON Lms.IdLogistica_Master = Lhs.IdLogistica_Master
left outer join
cad_pessoa Ven ON Ven.IdPessoa = Lhs.IdVendedor
WHERE
Lms.Tipo_Operacao = 2 /*importação*/
AND
Lms.Modalidade_Processo = 2 /*maritima*/


