Declare @IdOferta_Frete bigint
Set @IdOferta_Frete = 9346
Select 
    'Conferência Seguro' as Etapa,
    Pfc.Importancia_Segurada,
    Pfc.Percentual_Seguro,
 
    ((COALESCE(Pfc.Importancia_Segurada,1) * Pfc.Percentual_Seguro) / 100) as Valor_Da_Conta,
  
    CASE 
        WHEN ((COALESCE(Pfc.Importancia_Segurada,1) * Pfc.Percentual_Seguro) / 100) < 50 THEN 'SIM (Deu menor que 50)' 
        ELSE 'NÃO (Deu maior que 50)' 
    END as Eh_Menor_Que_50,
   
    CASE 
        WHEN ((COALESCE(Pfc.Importancia_Segurada,1) * Pfc.Percentual_Seguro) / 100) < 50 THEN 50
        ELSE ((Pfc.Importancia_Segurada * Pfc.Percentual_Seguro) / 100)
    END AS Valor_Final_Utilizado
From
    mov_Oferta_Frete Ofr
Left outer Join
    mov_Proposta_Frete_Carga Pfc On Pfc.IdProposta_Frete_Carga = Ofr.IdProposta_Frete_Carga
Where
    Ofr.IdOferta_Frete = @IdOferta_Frete







