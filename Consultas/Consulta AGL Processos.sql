DECLARE @Tabela      VARCHAR(MAX) = 'mov_Logistica_House'
DECLARE @PK1_Nome    VARCHAR(200) = 'IdLogistica_House'
DECLARE @PK1_Valor   VARCHAR(MAX) = '' -- VAZIO para pegar todos da lista

-- Opcionais
DECLARE @PK2_Nome    VARCHAR(200) = ''
DECLARE @PK2_Valor   VARCHAR(MAX) = ''
DECLARE @PK3_Nome    VARCHAR(200) = ''
DECLARE @PK3_Valor   VARCHAR(MAX) = ''

DECLARE @Data_Inicio_Texto  VARCHAR(20) = '01/01/2025' -- Data Ajustada
DECLARE @Usar_Hoje_Termino  BIT         = 1            
DECLARE @Data_Termino_Texto VARCHAR(20) = ''           

-- ?? OUTROS FILTROS
DECLARE @IdUsuario IdCurto  = 0  -- 0 = Todos
DECLARE @Tipo      TipoFixo = 0  -- 0 = Todos

/* -----------------------------------
   ?? Variáveis internas (ESTRUTURA ORIGINAL MANTIDA)
----------------------------------- */
DECLARE
  @Primary_Keys  XML,
  @Data_Inicio   DATETIME,
  @Data_Termino  DATETIME,
  @SQL           NVARCHAR(MAX),
  @Filtro_Tabela VARCHAR(MAX),
  @Filtro_Campo  VARCHAR(MAX),
  @Filtro_Tipo   VARCHAR(MAX),
  @IdExprList    NVARCHAR(MAX),
  @IdExprCount   INT,
  @ExprId        NVARCHAR(MAX),
  @OrderBy       NVARCHAR(MAX)

-- Normaliza entradas
SET @PK1_Nome  = NULLIF(LTRIM(RTRIM(@PK1_Nome)) , '')
SET @PK1_Valor = NULLIF(LTRIM(RTRIM(@PK1_Valor)), '')
SET @PK2_Nome  = NULLIF(LTRIM(RTRIM(@PK2_Nome)) , '')
SET @PK2_Valor = NULLIF(LTRIM(RTRIM(@PK2_Valor)), '')
SET @PK3_Nome  = NULLIF(LTRIM(RTRIM(@PK3_Nome)) , '')
SET @PK3_Valor = NULLIF(LTRIM(RTRIM(@PK3_Valor)), '')

SET @Data_Inicio_Texto  = NULLIF(LTRIM(RTRIM(@Data_Inicio_Texto)) , '')
SET @Data_Termino_Texto = NULLIF(LTRIM(RTRIM(@Data_Termino_Texto)), '')
SET @Tabela             = NULLIF(LTRIM(RTRIM(@Tabela))             , '')

-- Monta a lista de PKs (Mantido estrutura original)
DECLARE @PK_Input TABLE (Nome VARCHAR(200), Valor VARCHAR(MAX))
IF @PK1_Nome IS NOT NULL AND @PK1_Valor IS NOT NULL INSERT INTO @PK_Input VALUES (@PK1_Nome, @PK1_Valor)

-- Constrói o XML <PrimaryKeys>
SET @Primary_Keys = (SELECT Nome AS [@Nome], Valor AS [@Value] FROM @PK_Input FOR XML PATH('Item'), ROOT('PrimaryKeys'), TYPE)

-- Converte Datas
SET @Data_Inicio = COALESCE(TRY_CONVERT(DATETIME, @Data_Inicio_Texto, 103), TRY_CONVERT(DATETIME, @Data_Inicio_Texto, 120))
IF @Usar_Hoje_Termino = 1 SET @Data_Termino = GETDATE()
ELSE SET @Data_Termino = DATEADD(SECOND, 86399, COALESCE(TRY_CONVERT(DATETIME, @Data_Termino_Texto, 103), TRY_CONVERT(DATETIME, @Data_Termino_Texto, 120)))

-- ?? Filtros dinâmicos básicos
SET @Filtro_Tabela = ''
IF @Tabela IS NOT NULL SET @Filtro_Tabela = '[@Nome="'+@Tabela+'"]'

/* ?? Expressão de Id segura (numérica) */
-- AQUI EU GARANTO QUE O ID SEJA RECUPERADO CORRETAMENTE DO XML
SET @ExprId = 'TRY_CONVERT(INT, CASE WHEN Dlg.exist(''Campo[@Nome="' + @PK1_Nome + '"]/@Value'')=1 THEN Dlg.value(''(Campo[@Nome="' + @PK1_Nome + '"]/@Value)[1]'',''VARCHAR(MAX)'') WHEN Dlg.exist(''Campo[@Nome="' + @PK1_Nome + '"]/@OldValue'')=1 THEN Dlg.value(''(Campo[@Nome="' + @PK1_Nome + '"]/@OldValue)[1]'',''VARCHAR(MAX)'') ELSE NULL END)'

