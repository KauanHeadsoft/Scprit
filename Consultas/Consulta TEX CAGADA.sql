DECLARE @Tabela    VARCHAR(MAX) = 'cad_Modelo_Mensagem'
DECLARE @PK1_Nome  VARCHAR(200) = 'IdModelo_Mensagem'
DECLARE @PK1_Valor VARCHAR(MAX) = '345'

-- Opcionais, use apenas quando precisar se não, deixe-os em branco!

--SELECT /*Para campos livres*/
--*
--FROM
--vis_Logistica_campo_livre
--WHERE
--idcampo_livre = 3763


DECLARE @PK2_Nome  VARCHAR(200) = ''
DECLARE @PK2_Valor VARCHAR(MAX) = ''
DECLARE @PK3_Nome  VARCHAR(200) = ''
DECLARE @PK3_Valor VARCHAR(MAX) = ''

DECLARE @Data_Inicio_Texto  VARCHAR(20) = '01/11/2025' -- dd/MM/yyyy
DECLARE @Usar_Hoje_Termino  BIT         = 1            -- 1 = usar GETDATE(); 0 = usar @Data_Termino_Texto
DECLARE @Data_Termino_Texto VARCHAR(20) = ''           -- dd/MM/yyyy (use se @Usar_Hoje_Termino = 0)

-- ?? OUTROS FILTROS

DECLARE @IdUsuario IdCurto  = 0  -- 0 = Todos
DECLARE @Tipo      TipoFixo = 0  -- 0 = Todos | 1=Inserção | 2=Exclusão | 3=Alteração




/* -----------------------------------
   ?? Variáveis internas
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
SET @Tabela             = NULLIF(LTRIM(RTRIM(@Tabela))            , '')

-- Monta a lista de PKs
DECLARE @PK_Input TABLE (Nome VARCHAR(200), Valor VARCHAR(MAX))
IF @PK1_Nome IS NOT NULL AND @PK1_Valor IS NOT NULL INSERT INTO @PK_Input VALUES (@PK1_Nome, @PK1_Valor)
IF @PK2_Nome IS NOT NULL AND @PK2_Valor IS NOT NULL INSERT INTO @PK_Input VALUES (@PK2_Nome, @PK2_Valor)
IF @PK3_Nome IS NOT NULL AND @PK3_Valor IS NOT NULL INSERT INTO @PK_Input VALUES (@PK3_Nome, @PK3_Valor)

-- Constrói o XML <PrimaryKeys>
SET @Primary_Keys = (
  SELECT Nome AS [@Nome], Valor AS [@Value]
  FROM @PK_Input
  FOR XML PATH('Item'), ROOT('PrimaryKeys'), TYPE
)

-- Converte Data_Inicio
SET @Data_Inicio =
  COALESCE(
    TRY_CONVERT(DATETIME, @Data_Inicio_Texto, 103),
    TRY_CONVERT(DATETIME, @Data_Inicio_Texto, 120),
    TRY_CONVERT(DATETIME, @Data_Inicio_Texto)
  )

-- Define Data_Termino (fim do dia quando informar texto)
IF @Usar_Hoje_Termino = 1
  SET @Data_Termino = GETDATE()
ELSE
  SET @Data_Termino =
    DATEADD(SECOND, 86399,
      COALESCE(
        TRY_CONVERT(DATETIME, @Data_Termino_Texto, 103),
        TRY_CONVERT(DATETIME, @Data_Termino_Texto, 120),
        TRY_CONVERT(DATETIME, @Data_Termino_Texto)
      )
    )

-- ?? Agrupar múltiplos valores por campo
DECLARE @FiltroXml TABLE (Nome VARCHAR(MAX), VALUE VARCHAR(MAX))
INSERT INTO @FiltroXml
SELECT
  Pks.value('@Nome',  'VARCHAR(MAX)') AS Nome,
  Pks.value('@Value', 'VARCHAR(MAX)') AS Value
FROM
  @Primary_Keys.nodes('/PrimaryKeys/Item') AS PrimaryKeys(Pks)

-- ?? Filtros dinâmicos
SET @Filtro_Tabela = ''
IF @Tabela IS NOT NULL
  SET @Filtro_Tabela = '[@Nome="'+@Tabela+'"]'

SET @Filtro_Campo = ''
SELECT @Filtro_Campo = @Filtro_Campo +
  '[Campo[@Nome="'+Nome+'" and (' +
  STRING_AGG('@Value="'+VALUE+'"', ' or ') +
  ')]]'
FROM @FiltroXml
GROUP BY Nome

SET @Filtro_Tipo = ''
IF @Tipo <> 0
  SET @Filtro_Tipo = '[@Tipo="'+CAST(@Tipo AS VARCHAR(MAX))+'"]'

/* ?? Expressão de Id segura (numérica) */
SET @IdExprList  = ''
SET @IdExprCount = 0

IF @PK1_Nome IS NOT NULL
BEGIN
  SET @IdExprList  = @IdExprList + CASE WHEN @IdExprCount > 0 THEN ', ' ELSE '' END +
    'TRY_CONVERT(INT,
       CASE
         WHEN Dlg.exist(''Campo[@Nome="' + @PK1_Nome + '"]/@Value'')=1
           THEN Dlg.value(''(Campo[@Nome="' + @PK1_Nome + '"]/@Value)[1]'',''VARCHAR(MAX)'')
         WHEN Dlg.exist(''Campo[@Nome="' + @PK1_Nome + '"]/@OldValue'')=1
           THEN Dlg.value(''(Campo[@Nome="' + @PK1_Nome + '"]/@OldValue)[1]'',''VARCHAR(MAX)'')
         ELSE NULL
       END
     )'
  SET @IdExprCount = @IdExprCount + 1
