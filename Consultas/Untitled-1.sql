<DataSet><Parameters><Item Name="IdOferta_Frete" Type="ftInteger" Size="0"/></Parameters><CommandText>Declare
  @IdOferta_Frete IdLongo
  
Set @IdOferta_Frete = :IdOferta_Frete

Select
  @IdOferta_Frete As IdOferta_Frete,
  
  (Select Top 1 Pfc.Valor_Mercadoria 
   From mov_Oferta_Frete Ofr2 
   Join mov_Proposta_Frete_Carga Pfc On Pfc.IdProposta_Frete_Carga = Ofr2.IdProposta_Frete_Carga 
   Where Ofr2.IdOferta_Frete = @IdOferta_Frete) As Valor_Mercadoria,
   
  (Select Top 1 Pfc.Importancia_Segurada 
   From mov_Oferta_Frete Ofr2 
   Join mov_Proposta_Frete_Carga Pfc On Pfc.IdProposta_Frete_Carga = Ofr2.IdProposta_Frete_Carga 
   Where Ofr2.IdOferta_Frete = @IdOferta_Frete) As Importancia_Segurada,
  Stuff(Cast((Select ' + ' + Tmd.Moeda_Recebimento + ' ' + Format(Tmd.Valor, 'N', 'pt-br') From (Select
    Ttx.IdOferta_Frete,
    Ttx.Moeda as Moeda_Recebimento,

    CASE WHEN sum(Ttx.Valor) &gt; 50 THEN sum(Ttx.Valor) ELSE 50 END As Valor
  From
    (

      Select
        Ofr.IdOferta_Frete,
        Mrc.Sigla as Moeda,
        Oft.Valor_Recebimento_Total As Valor
      From
        mov_Oferta_Frete Ofr
      Join
        mov_Oferta_Frete_Taxa Oft On Oft.IdOferta_Frete = Ofr.IdOferta_Frete
          Or ((Oft.IdProposta_Frete = Ofr.IdProposta_Frete)
          And (Oft.IdProposta_Frete_Carga = Ofr.IdProposta_Frete_Carga)
          And (Oft.IdCompanhia_Transporte = Ofr.IdCompanhia_Transporte Or Oft.IdCompanhia_Transporte Is NULL)
          And (Oft.Modalidade_Processo = Ofr.Modalidade_Processo)
          And (Oft.Tipo_Operacao = Ofr.Tipo_Operacao)
          And ((Oft.Origem_Taxa = 2 And Oft.IdOrigem_Destino = Ofr.IdOrigem)
            Or (Oft.Origem_Taxa = 3 And Oft.IdOrigem_Destino = Ofr.IdDestino)
            Or (Oft.Origem_Taxa = 1)))
      Join
        cad_Taxa_Logistica_Exibicao Tle On Tle.IdTaxa_Logistica_Exibicao = Oft.IdTaxa_Logistica_Exibicao
      Left Outer Join
        cad_Moeda Mrc On Mrc.IdMoeda = Oft.IdMoeda_Recebimento
      Left Outer Join
        mov_Proposta_Frete Pfr on Pfr.IdProposta_Frete = Ofr.IdProposta_Frete
      Where
        Oft.Exibir_Cliente = 1
      and
        Oft.Valor_Recebimento_Total &lt;&gt; 0
      and
        Ofr.IdOferta_Frete = @IdOferta_Frete
      
      Union All
      
 
      Select 
        Ofr.IdOferta_Frete,
        Msg.Sigla as Moeda_Recebimento,
        COALESCE(
           
            (Select Top 1 Oft_Seg.Valor_Recebimento_Total 
             From mov_Oferta_Frete_Taxa Oft_Seg 
             Join cad_Taxa_Logistica_Exibicao Tle_Seg On Tle_Seg.IdTaxa_Logistica_Exibicao = Oft_Seg.IdTaxa_Logistica_Exibicao 
             Where Oft_Seg.IdOferta_Frete = Ofr.IdOferta_Frete 
             And Tle_Seg.IdTaxa_Logistica = 26), 
            
            CASE 
                WHEN ((COALESCE(Pfc.Importancia_Segurada,1) * Pfc.Percentual_Seguro) / 100) &lt; 50 
                THEN 50
                ELSE ((Pfc.Importancia_Segurada * Pfc.Percentual_Seguro) / 100)
            END
        ) AS Valor  
      From
        mov_Oferta_Frete Ofr
      Left outer Join
        mov_Proposta_Frete_Carga Pfc On Pfc.IdProposta_Frete_Carga = Ofr.IdProposta_Frete_Carga
      Left Outer Join
        cad_Moeda Msg On Msg.IdMoeda = Pfc.IdMoeda_Mercadoria
      Where
        Ofr.IdOferta_Frete = @IdOferta_Frete
    ) As Ttx
  Group By
    Ttx.IdOferta_Frete,
    Ttx.Moeda) As Tmd For Xml Path, Type).query('data(.)') As VarChar(Max)), 1, 2, '') As Total_Moeda</CommandText></DataSet>