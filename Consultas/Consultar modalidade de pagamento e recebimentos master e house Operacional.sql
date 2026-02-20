SELECT
CASE
	WHEN Lhs.modalidade_pagamento = 1 THEN 'Collect/Prepaid'
	WHEN Lhs.modalidade_pagamento = 2 THEN 'Collect'
	WHEN Lhs.modalidade_pagamento = 3 THEN 'Prepaid'
	WHEN Lhs.modalidade_pagamento = 4 THEN 'Prepaid abroad'
	END AS Modalidade_Pagamento_House,
	CASE
	WHEN Lms.modalidade_pagamento = 1 THEN 'Collect/Prepaid'
	WHEN Lms.modalidade_pagamento = 2 THEN 'Collect'
	WHEN Lms.modalidade_pagamento = 3 THEN 'Prepaid'
	WHEN Lms.modalidade_pagamento = 4 THEN 'Prepaid abroad'
	END AS Modalidade_Pagamento_Master,
CASE
	WHEN Ltx.Modalidade_Pagamento = 0 THEN 'Não definida'
	WHEN Ltx.Modalidade_Pagamento = 1 THEN 'Prepaid'
	WHEN Ltx.Modalidade_Pagamento = 2 THEN 'Collect'
	WHEN Ltx.Modalidade_Pagamento = 4 THEN 'Abroad'
	END AS Modalidade_Pagamento_Taxa,
	CASE
	WHEN Ltx.Modalidade_Recebimento = 0 THEN 'Não definida'
	WHEN Ltx.Modalidade_Recebimento = 1 THEN 'Prepaid'
	WHEN Ltx.Modalidade_Recebimento = 2 THEN 'Collect'
	WHEN Ltx.Modalidade_Recebimento = 4 THEN 'Abroad'
	END AS Modalidade_Recebimento_Taxa
FROM
mov_logistica_house Lhs
Left Outer Join
mov_logistica_taxa Ltx ON Ltx.IdLogistica_House = Lhs.IdLogistica_House
Left Outer Join	
mov_logistica_master Lms ON Lms.IdLogistica_Master = Lhs.IdLogistica_Master