END

IF @PK2_Nome IS NOT NULL
BEGIN
  SET @IdExprList  = @IdExprList + CASE WHEN @IdExprCount > 0 THEN ', ' ELSE '' END +
    'TRY_CONVERT(INT,
       CASE
         WHEN Dlg.exist(''Campo[@Nome="' + @PK2_Nome + '"]/@Value'')=1
           THEN Dlg.value(''(Campo[@Nome="' + @PK2_Nome + '"]/@Value)[1]'',''VARCHAR(MAX)'')
         WHEN Dlg.exist(''Campo[@Nome="' + @PK2_Nome + '"]/@OldValue'')=1
           THEN Dlg.value(''(Campo[@Nome="' + @PK2_Nome + '"]/@OldValue)[1]'',''VARCHAR(MAX)'')
         ELSE NULL
       END
     )'
  SET @IdExprCount = @IdExprCount + 1
END

IF @PK3_Nome IS NOT NULL
BEGIN
  SET @IdExprList  = @IdExprList + CASE WHEN @IdExprCount > 0 THEN ', ' ELSE '' END +
    'TRY_CONVERT(INT,
       CASE
         WHEN Dlg.exist(''Campo[@Nome="' + @PK3_Nome + '"]/@Value'')=1
           THEN Dlg.value(''(Campo[@Nome="' + @PK3_Nome + '"]/@Value)[1]'',''VARCHAR(MAX)'')
         WHEN Dlg.exist(''Campo[@Nome="' + @PK3_Nome + '"]/@OldValue'')=1
           THEN Dlg.value(''(Campo[@Nome="' + @PK3_Nome + '"]/@OldValue)[1]'',''VARCHAR(MAX)'')
         ELSE NULL
       END
     )'
  SET @IdExprCount = @IdExprCount + 1
END

IF @IdExprCount = 0
  SET @ExprId = 'NULL'
ELSE IF @IdExprCount = 1
  SET @ExprId = @IdExprList
ELSE
  SET @ExprId = 'COALESCE(' + @IdExprList + ')'

-- ORDER BY dinâmico (se não houver PK, ordena só pela data)
IF @IdExprCount = 0
  SET @OrderBy = 'ORDER BY Ltb.Data_Inicio'
ELSE
  SET @OrderBy = 'ORDER BY ' + @ExprId + ', Ltb.Data_Inicio'

-- ?? Consulta dinâmica
SET @SQL = '
SELECT
    Usr.Nome AS Usuario,
    CONVERT(VARCHAR(10), Ltb.Data_Inicio , 103) + '' '' + CONVERT(VARCHAR(8), Ltb.Data_Inicio , 108) AS Data_Inicio_Transacao,
    CONVERT(VARCHAR(10), Ltb.Data_Termino, 103) + '' '' + CONVERT(VARCHAR(8), Ltb.Data_Termino, 108) AS Data_Termino_Transacao,
    DATEDIFF(SECOND, Ltb.Data_Inicio, Ltb.Data_Termino) AS Tempo_Transacao,
    Dlg.value(''../@WindowsUser'',  ''VARCHAR(MAX)'') AS Usuario_Windows,
    Dlg.value(''../@ComputerName'', ''VARCHAR(MAX)'') AS Computador,
    Dlg.value(''@Nome'',           ''VARCHAR(MAX)'')  AS Tabela,
    ' + @ExprId + ' AS Id,
    CASE Dlg.value(''@Tipo'', ''SMALLINT'')
         WHEN 1 THEN ''INSERÇÃO''
         WHEN 2 THEN ''EXCLUSÃO''
         WHEN 3 THEN ''ALTERAÇÃO''
         ELSE CAST(Dlg.value(''@Tipo'', ''SMALLINT'') AS VARCHAR(10))
    END AS Tipo,
    CONVERT(VARCHAR(10), CONVERT(DATETIME, Dlg.value(''@Data'', ''VARCHAR(MAX)''), 101), 103)
      + '' '' +
    CONVERT(VARCHAR(8),  CONVERT(DATETIME, Dlg.value(''@Data'', ''VARCHAR(MAX)''), 101), 108) AS Data,
    Dlg.query(''<Campos>{Campo}</Campos>'') AS Campos
FROM
    sys_Log_Tabela Ltb
CROSS APPLY
    Ltb.Dados_Log.nodes(''/Log/Tabela' + @Filtro_Tabela + @Filtro_Tipo + @Filtro_Campo + ''') AS DadosLog(Dlg)
JOIN
    sys_Usuario Usr ON Usr.IdUsuario = Ltb.IdUsuario
WHERE
    ((@IdUsuario = 0) OR (Ltb.IdUsuario = @IdUsuario))
    AND (
        ((@Data_Inicio IS NULL) AND (@Data_Termino IS NULL)) OR
        (Ltb.Data_Inicio  BETWEEN @Data_Inicio AND @Data_Termino) OR
        (Ltb.Data_Termino BETWEEN @Data_Inicio AND @Data_Termino)
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
 