Select
Ctf.Descricao as Nome_Contrato,
Pes.nome as Agente,
Ctf.Data_Validade
From
cad_contrato_Financeiro Ctf
Left Outer Join
cad_Pessoa Pes on Pes.IdContrato_Financeiro = Ctf.IdContrato_Financeiro
Where
Ctf.Descricao Like '%Kauan%'