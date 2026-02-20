Declare @IdOferta_Frete bigint
Set @IdOferta_Frete = 9346 -- Ajustei para o ID do seu print (9346) para batermos os valores

Select
  @IdOferta_Frete As IdOferta_Frete,
  
  -- Colunas auxiliares para cabeçalho do relatório
  (Select Top 1 Pfc.Valor_Mercadoria 
   From mov_Oferta_Frete Ofr2 
   Join mov_Proposta_Frete_Carga Pfc On Pfc.IdProposta_Frete_Carga = Ofr2.IdProposta_Frete_Carga 
   Where Ofr2.IdOferta_Frete = @IdOferta_Frete) As Valor_Mercadoria,
   
  (Select Top 1 Pfc.Importancia_Segurada 
   From mov_Oferta_Frete Ofr2 
   Join mov_Proposta_Frete_Carga Pfc On Pfc.IdProposta_Frete_Carga = Ofr2.IdProposta_Frete_Carga 
   Where Ofr2.IdOferta_Frete = @IdOferta_Frete) As Importancia_Segurada,

  -- CÁLCULO DO TOTAL (Soma das Moedas)
  Stuff(Cast((
    Select ' + ' + Tmd.Moeda_Recebimento + ' ' + Format(Tmd.Valor, 'N', 'pt-br') 
    From (
        Select
            Ttx.IdOferta_Frete,
            Ttx.Moeda as Moeda_Recebimento,
            Sum(Ttx.Valor) As Valor
        From
        (
            -- PARTE 1: TAXAS DO RELATÓRIO (Cópia exata da lógica do relatório)
            Select
                Ofr.IdOferta_Frete,
                Mrc.Sigla as Moeda,
                Oft.Valor_Recebimento_Total as Valor,
                Tlg.IdTaxa_Logistica -- Guardamos o ID para saber se o seguro já veio daqui
            From
                mov_Oferta_Frete Ofr
            Join
                mov_Oferta_Frete_Taxa Oft On Oft.IdOferta_Frete = Ofr.IdOferta_Frete /* Taxas da Oferta */
                Or ((Oft.IdProposta_Frete = Ofr.IdProposta_Frete) /* Taxas da Proposta */
                  And (Oft.IdProposta_Frete_Carga = Ofr.IdProposta_Frete_Carga)
                  And (Oft.IdCompanhia_Transporte = Ofr.IdCompanhia_Transporte Or Oft.IdCompanhia_Transporte Is NULL)
                  And (Oft.Modalidade_Processo = Ofr.Modalidade_Processo)
                  And (Oft.Tipo_Operacao = Ofr.Tipo_Operacao)
                  And ((Oft.Origem_Taxa = 2 /* Origem */ And Oft.IdOrigem_Destino = Ofr.IdOrigem)
                    Or (Oft.Origem_Taxa = 3 /* Destino */ And Oft.IdOrigem_Destino = Ofr.IdDestino)
                    Or (Oft.Origem_Taxa = 1 /* Frete */)))
            Join
                cad_Taxa_Logistica_Exibicao Tle On Tle.IdTaxa_Logistica_Exibicao = Oft.IdTaxa_Logistica_Exibicao
            Join
                cad_Taxa_Logistica Tlg on Tlg.IdTaxa_Logistica = Tle.IdTaxa_Logistica
            Left Outer Join
                cad_Moeda Mrc On Mrc.IdMoeda = Oft.IdMoeda_Recebimento
            Where
                Oft.Exibir_Cliente = 1
            and
                Oft.Escalonar = 0 -- Filtro importante que estava faltando
            and
                Ofr.IdOferta_Frete = @IdOferta_Frete
            
            UNION ALL
            
            -- PARTE 2: SEGURO CALCULADO (Apenas se NÃO veio na Parte 1)
            Select 
                Ofr.IdOferta_Frete,
                Msg.Sigla as Moeda,
                CASE 
                    WHEN ((COALESCE(Pfc.Importancia_Segurada,1) * Pfc.Percentual_Seguro) / 100) < 50 
                    THEN 50
                    ELSE ((Pfc.Importancia_Segurada * Pfc.Percentual_Seguro) / 100)
                END AS Valor,
                26 as IdTaxa_Logistica
            From
                mov_Oferta_Frete Ofr
            Left outer Join
                mov_Proposta_Frete_Carga Pfc On Pfc.IdProposta_Frete_Carga = Ofr.IdProposta_Frete_Carga
            Left Outer Join
                cad_Moeda Msg On Msg.IdMoeda = Pfc.IdMoeda_Mercadoria
            Where
                Ofr.IdOferta_Frete = @IdOferta_Frete
            -- O PULO DO GATO: Só adiciona esse cálculo se NÃO existir Taxa 26 na lógica do relatório acima
            AND NOT EXISTS (
                Select 1 
                From mov_Oferta_Frete_Taxa Oft2
                Join cad_Taxa_Logistica_Exibicao Tle2 On Tle2.IdTaxa_Logistica_Exibicao = Oft2.IdTaxa_Logistica_Exibicao
                Join cad_Taxa_Logistica Tlg2 On Tlg2.IdTaxa_Logistica = Tle2.IdTaxa_Logistica
                Where 
                   (Oft2.IdOferta_Frete = Ofr.IdOferta_Frete 
                    Or ((Oft2.IdProposta_Frete = Ofr.IdProposta_Frete) 
                      And (Oft2.IdProposta_Frete_Carga = Ofr.IdProposta_Frete_Carga)
                      And (Oft2.IdCompanhia_Transporte = Ofr.IdCompanhia_Transporte Or Oft2.IdCompanhia_Transporte Is NULL)
                      And (Oft2.Modalidade_Processo = Ofr.Modalidade_Processo)
                      And (Oft2.Tipo_Operacao = Ofr.Tipo_Operacao)
                      And ((Oft2.Origem_Taxa = 2 And Oft2.IdOrigem_Destino = Ofr.IdOrigem)
                        Or (Oft2.Origem_Taxa = 3 And Oft2.IdOrigem_Destino = Ofr.IdDestino)
                        Or (Oft2.Origem_Taxa = 1))))
                   AND Oft2.Exibir_Cliente = 1
                   AND Oft2.Escalonar = 0
                   AND Tlg2.IdTaxa_Logistica = 26 -- ID do Seguro
            )
        ) As Ttx
        Group By
            Ttx.IdOferta_Frete,
            Ttx.Moeda
    ) As Tmd 
    For Xml Path, Type).query('data(.)') As VarChar(Max)
  ), 1, 2, '') As Total_Moeda