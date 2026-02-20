SELECT
	ROW_NUMBER() OVER(PARTITION BY @@ROWCOUNT ORDER BY @@ROWCOUNT) AS Indice,
	IdTarifario_Maritimo,
	IdTarifario_Maritimo_Rota,
	IdTarifario_Maritimo_Agrupament,
	Tipo_Operacao,
	Tipo_Carga,
	Numero_Tarifario,
	Tipo_Frete,
	Armador,
	POL,
	POD,
	Mercadoria,
	Tipo_Equipamento,
	All_in,
	Moeda_Pagamento,
	Contrato,
	Data_Inicio_Vigencia,
	Data_Validade,
	Transit_Time_Maximo,
	Free_Time_Master,
	Free_Time_Master_Exterior,
	Observacao
FROM
	(
	/* TARIFÁRIOS DE ROTA */
SELECT
	Tmo.IdTarifario_Maritimo,
	Tmr.IdTarifario_Maritimo_Rota,
	IdTarifario_Maritimo_Agrupament = NULL,
	CASE Tmo.Tipo_Operacao
		WHEN 1 THEN 'EXPORTAÇÃO'
		WHEN 2 THEN 'IMPORTAÇÃO'
		WHEN 3 THEN 'NACIONAL'
		ELSE ''
	END AS Tipo_Operacao,
	Tmt.Tipo_Carga,
	Tmo.Numero as Numero_Tarifario,
	CASE Tmo.Tipo_Frete
		WHEN 1 THEN 'FAK'
		WHEN 2 THEN 'NAC'
		WHEN 3 THEN 'BID'
		WHEN 4 THEN 'LONG TERM'
		WHEN 5 THEN 'SPOT'
		ELSE ''
	END AS Tipo_Frete,
	Cia.Nome as Armador,
	Pol.Nome as POL,
	Pod.Nome as POD,
	Mer.Nome AS Mercadoria,
	Emo.Descricao as Tipo_Equipamento,
	SUM(COALESCE(Tmt.All_In,0)) as All_In,
	Mpg.Sigla as Moeda_Pagamento,
	Cft.Numero_Contrato as Contrato,
	COALESCE(Tmr.Data_Inicio_Vigencia, Tmo.Data_Inicio_Vigencia) AS Data_Inicio_Vigencia,
	COALESCE(Tmr.Data_Validade, Tmo.Data_Validade) AS Data_Validade,
	Tmr.Transit_Time_Maximo,
	Tme.Free_Time_Master,
	Tme.Free_Time_Master_Exterior,
	CAST(Tmo.Observacao AS VARCHAR(MAX)) AS Observacao
FROM
	mov_Tarifario_Maritimo Tmo
LEFT OUTER JOIN
	cad_Pessoa Cia on Cia.IdPessoa = Tmo.IdArmador
LEFT OUTER JOIN
	mov_Tarifario_Maritimo_Rota Tmr on Tmr.IdTarifario_Maritimo = Tmo.IdTarifario_Maritimo And COALESCE(Tmr.Data_Validade, Tmo.Data_Validade) >= GETDATE() /*Rotas dentro da Validade*/
LEFT OUTER JOIN
	cad_Origem_Destino Pol on Pol.IdOrigem_Destino = Tmr.IdPorto_Origem
LEFT OUTER JOIN
	cad_Origem_Destino Pod on Pod.IdOrigem_Destino = Tmr.IdPorto_Destino
LEFT OUTER JOIN(
SELECT
Tod.IdTarifario_Origem_Destino,
Trx.IdTarifario_Taxa,
Trx.Valor_Pagamento_Unitario,
Tod.IdOrigem_Destino
FROM
mov_Tarifario_Origem_Destino Tod
LEFT OUTER JOIN
mov_Tarifario_Taxa Trx on Trx.IdTarifario_Origem_Destino = Tod.IdTarifario_Origem_Destino) toddynho on toddynho.IdOrigem_Destino = Pod.IdOrigem_Destino

LEFT OUTER JOIN
	mov_Tarifario_Maritimo_Equipamento Tme on Tme.IdTarifario_Maritimo = Tmo.IdTarifario_Maritimo
LEFT OUTER JOIN
	cad_Equipamento_Maritimo Emo on Emo.IdEquipamento_Maritimo = Tme.IdEquipamento_Maritimo
LEFT OUTER JOIN
	mov_Tarifario_Maritimo_Mercadoria Tmm On Tmm.IdTarifario_Maritimo = Tmo.IdTarifario_Maritimo
LEFT OUTER JOIN
	cad_Mercadoria Mer On Mer.IdMercadoria = Tmm.IdMercadoria
	/* TAXAS DO TARIFÁRIO */
LEFT OUTER JOIN
	(SELECT
		Tmr.IdTarifario_Maritimo_Rota,
		COALESCE(Tte.Total_Pgto_Outros, 0) + COALESCE(Ttd.Total_Pgto_TEU, 0) AS All_in,
		CASE Tte.Tipo_Carga
			WHEN 2 THEN 'Break-Bulk'
			WHEN 3 THEN 'FCL'
			WHEN 4 THEN 'LCL'
			WHEN 5 THEN 'RO-RO'
			ELSE '(Não especificado)'
		END AS Tipo_Carga,
		Tte.IdEquipamento_Maritimo,
		Tte.IdMoeda_Pagamento
	FROM
		mov_Tarifario_Maritimo_Rota Tmr
	LEFT OUTER JOIN
		(SELECT
			Tmt.IdTarifario_Maritimo_Rota,
			Tmt.IdMoeda_Pagamento,
			Tmt.Tipo_Carga,
			SUM(Tmt.Valor_Pagamento_Unitario) as Total_Pgto_Outros,
			CASE 
				WHEN Tmt.IdEquipamento_Maritimo IS NOT NULL THEN Tmt.IdEquipamento_Maritimo
				WHEN Aem.IdEquipamento_Maritimo IS NOT NULL THEN  Aem.IdEquipamento_Maritimo
			END AS IdEquipamento_Maritimo
		FROM
			mov_Tarifario_Maritimo_Taxa Tmt
		LEFT OUTER JOIN
			cad_Agrupamento_Equipamento_Maritimo_Item Aem On Aem.IdAgrup_Equipamento_Maritimo = Tmt.IdAgrup_Equipamento_Maritimo
		WHERE
			Tmt.Tipo_Pagamento NOT IN (7, 12)
		GROUP BY
			Tmt.IdTarifario_Maritimo_Rota, 
			Tmt.Tipo_Carga, 
			CASE 
				WHEN Tmt.IdEquipamento_Maritimo IS NOT NULL THEN Tmt.IdEquipamento_Maritimo
				WHEN Aem.IdEquipamento_Maritimo IS NOT NULL THEN  Aem.IdEquipamento_Maritimo
			END, 
			Tmt.IdMoeda_Pagamento) Tte ON Tte.IdTarifario_Maritimo_Rota = Tmr.IdTarifario_Maritimo_Rota
	LEFT OUTER JOIN
		(SELECT
			Tmt.IdTarifario_Maritimo_Rota,
			Tmt.IdMoeda_Pagamento,
			Tmt.Tipo_Carga,
			SUM(Tmt.Valor_Pagamento_Unitario * 2) as Total_Pgto_TEU
		FROM
			mov_Tarifario_Maritimo_Taxa Tmt
		WHERE
			Tmt.Tipo_Pagamento = 12
		GROUP BY
			Tmt.IdTarifario_Maritimo_Rota, Tmt.Tipo_Carga, Tmt.IdMoeda_Pagamento) Ttd ON Ttd.IdTarifario_Maritimo_Rota = Tmr.IdTarifario_Maritimo_Rota AND (Ttd.Tipo_Carga = Tte.Tipo_Carga AND Ttd.IdMoeda_Pagamento = Tte.IdMoeda_Pagamento)
		) Tmt on Tmt.IdTarifario_Maritimo_Rota = Tmr.IdTarifario_Maritimo_Rota AND (Tmt.IdEquipamento_Maritimo = Tme.IdEquipamento_Maritimo)

LEFT OUTER JOIN
	mov_Contrato_Frete Cft on Cft.IdContrato_Frete = Tmo.IdContrato_Frete
LEFT OUTER JOIN
	cad_Moeda Mpg on Mpg.IdMoeda = Tmt.IdMoeda_Pagamento
WHERE
	Tmo.Ativo = 1
AND
	Tmo.Data_Validade >= GETDATE() /*Tarifários dentro da Validade*/
AND 
	Tmr.IdTarifario_Maritimo_Rota IS NOT NULL
GROUP BY
	Tmo.IdTarifario_Maritimo,
	Tmr.IdTarifario_Maritimo_Rota,
	Tmo.Tipo_Operacao,
	Tmt.Tipo_Carga,
	Tmo.Numero,
	Tmo.Tipo_Frete,
	Cia.Nome,
	Pol.Nome,
	Pod.Nome,
	Emo.Descricao,
	Mpg.Sigla,
	Cft.Numero_Contrato,
	COALESCE(Tmr.Data_Inicio_Vigencia, Tmo.Data_Inicio_Vigencia),
	COALESCE(Tmr.Data_Validade, Tmo.Data_Validade),
	Tmr.Transit_Time_Maximo,
	Tme.Free_Time_Master,
	Tme.Free_Time_Master_Exterior,
	Mer.Nome,
	CAST(Tmo.Observacao AS VARCHAR(MAX))
UNION ALL
	/* TARIFÁRIOS DE AGRUPAMENTO */
	SELECT
	Tmo.IdTarifario_Maritimo,
	IdTarifario_Maritimo_Rota = NULL,
	Tma.IdTarifario_Maritimo_Agrupament,
	CASE Tmo.Tipo_Operacao
		WHEN 1 THEN 'EXPORTAÇÃO'
		WHEN 2 THEN 'IMPORTAÇÃO'
		WHEN 3 THEN 'NACIONAL'
		ELSE ''
	END AS Tipo_Operacao,
	Tmt.Tipo_Carga,
	Tmo.Numero as Numero_Tarifario,
	CASE Tmo.Tipo_Frete
		WHEN 1 THEN 'FAK'
		WHEN 2 THEN 'NAC'
		WHEN 3 THEN 'BID'
		WHEN 4 THEN 'LONG TERM'
		WHEN 5 THEN 'SPOT'
		ELSE ''
	END AS Tipo_Frete,
	Cia.Nome as Armador,
	Pol.Nome as Origem,
	Pod.Nome as Destino,
	Mer.Nome AS Mercadoria,
	Emo.Descricao as Tipo_Equipamento,
	SUM(COALESCE(Tmt.All_In,0)) as All_In,
	Mpg.Sigla as Moeda_Pagamento,
	Cft.Numero_Contrato as Contrato,
	Tmo.Data_Inicio_Vigencia,
	Tmo.Data_Validade,
	Transit_Time_Maximo = NULL,
	Tme.Free_Time_Master,
	Tme.Free_Time_Master_Exterior,
	CAST(Tmo.Observacao AS VARCHAR(MAX)) AS Observacao
From
	mov_Tarifario_Maritimo Tmo
LEFT OUTER JOIN
	cad_Pessoa Cia on Cia.IdPessoa = Tmo.IdArmador
LEFT OUTER JOIN
	mov_Tarifario_Maritimo_Agrupamento Tma on Tma.IdTarifario_Maritimo = Tmo.IdTarifario_Maritimo
LEFT OUTER JOIN
	mov_Tarifario_Agrupamento_Porto Apt on Apt.IdTarifario_Agrupamento_Porto = Tma.IdAgrupamento_Origem
LEFT OUTER JOIN
	mov_Tarifario_Agrupamento_Porto Agp on Agp.IdTarifario_Agrupamento_Porto = Tma.IdAgrupamento_Destino
LEFT OUTER JOIN
	mov_Tarifario_Maritimo_Equipamento Tme on Tme.IdTarifario_Maritimo = Tmo.IdTarifario_Maritimo
LEFT OUTER JOIN
	cad_Equipamento_Maritimo Emo on Emo.IdEquipamento_Maritimo = Tme.IdEquipamento_Maritimo
LEFT OUTER JOIN
	mov_Tarifario_Maritimo_Mercadoria Tmm On Tmm.IdTarifario_Maritimo = Tmo.IdTarifario_Maritimo
LEFT OUTER JOIN
	cad_Mercadoria Mer On Mer.IdMercadoria = Tmm.IdMercadoria
LEFT OUTER JOIN
	mov_Tarifario_Agrupamento_Item Org ON Org.IdTarifario_Agrupamento_Porto = Apt.IdTarifario_Agrupamento_Porto
LEFT OUTER JOIN
	mov_Tarifario_Agrupamento_Item Dst ON Dst.IdTarifario_Agrupamento_Porto = Agp.IdTarifario_Agrupamento_Porto
LEFT OUTER JOIN
	cad_Origem_Destino Pol ON Pol.IdOrigem_Destino = Org.IdOrigem_Destino
LEFT OUTER JOIN
	cad_Origem_Destino Pod ON Pod.IdOrigem_Destino = Dst.IdOrigem_Destino

	/* TAXAS DO TARIFÁRIO */
LEFT OUTER JOIN
	(SELECT
		Tma.IdTarifario_Maritimo_Agrupament,
		SUM(COALESCE(Tte.Total_Pgto_Outros,0) + COALESCE(Ttd.Total_Pgto_TEU,0)) as All_In,
		CASE Tte.Tipo_Carga
			WHEN 2 THEN 'Break-Bulk'
			WHEN 3 THEN 'FCL'
			WHEN 4 THEN 'LCL'
			WHEN 5 THEN 'RO-RO'
			ELSE '(Não especificado)'
		END AS Tipo_Carga,
		Tte.IdEquipamento_Maritimo,
		Tte.IdMoeda_Pagamento
	FROM
		mov_Tarifario_Maritimo_Agrupamento Tma
	LEFT OUTER JOIN
		(SELECT
			Tmt.IdTarifario_Maritimo_Agrupament,
			Tmt.IdMoeda_Pagamento,
			Tmt.Tipo_Carga,
			SUM(Tmt.Valor_Pagamento_Unitario) as Total_Pgto_Outros,
			CASE 
				WHEN Tmt.IdEquipamento_Maritimo IS NOT NULL THEN Tmt.IdEquipamento_Maritimo
				WHEN Aem.IdEquipamento_Maritimo IS NOT NULL THEN  Aem.IdEquipamento_Maritimo
			END AS IdEquipamento_Maritimo
		FROM
			mov_Tarifario_Maritimo_Taxa Tmt
		LEFT OUTER JOIN
			cad_Agrupamento_Equipamento_Maritimo_Item Aem On Aem.IdAgrup_Equipamento_Maritimo = Tmt.IdAgrup_Equipamento_Maritimo
		WHERE
			Tmt.Tipo_Pagamento NOT IN (7, 12)
		GROUP BY
			Tmt.IdTarifario_Maritimo_Agrupament, 
			Tmt.Tipo_Carga, 
			CASE 
				WHEN Tmt.IdEquipamento_Maritimo IS NOT NULL THEN Tmt.IdEquipamento_Maritimo
				WHEN Aem.IdEquipamento_Maritimo IS NOT NULL THEN  Aem.IdEquipamento_Maritimo
			END, 
			Tmt.IdMoeda_Pagamento) Tte ON Tte.IdTarifario_Maritimo_Agrupament = Tma.IdTarifario_Maritimo_Agrupament
	LEFT OUTER JOIN
		(SELECT
			Tmt.IdTarifario_Maritimo_Agrupament,
			Tmt.IdMoeda_Pagamento,
			Tmt.Tipo_Carga,
			SUM(Tmt.Valor_Pagamento_Unitario * 2) as Total_Pgto_TEU
		FROM
			mov_Tarifario_Maritimo_Taxa Tmt
		WHERE
			Tmt.Tipo_Pagamento = 12
		GROUP BY
			Tmt.IdTarifario_Maritimo_Agrupament, Tmt.Tipo_Carga, Tmt.IdMoeda_Pagamento) Ttd ON Ttd.IdTarifario_Maritimo_Agrupament = Tma.IdTarifario_Maritimo_Agrupament AND (Ttd.Tipo_Carga = CASE WHEN Ttd.Tipo_Carga IS NULL THEN NULL WHEN Ttd.Tipo_Carga IS NOT NULL THEN Tte.Tipo_Carga END AND Ttd.IdMoeda_Pagamento = CASE WHEN Ttd.IdMoeda_Pagamento IS NULL THEN NULL WHEN Ttd.IdMoeda_Pagamento IS NOT NULL THEN Tte.IdMoeda_Pagamento END)
	GROUP BY
		Tma.IdTarifario_Maritimo_Agrupament,
		CASE Tte.Tipo_Carga
			WHEN 2 THEN 'Break-Bulk'
			WHEN 3 THEN 'FCL'
			WHEN 4 THEN 'LCL'
			WHEN 5 THEN 'RO-RO'
			ELSE '(Não especificado)'
		END,
		Tte.IdEquipamento_Maritimo,
		Tte.IdMoeda_Pagamento
	) Tmt ON Tmt.IdTarifario_Maritimo_Agrupament = Tma.IdTarifario_Maritimo_Agrupament AND (Tmt.IdEquipamento_Maritimo = Tme.IdEquipamento_Maritimo)
LEFT OUTER JOIN
	mov_Contrato_Frete Cft on Cft.IdContrato_Frete = Tmo.IdContrato_Frete 
LEFT OUTER JOIN
	cad_Moeda Mpg on Mpg.IdMoeda = Tmt.IdMoeda_Pagamento
WHERE
	Tmo.Ativo = 1
AND
	Tmo.Data_Validade >= GETDATE() /*Tarifários dentro da Validade*/
AND 
	Tma.IdTarifario_Maritimo_Agrupament IS NOT NULL
GROUP BY
	Tmo.IdTarifario_Maritimo,
	Tma.IdTarifario_Maritimo_Agrupament,
	Tmo.Tipo_Operacao,
	Tmt.Tipo_Carga,
	Tmo.Numero,
	Tmo.Tipo_Frete,
	Cia.Nome,
	Pol.Nome,
	Pod.Nome,
	Emo.Descricao,
	Emo.IdEquipamento_Maritimo,
	Mpg.Sigla,
	Cft.Numero_Contrato,
	Tmo.Data_Inicio_Vigencia,
	Tmo.Data_Validade,
	Tme.Free_Time_Master,
	Tme.Free_Time_Master_Exterior,
	Mer.Nome,
	CAST(Tmo.Observacao AS VARCHAR(MAX))) Trf
/*WHERE*/
WHERE Contrato not like '%rox%' /*REQ #41406-->*/ and Tipo_Carga is not null