-- ORDER BY: Organizado por Processo
SET @OrderBy = 'ORDER BY Lhs.Numero_Processo ASC, Ltb.Data_Inicio ASC'

-- ?? Consulta dinâmica (AGORA SIM, CORRIGIDA E COMPLETA)
SET @SQL = '
SELECT
    -- Dados do Processo
    Lhs.Numero_Processo,
    CONVERT(VARCHAR(10), Lhs.Data_Abertura_Processo, 103) AS Data_Abertura,
    Pes.Nome AS Cliente,
    
    -- Status Traduzido
    CASE Lhs.Situacao_Agenciamento
        WHEN 1 THEN ''Processo aberto''
        WHEN 2 THEN ''Em andamento''
        WHEN 3 THEN ''Liberado faturamento''
        WHEN 4 THEN ''Faturado''
        WHEN 5 THEN ''Finalizado''
        WHEN 6 THEN ''Auditado''
        WHEN 7 THEN ''Cancelado''
        ELSE CAST(Lhs.Situacao_Agenciamento AS VARCHAR)
    END AS Situacao,

    -- Dados do Log (Recuperando Tipo do XML corretamente)
    Usr.Nome AS Usuario,
    CONVERT(VARCHAR(10), Ltb.Data_Inicio , 103) + '' '' + CONVERT(VARCHAR(8), Ltb.Data_Inicio , 108) AS Data_Hora,
    
    CASE Dlg.value(''@Tipo'', ''SMALLINT'')
         WHEN 1 THEN ''INSERÇÃO''
         WHEN 2 THEN ''EXCLUSÃO''
         WHEN 3 THEN ''ALTERAÇÃO''
         ELSE CAST(Dlg.value(''@Tipo'', ''SMALLINT'') AS VARCHAR(10))
    END AS Tipo,
    
    -- Campos Explodidos para Planilha
    C.value(''@Nome'', ''VARCHAR(MAX)'') AS [Campo_Alterado],
    C.value(''@OldValue'', ''VARCHAR(MAX)'') AS [Valor_Antigo_De],
    C.value(''@Value'', ''VARCHAR(MAX)'') AS [Valor_Novo_Para],

    -- ID Técnico
    ' + @ExprId + ' AS IdLogistica_House

FROM
    sys_Log_Tabela Ltb
    
-- XML: Pega o nó principal
CROSS APPLY
    Ltb.Dados_Log.nodes(''/Log/Tabela' + @Filtro_Tabela + ''') AS DadosLog(Dlg)

-- XML: Explode os campos (ISSO GERA AS LINHAS EXTRAS PARA O EXCEL)
CROSS APPLY
    Dlg.nodes(''Campo'') AS T(C)

-- JOINS: Traz dados do usuário e do processo
JOIN
    sys_Usuario Usr ON Usr.IdUsuario = Ltb.IdUsuario
LEFT JOIN 
    mov_Logistica_House Lhs ON Lhs.IdLogistica_House = ' + @ExprId + '
LEFT JOIN 
    cad_Pessoa Pes ON Pes.IdPessoa = Lhs.IdCliente

WHERE
    ((@IdUsuario = 0) OR (Ltb.IdUsuario = @IdUsuario))
    AND (Ltb.Data_Inicio BETWEEN @Data_Inicio AND @Data_Termino)
    
    -- LISTA DE PROCESSOS NO FILTRO
    AND Lhs.Numero_Processo IN (
        ''AGLIA0309-25'',
        ''AGLIA1634-25'',
        ''AGLIA2941-25'',
        ''AGLIA3537-25'',
        ''AGLIA3641-25'',
        ''AGLIA3875-25'',
        ''AGLIA2880-25'',
        ''AGLIA4155-25'',
        ''AGLIA3235-25'',
        ''AGLIA3145-24 COMPLEMENTAR'',
        ''AGLIA3259-25'',
        ''AGLIA3119-25'',
        ''AGLIA3035-25''
    )
    
' + @OrderBy + '
'

-- ?? Execução
EXEC sp_executesql 
  @SQL, 
  N'@Data_Inicio DATETIME, @Data_Termino DATETIME, @IdUsuario IdCurto',
  @Data_Inicio  = @Data_Inicio,
  @Data_Termino = @Data_Termino,
  @IdUsuario    = @IdUsuario