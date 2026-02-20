SELECT   
    Ppl.Nome as Nome_Papel,  
    Bcl.Dados_Registro.value('.', 'NVARCHAR(MAX)') AS Dados_Registro,  
    SUBSTRING(  
        CAST(Bcl.Dados_Registro AS NVARCHAR(MAX)),   
        CHARINDEX('''', CAST(Bcl.Dados_Registro AS NVARCHAR(MAX))) + 1,   
        CHARINDEX('''', CAST(Bcl.Dados_Registro AS NVARCHAR(MAX)), CHARINDEX('''', CAST(Bcl.Dados_Registro AS NVARCHAR(MAX))) + 1)   
        - CHARINDEX('''', CAST(Bcl.Dados_Registro AS NVARCHAR(MAX))) - 1  
    ) AS Mensagem_Bloqueio  
FROM   
cad_Bloqueio_Condicional Bcl  
LEFT OUTER JOIN   
sys_Papel Ppl ON Ppl.IdPapel = Bcl.IdPapel  
WHERE   
    CAST(Bcl.Dados_Registro AS NVARCHAR(MAX)) LIKE '%armador cobra pela emissão%'
 