<DataSet><Parameters><Item Name="IdOferta_Frete" Type="ftInteger" Size="0"/></Parameters><CommandText>Declare
@IdOferta_Frete IdLongo
Set @IdOferta_Frete = :IdOferta_Fret
Select
  @IdOferta_Frete As IdOferta_Frete,
  Stuff(Cast((Select ' + ' + Tmd.Moeda_Recebimento + ' ' + Format(Tmd.Valor, 'N', 'pt-br') From (Select
    Ttx.IdOferta_Frete,
    Ttx.Moeda as Moeda_Recebimento,
    CASE WHEN sum(Ttx.Valor) &gt; 50 THEN sum(Ttx.Valor) ELSE 50 END As Valor    
  From
    (Select
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
        Oft.Valor_Recebimento_Total  &lt;&gt; 0
      and
        Ofr.IdOferta_Frete = @IdOferta_Frete
      
      Union All
      
      Select 
        Ofr.IdOferta_Frete,
        Msg.Sigla as Moeda_Recebimento,
        CASE 
            WHEN ((COALESCE(Pfc.Importancia_Segurada,1) * Pfc.Percentual_Seguro) / 100) &lt; 50 
                THEN 50
            ELSE ((Pfc.Importancia_Segurada * Pfc.Percentual_Seguro) / 100)
        END AS Valor  
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






Select
  Ofr.IdOferta_frete,
  Ofr.IdProposta_Frete,
  Cast(0 as int) as Zero_Param,
  Ofr.Numero_Oferta,
  case 
    When Ofr.Tipo_Operacao = 1 and Ofr.Modalidade_Processo = 1 Then 'Exportação Aerea'
    When Ofr.Tipo_Operacao = 1 and Ofr.Modalidade_Processo = 2 Then 'Exportação Maritima'
    When Ofr.Tipo_Operacao = 1 and Ofr.Modalidade_Processo = 3 Then 'Exportação Rodoviária'
    When Ofr.Tipo_Operacao = 2 and Ofr.Modalidade_Processo = 1 Then 'Importação Aerea'
    When Ofr.Tipo_Operacao = 2 and Ofr.Modalidade_Processo = 2 Then 'Importação Maritima'
    When Ofr.Tipo_Operacao = 2 and Ofr.Modalidade_Processo = 3 Then 'Importação Rodoviária'
    When Ofr.Tipo_Operacao = 2 and Ofr.Modalidade_Processo = 4 Then 'Air-Air'
    When Ofr.Tipo_Operacao = 2 and Ofr.Modalidade_Processo = 5 Then 'Sea-Air'
    When Ofr.Tipo_Operacao = 3 and Ofr.MOdalidade_Processo = 1 Then 'Nacional Aereo'
    When Ofr.Tipo_Operacao = 3 and Ofr.Modalidade_Processo = 2 Then 'Nacional Maritimo(Cabotagem)'
    When Ofr.Tipo_Operacao = 3 and Ofr.Modalidade_Processo = 3 Then 'Nacional Rodoviário'
  end as Tipo_modalidade,
  Ofr.Tipo_Servico,
  Ofr.Tipo_Servico_aereo,
  Ofr.Local_Entrega,
  Ofr.Local_Coleta,
  Ofr.Modalidade_Pagamento_Master,
  Ofr.Modalidade_Pagamento_House,
  Ofr.Transit_Time,
  case
    WHEN Ofr.Tipo_Rota = 1 THEN 'Não informado'
    WHEN Ofr.Tipo_Rota = 2 THEN 'Direto'
    WHEN Ofr.Tipo_Rota = 3 THEN 'Transbordo / Escala' 
end as Tipo_Rota,
  Ofr.Transit_Time_Maximo,
  Ofr.Detalhes,
  Ofr.Tipo_Rota,
  Ofr.Data_Validade,
  FORMAT(Ofr.Data_Validade,'dd-MMMM-yyyy','en-US') as Valid_Date,
  Ofr.Validade_Dias,
  Ofr.Rota,
  Ofr.Referencia_Cliente,
  Ofr.Observacao,
  Ept.Nome as Exportador,
  Imp.Nome as Importador,
  Vnd.Nome as Vendedor,
  Vnd.Detalhes as Vendedor_Detalhes,
  Pfr.Numero_Proposta,
  Pfr.Data_Proposta,
  Pfr.Data_Aprovacao,
  Pfr.IdCliente,
  Cli.Nome as Cliente,
  Cli.Detalhes as Detalhes_Cliente,
  Ccl.Nome as Cliente_Contato,
  Dsp.Nome as Despachante,
  Cia.Nome as Cia_Transporte,
  Inc.Nome as Incoterm,
  Dsf.Nome as Destino_Final,
  Org.Nome as Origem,
  Org.Sigla as Origem_Sigla,
  Dst.Nome as Destino,
  Dst.Sigla as Destino_Sigla,
  case 
    When Ofr.Modalidade_Processo = 1 Then Coalesce(Org.Sigla,'')+'- '+ Org.Nome
    When Ofr.Modalidade_Processo = 2 Then Org.Nome
  end as Origem_Sigla_Nome,
  case 
    When Ofr.Modalidade_Processo = 1 Then Coalesce(Dst.Sigla,'')+'- '+ Dst.Nome
    When Ofr.Modalidade_Processo = 2 Then Dst.Nome
  end as Destino_Sigla_Nome,
  Pfc.Peso_Liquido,
  Pfc.Peso_Bruto,
  Pfc.Peso_Cubado,
  Pfc.Peso_Considerado,
  Pfc.Peso_Taxado,
  Pfc.Quantidade_Volumes,
  Pfc.Metros_Cubicos,
  Pfc.Tipo_Carga,
  Pfc.IdMoeda_Mercadoria,
  Mmr.Sigla As Moeda_Mercadoria,
  Pfc.Valor_Mercadoria,
  Pfc.Importancia_Segurada,
  Pfc.Percentual_Seguro,
  Mer.Nome as Mercadoria,
  Fvg.Descricao as Frequencia,
  Case
    When Emp.IdPessoa = 44488 Then 911
  End as IdLogo_Empresa,
  Fcn.Nome As Funcionario_Logado,
  Fcn.Detalhes AS Func_Logado_Detalhes,
  Us.Nome As Usuario_Logado,
  Ofr.Instrucoes_Cliente,
  Ofr.Instrucoes_Operacional,
  case
    When Ofr.Modalidade_Processo = 1 Then Ago.Correspondencia
    When Ofr.Modalidade_Processo = 2 Then Agd.Correspondencia
  End As Agente_Correspondencia,
  Ago.Correspondencia As Agente_Origem_Correspondencia,
  Agd.Correspondencia As Agente_Destino_Correspondencia,
  --COALESCE(Vms.Valor_Real4,35.00) As Valor_Minimo_Seguro,
  --Ttc.Valor_Alfanumerico AS Transit_Time_Coleta,
  --Ttn.Valor_Alfanumerico AS Transit_Time_Nacional,
   Pfc.Importancia_Segurada * Pfc.Percentual_Seguro / 100 As TOTAL_SEGURO,
  COALESCE(Pfb.Qtd_Embalagem,0) as Qtd_Embalagem,
  tmc.Nome as Terminal_Desova,
  Ofr.Tipo_Operacao
From
  mov_Oferta_Frete Ofr 
Left Outer Join
  cad_Origem_Destino Org on Org.IdOrigem_Destino = Ofr.IdOrigem
Left Outer Join
  cad_Origem_Destino Dst on Dst.IdOrigem_Destino = Ofr.IdDestino
Left Outer Join
  cad_Origem_Destino Dsf on Dsf.IdOrigem_Destino = Ofr.IdDestino_Final
Left Outer Join
  cad_Pessoa Ept on Ept.IdPessoa = Ofr.IdExportador
Left Outer Join
  cad_Pessoa Imp on Imp.IdPessoa = Ofr.IdImportador
Left Outer Join
  cad_Pessoa Ago on Ago.IdPessoa = Ofr.IdAgente_Origem
Left Outer Join 
  cad_Pessoa Agd on Agd.IdPessoa = Ofr.IdAgente_Destino
Left Outer Join
  cad_Pessoa Cia on Cia.IdPessoa = Ofr.IdCompanhia_Transporte
Left Outer Join
  cad_Incoterm Inc on Inc.IdIncoterm = Ofr.IdIncoterm
Left Outer Join
  mov_Proposta_Frete Pfr on Pfr.IdProposta_Frete = Ofr.IdProposta_Frete
Left Outer Join
  cad_Empresa Eps on Eps.IdEmpresa_Sistema = Pfr.IdEmpresa_Sistema
Left Outer Join
  cad_Pessoa Emp on Emp.IdPessoa = Eps.IdPessoa
Left Outer Join
  cad_Pessoa Vnd on Vnd.IdPessoa = Pfr.IdVendedor
Left Outer Join
  cad_Pessoa Cli on Cli.IdPessoa = Pfr.IdCliente
Left Outer join
  cad_Pessoa_Contato Ccl on Ccl.IdPessoa_Contato = Pfr.IdCliente_Contato
Left Outer Join
  cad_Pessoa Dsp on Dsp.IdPessoa = Ofr.IdDespachante_Aduaneiro
Left Outer Join
  mov_Proposta_Frete_Carga Pfc on Pfc.IdProposta_Frete_Carga = Ofr.IdProposta_Frete_Carga
LEFT OUTER JOIN vis_Terminal_Container tmc ON tmc.IdPessoa = ofr.IdTerminal_Retirada_Redestinar
LEFT OUTER JOIN (
  SELECT
    Pfb.IdProposta_Frete_Carga,
    COUNT(Pfb.Quantidade) as Qtd_Embalagem
  FROM
    mov_Proposta_Frete_Embalagem Pfb
  GROUP BY
    Pfb.IdProposta_Frete_Carga
  ) Pfb ON Pfb.IdProposta_Frete_Carga = Pfc.IdProposta_Frete_Carga
Left Outer Join
  cad_Mercadoria Mer on Mer.IdMercadoria = Pfc.IdMercadoria
Left Outer Join
  cad_Frequencia_Viagem Fvg on Fvg.IdFrequencia_Viagem = Ofr.IdFrequencia_Viagem
Left Outer Join
   cad_Moeda Mmr on Mmr.IdMoeda =  Pfc.IdMoeda_Mercadoria
Left Outer Join
  #Global_Var Gvr on Gvr.Variavel Like 'IdUsuario'
Left Outer Join
  vis_Funcionario Fcn on Fcn.IdUsuario_Correspondente = Gvr.Valor
Left Outer Join
  Sys_Usuario Us on Us.IdUsuario = Gvr.Valor
Where
  Ofr.IdOferta_Frete = 9346
