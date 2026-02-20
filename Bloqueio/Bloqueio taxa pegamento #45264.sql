<Dados_Registro><CommandText>
SELECT
  @Acao = CASE
    WHEN Bloqueado = 1 THEN 5 /* bloqueado exibir aviso */
    ELSE 0
  END,
  @Mensagem = CAST(CASE
    WHEN Bloqueado = 1 THEN '[BLC] TESTE BLOCK AEREO'
    ELSE NULL
  END as VARCHAR(MAX))
FROM
  (SELECT
    CAST(CASE
      WHEN ((Prm.IdOferta_Frete_Taxa IS NOT NULL AND Ofr.Modalidade_Processo = 1) AND
          (
            (Prm.Valor_Pagamento_Unitario &lt;&gt; Prm.Old_Valor_Pagamento_Unitario) OR
            (Prm.Valor_Pagamento_Total &lt;&gt; Prm.Old_Valor_Pagamento_Total) OR
            (Prm.Quantidade_Pagamento &lt;&gt; Prm.Old_Quantidade_Pagamento) OR
            (Prm.Modalidade_Pagamento &lt;&gt; Prm.Old_Modalidade_Pagamento) OR
            (Prm.IdPessoa_Pagamento &lt;&gt; Prm.Old_IdPessoa_Pagamento) OR
            (Prm.IdMoeda_Pagamento &lt;&gt; Prm.Old_IdMoeda_Pagamento) OR
            (Prm.Tipo_Pagamento &lt;&gt; Prm.Old_Tipo_Pagamento) OR
            (Prm.Pagar_Para &lt;&gt; Prm.Old_Pagar_Para)
          )
      ) THEN 1
      ELSE 0
    END as int) as Bloqueado
  FROM
    (SELECT
      /*New*/
      Prm.value('Item[@Nome="IdOferta_Frete_Taxa"][1]/@Value', 'int') as IdOferta_Frete_Taxa,
      Prm.value('Item[@Nome="IdOferta_Frete"][1]/@Value', 'int') as IdOferta_Frete,
      Prm.value('Item[@Nome="Valor_Pagamento_Unitario"][1]/@Value', 'Numeric') as Valor_Pagamento_Unitario,
      Prm.value('Item[@Nome="Valor_Pagamento_Total"][1]/@Value', 'Numeric') as Valor_Pagamento_Total,
      Prm.value('Item[@Nome="Quantidade_Pagamento"][1]/@Value', 'Numeric') as Quantidade_Pagamento,
      Prm.value('Item[@Nome="Modalidade_Pagamento"][1]/@Value', 'int') as Modalidade_Pagamento,
      Prm.value('Item[@Nome="IdPessoa_Pagamento"][1]/@Value', 'int') as IdPessoa_Pagamento,
      Prm.value('Item[@Nome="IdMoeda_Pagamento"][1]/@Value', 'int') as IdMoeda_Pagamento,
      Prm.value('Item[@Nome="Tipo_Pagamento"][1]/@Value', 'int') as Tipo_Pagamento,
      Prm.value('Item[@Nome="Pagar_Para"][1]/@Value', 'int') as Pagar_Para,
      /*Old*/
      Prm.value('Item[@Nome="Valor_Pagamento_Unitario"][1]/@OldValue', 'Numeric') as Old_Valor_Pagamento_Unitario,
      Prm.value('Item[@Nome="Valor_Pagamento_Total"][1]/@OldValue', 'Numeric') as Old_Valor_Pagamento_Total,
      Prm.value('Item[@Nome="Quantidade_Pagamento"][1]/@OldValue', 'Numeric') as Old_Quantidade_Pagamento,
      Prm.value('Item[@Nome="Modalidade_Pagamento"][1]/@OldValue', 'int') as Old_Modalidade_Pagamento,
      Prm.value('Item[@Nome="IdPessoa_Pagamento"][1]/@OldValue', 'int') as Old_IdPessoa_Pagamento,
      Prm.value('Item[@Nome="IdMoeda_Pagamento"][1]/@OldValue', 'int') as Old_IdMoeda_Pagamento,
      Prm.value('Item[@Nome="Tipo_Pagamento"][1]/@OldValue', 'int') as Old_Tipo_Pagamento,
      Prm.value('Item[@Nome="Pagar_Para"][1]/@OldValue', 'int') as Old_Pagar_Para     
    FROM
      @Parametros.nodes('/Parametros/Evento/Campos') as Parametros(Prm)
    ) Prm
  LEFT OUTER JOIN
    mov_Oferta_Frete Ofr On Ofr.IdOferta_Frete = Prm.IdOferta_Frete
  ) Blq
</CommandText></Dados_Registro>