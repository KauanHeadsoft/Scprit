Senha homologação smx: SenhaSenhaSenha1!

IdForma_Pagamento	8
idpessoa_recebimento


IM0696-25


TAREFA: Acompanhar coleta da carga

MODELO DE MENSAGEM: OPE - IM - COLETA

312

cad_Modelo_Mensagem
IdModelo_Mensagem

FSTIM0816-25

## Ethima
Fechamaneto mensal V1

## Tex
idlogistica_house 1461
mov_Logistica_House
instrucoes_operacional


## Exalog
mov_Logistica_House 
Numero_Reserva
-
mov_Logistica_House
instrucoes_operacional
instrucoes_financeiro -
instrucoes_cliente
instrucoes_agente -
instrucoes_operacional_cliente

PROJETO 2019 - AVISO ABERTURA DE PROCESSO IM - OK

## RAF

## Affinty
AG015217


## Boss Wood
PO#00045P-DO


## CARPO
PF006566/25 - NM0151-25
ATIVIDADE: ABERTURA DE PROCESSO - MODELO DE MENSAGEM: OPE - EM - AVISO DE ABERTURA DE PROCESSO

#45300
PF006679/25-02
Relatorio: OFERTA - MARÍTIMA



## TEX #45213
IM0732-25 Pancaldi
mov_registro_financeiro - IdRegistro_Financeiro 
mov_logistica_fatura - IdRegistro_Financeiro  - IdLogistica_Master - Conferido_Operacional
FCL (Tipo carga).
TLogisticaMaster

## AGL
AGLIM4022-25



## Quality Log
Modelo de mensagem: NOVO PROJETO 2024 - IA FOLLOW UP - ATV 7.0
Tarefa: Follow-up: Confirmação de Chegada (Air)
TLogisticaViagem = 5


## CSS SPO 
CSS6643525



## TEX
Taxas > FRETE MARÍTIMO FCL > Recebimento > Valor total 'Valor total de frete'
mov_Logistica_Taxa
IdLogistica_Taxa = 1
Valor_Recebimento_Total


## VOX #44983

Comercial -> Informações ->
mov_Oferta_Frete Oft - mov_Oferta_Frete_Taxa Lft
IdOferta_Frete



Oft.Modalidade_Pagamento_Master <> Lft.Modalidade_Pagamento
Oft.Modalidade_Pagamento_House <> Lft.Modalidade_Recebimento



## UTILE #45360
FSTIM1205-25

## CAPITAL MAO
Relatorio:
NOVA FATURA S/ RETENÇÃO DE IMPOSTOS
MBL - MAWB - controle_viagem    - master: COP0296358
HBL - HAWB - conhecimento_viagem     - house im0739-25



## FAM #45398 
cad_Pessoa:
Ativo '1' sim
Codigo
cpf_cnpj
Data_criacao
Nome
Nome_Fantasia
Rg_Inscricao_Estadual
Tipo 'case' 
Tipo_Pessoa 'case'
Pes.Data_Alteração

agencia bancaria
agencia maritima aerea
agente de cargaagente descolidador
associacao internacional
companhia de transporte
despachante aduaneiro
empresa
fabricante
fornecedor
nvocc
representante/colaborador
seguradora
terminal de conteiner
transportadora


## SMX #45271
CORREÇÃO - NUMERO DO PROCESSO - BOOKING
SMXEM024482
Campo livre
Correção BL 1
BL_1_data_s: 497
BL_1_d_c: 498


## SMX #45330
Atividade para processos onde MBL é EBL
SMXIM042755
Tarefa:Confirmar chegada do courier   - IM
Responsavel: SILAS MAIA
Id.configuração campo livre= 40


## TEX #45383
Relatorio
NOVO_OFERTA_COMERCIAL_OPERACIONAL
IM023381
TABELA OFERTA IMPORTAÇÃO MARÍTIMA LAYOUT NOVO SEM HEADER (1)

Restante taxas gerais - taxa
topdez taxas gerais - taxa


## Ebony Logistic #45382
apenas as taxas de frete, componentes de frete, taxas de origem e DTHC fossem mencionadas na SI
Relatorio: SHIPPING INSTRUCTION
Taxa_Processo_House - Nome_Internacional


## NAVCOM #45456
NAV1723/25

'Solicitação de Draft para o agente' (4) gerar ao concluir o 'Envio de SI (Shipping Instruction) ao agente' (1)
e não ser gerada pelo 'Envio da prontidão e dados do embarque' (3)





## AGL #45079 / #45079
Comercial
035804/25
FCL = Equipamento
LCL = Quantidade


## Exalog #45090
Relatorio S-Freight 
ABW COMPLETO - exemplo para capa e contra capa

air_waybill_novo - agent_iata_code

EXALOG ASSESSORIA E LOGISTICA LTDA
CNPJ: 23.659.517/0001-92
AV. SENADOR FEIJÓ, 686 - LOJA TP-B2 - 1412 - VILA MATHIAS
11015-504
SANTOS - SP 

EXALOG ASSESSORIA E LOGISTICA LTDA
CNPJ: 23.659.517/0001-92
AV. ANA COSTA, 228 - 7º ANDAR - SALA 71
BAIRRO: VILA MATIAS - SANTOS / SP CEP : 11060-000
FONE : +55 13 - 3222-6230
E-MAIL: bruno.schomer@exalog.com.br
-------------------------##---------------------------##----------------------


## SMX #45154


Modalidade_Processo
1 Aéreo
2 Marítimo 
3 Terrestre

Tipo_Operacao
1 Exportação 
2 Importação
3 Nacional



## EXALOG #45502

mov_Proposta_Frete_Carga
Valor_Mercadoria

OF0000405/25 - 3 - pancaldi



## INTERTRANS
Papel= BLC_OPERACIONAL_N_PODE_SER_DIFERENTE_COMERCIAL



## AGL #45519
Frete Compra  = Pagamento
Frete Venda = Recebimento
Peso taxado 'mov_Logistica_Aerea_House'  'mov_Logistica_House' 'IdLogistica_House'
Número do MAWB 'mov_Logistica_Master''Numero_Conhecimento'
Cia. aérea 'mov_Logistica_Viagem' 'IdCompanhia_Transporte' - 'mov_Logistica_Master' 'IdCompanhia_Transporte'
RELATÓRIO CONSOLIDADA
IdTaxa_Logistica_Exibicao = 4 'FRETE AEREO' 



## NEWEST LOG #45146
EM0807-25
DETE0039-25 - 6896
Relatório FATURA DE RECEBIMENTO - NEWEST - SAF -  INGLÊS   - ajustado!

DETE0026-25


## TEX #44788
-- 1. Liga a tabela Master na tabela específica de Agência
LEFT OUTER JOIN cad_Agencia_Maritima_Aerea Ama ON Ama.IdPessoa = Lms.IdAgencia_Maritima_Aerea
-- 2. Liga a tabela de Agência na tabela de Pessoa para pegar o Nome
LEFT OUTER JOIN cad_Pessoa PsaAgencia ON PsaAgencia.IdPessoa = Ama.IdPessoa



## CARPO #45524
EM0668-25
Solicitação de Invoice ao cliente
Recebimento do Green light
COMMERCIAL INVOICE 012 2025.doc
FATURA CLIENTE

INVOICE AGENTE 

265

TProjetoAtividadeArquivo: Concluída ao anexar arquivo no grupo de arquivos '3 /* INVOICE AGENTE */'
TProjetoAtividadeArquivo: Concluída ao anexar arquivo no grupo de arquivos '1 /* FATURA CLIENTE */'


## KPM #45673 *Cancelado*


## NSL #45652

Versão 2.0.38.107 - Painel de controle
Verrsão 3.0288.1 - Restante



 ## VOX   #45674

EMVOX251100             
Processo > House > BL's > Additional > Place inssue 

tab
mov_Bill_Lading > Place_Issue
PK IdConhecimento_Embarque

tab
mov_Logistica_Viagem 
Tipo_Viagem = 4 /*embarque inicial*/
IdOrigem

tab
cad_Origem_Destino
IdOrigem_Destino



## SMX  #45437 #45472 #45813

IM

'FATURAR PROCESSO' - essa atividade precisa ser gerada na atracação 
'Confirmar atracação do navio' -  atividade que gera 'FATURAR PROCESSO'
IdTarefa = 1679 atividade 1, a atividade dois precisa verificar se a atividade 1 já existe se já existe ela não gera.

MAIARA DA SILVA = ATV1 = IdTarefa = 1389
GABRIELA TILIMANN DOURADO = ATV2 = IdTarefa = 1114

IdProjeto_Tarefa_Monitor 1733 e 1732

SMX - FATURAR PROCESSO

IdAtividade = 10670175
IdProjeto_Atividade =588873 
ATV2 gerada 16-01-26 as 9:50h - rayane.lima
<Campos>
  <Campo Nome="IdAtividade" Value="10670175" />
  <Campo Nome="IdProjeto_Atividade" Value="588873" />
  <Campo Nome="IdTarefa" Value="1114" />
  <Campo Nome="IdEtapa_Atividade" Value="1497057" />
  <Campo Nome="IdResponsavel" Value="108184" />
  <Campo Nome="IdResponsavel_Original" Value="108184" />
  <Campo Nome="Previsao_Inicio" Value="1/13/2026" />
  <Campo Nome="Previsao_Termino" Value="1/13/2026 2:30:00 PM" />
  <Campo Nome="Situacao" Value="4" />
  <Campo Nome="Prioridade" Value="0" />
  <Campo Nome="Mensagem_Automatica" Value="0" />
  <Campo Nome="Acompanhamento_Automatico" Value="0" />
  <Campo Nome="Observacao" Value="" />
</Campos>



IdAtividade = 10587735
IdProjeto_Atividade = 588873
ATV1 gerada 10-12-25 as 11:51h - william.vargas
<Campos>
  <Campo Nome="IdAtividade" Value="10587735" />
  <Campo Nome="IdProjeto_Atividade" Value="588873" />
  <Campo Nome="IdTarefa" Value="1389" />
  <Campo Nome="IdEtapa_Atividade" Value="1481394" />
  <Campo Nome="IdResponsavel" Value="111260" />
  <Campo Nome="IdResponsavel_Original" Value="111260" />
  <Campo Nome="Previsao_Inicio" Value="12/10/2025 11:51:56 AM" />
  <Campo Nome="Previsao_Termino" Value="12/10/2025 2:30:00 PM" />
  <Campo Nome="Situacao" Value="1" />
  <Campo Nome="Prioridade" Value="0" />
  <Campo Nome="Mensagem_Automatica" Value="0" />
  <Campo Nome="Acompanhamento_Automatico" Value="0" />
  <Campo Nome="Observacao" Value="" />
</Campos>


IdLogistica_Master= 112204
Campos embarque preenchidas dia 10-12-25 as 11:50 -william.vargas
<Campos>
  <Campo Nome="IdLogistica_Master" Value="112204" />
  <Campo Nome="Data_Previsao_Embarque" Value="12/31/2025" />
  <Campo Nome="Data_Previsao_Desembarque" Value="1/30/2026" />
</Campos>



## Erros
/*
EVENTOS
1 - Ao inserir
2 - Ao editar
3 - Ao excluir
4 - Ao confirmar inserção
5 - Ao confirmar edição

AÇÔES
1 - Permitir
2 - Exibir aviso
3 - Solicitar confirmação
4 - Senha
5 - Bloquear
*/

SET NOCOUNT ON

Declare
  @IdUsuario IdCurto,
  @IdBloqueio_Condicional_List VarChar(Max),
  @Parametros Xml

Set @IdUsuario = ?
Set @IdBloqueio_Condicional_List = ?
Set @Parametros = ?

Declare
  @Classe AlfaNumericoLongo,
  @Evento TipoFixo,
  @IgnorarSegurancaCount InteiroCurto,
  @CommandText nVarChar(Max)

Select
  @Classe = Prm.value('@Classe', 'VarChar(Max)'),
  @IgnorarSegurancaCount = Prm.value('@IgnorarSegurancaCount', 'smallint'),
  @Evento = Prm.value('@Tipo', 'int')
From
  @Parametros.nodes('/Parametros/Evento') as Parametros(Prm)

Declare Bloqueio Cursor For
Select
  Bcn.IdBloqueio_Condicional,
  Bcn.Ao_Inserir,
  Bcn.Ao_Editar,
  Bcn.Ao_Excluir,
  Bcn.Ao_Confirmar_Edicao,
  Bcn.Ao_Confirmar_Insercao,
  Bcn.Dados_Registro
From
  string_split(@IdBloqueio_Condicional_List, ',') prm
Join
  cad_Bloqueio_Condicional Bcn on Bcn.IdBloqueio_Condicional = prm.value
Where
  (Bcn.Classe Like @Classe)
    And (Bcn.Bloqueio_Ativo = 1)
    And (((@Evento = 1) and (Bcn.Ao_Inserir = 1))
      or ((@Evento = 2) and (Bcn.Ao_Editar = 1))
      or ((@Evento = 3) and (Bcn.Ao_Excluir = 1))
      or ((@Evento = 4) and (Bcn.Ao_Confirmar_Insercao = 1))
      or ((@Evento = 5) and (Bcn.Ao_Confirmar_Edicao = 1)))
  
Open Bloqueio

Declare
  @IdBloqueio_Condicional IdCurto,
  @Ao_Inserir Boleano,
  @Ao_Editar Boleano,
  @Ao_Excluir Boleano,
  @Ao_Confirmar_Edicao Boleano,
  @Ao_Confirmar_Insercao Boleano,
  @Dados_Registro Xml,
  @Acao TipoFixo,
  @Mensagem VarChar(Max),
  @Prioridade InteiroMicro,
  @IgnorarSegurancaAoConfirmar Bit

Fetch Next From Bloqueio Into
  @IdBloqueio_Condicional,
  @Ao_Inserir,
  @Ao_Editar,
  @Ao_Excluir,
  @Ao_Confirmar_Insercao,
  @Ao_Confirmar_Edicao,
  @Dados_Registro

Declare @Acoes Table (
  IdBloqueio_Condicional IdCurto,
  Acao TipoFixo,
  Mensagem VarChar(Max),
  Prioridade InteiroMicro,
  IgnorarSegurancaCount InteiroMicro
)

While @@FETCH_STATUS = 0
Begin
  Select
    @Acao = 0,
    @Mensagem = NULL,
    @Prioridade = 0,
    @IgnorarSegurancaAoConfirmar = 1

  Set @CommandText = @Dados_Registro.value('(Dados_Registro/CommandText)[1]', 'nVarChar(Max)')

  If NullIf(LTrim(@CommandText), '') Is Not Null
    exec sp_executesql @CommandText, N'@Parametros Xml, @Evento TipoFixo, @IgnorarSegurancaCount InteiroCurto OUTPUT, @IgnorarSegurancaAoConfirmar Bit OUTPUT, @Acao TipoFixo OUTPUT, @Mensagem VarChar(Max) OUTPUT, @Prioridade InteiroMicro OUTPUT',
      @Parametros=@Parametros, @Evento=@Evento, @IgnorarSegurancaCount=@IgnorarSegurancaCount OUTPUT, @IgnorarSegurancaAoConfirmar=@IgnorarSegurancaAoConfirmar OUTPUT, @Acao=@Acao OUTPUT, @Mensagem=@Mensagem OUTPUT, @Prioridade=@Prioridade OUTPUT

  If (@Evento in (4 /* Ao confirmar inserção */, 5 /* Ao confirmar edição */) And @IgnorarSegurancaAoConfirmar = 1)
    Set @IgnorarSegurancaCount = 0

  If (@Acao <> 0) And (@IgnorarSegurancaCount = 0)
    Insert Into @Acoes (IdBloqueio_Condicional, Acao, Mensagem, Prioridade, IgnorarSegurancaCount) Values (@IdBloqueio_Condicional, @Acao, @Mensagem, @Prioridade, @IgnorarSegurancaCount)

  Fetch Next From Bloqueio Into
    @IdBloqueio_Condicional,
    @Ao_Inserir,
    @Ao_Editar,
    @Ao_Excluir,
    @Ao_Confirmar_Insercao,
    @Ao_Confirmar_Edicao,
    @Dados_Registro
End

Close Bloqueio
Deallocate Bloqueio

SET NOCOUNT OFF

Select
  IdBloqueio_Condicional,
  Acao,
  Mensagem,
  IgnorarSegurancaCount
From
  @Acoes
Order By
  Acao Desc,
  Prioridade



## Dicas
IdProposta_Frete fica no 'Comercial' ->

Erro instalação HeadCargo -> Controle de aplicativos e do navegador -> Configurações de controle inteligente de aplicativos -> Desativar 
Firewall -> Registro de Entrada -> Nova Regra -> Programa -> HeadCargo -> Desktop 

Configuração para modulos 'Comercial' e 'Operacional' -> 'Cadastros - Logistica' 'Cadastros de contato' 'Central Mensagens'
'Consultas Logistica' 'Consultas Comerciais' 'Controle assinatura' 'Controle de atividades' 'Demurrage/Detention' 'Gerenciamento de arquivos'
'Gerenciamento de relatorios' 'Integração com sistemas' 'Integração marcante' 'Integração Tracking' 'Interface menu'
'Logistica aerea' 'Logistica internacional' 'Logistica Maritima' 'Logistica terrestre' 'Processos referentes as exportações' 'Proposta Logistica'

Cadastros - logistica - liberação de taxas Operacional

Ocorreu um erro ao tentar atualizar a atividade da tarefa de Projeto
Tarefa não encontrada [IDtarefa = ****].
- Provável que tenha um erro na atividade ou que foi excluido a atividade

Para trocar o projeto tarefa do comercial precisa ir no modulo 'Projeto tarefa - Logística' onde tem a origem projeto as modalidades e o projeto tarefa.

Erro fatura bloqueio: quando aparecer um erro no comparar operacional com a oferta e der erro, verificar se tem alguma fatura baixada, conferida ou travada, blqoeuada.

Tarefa não encontrada [IdTarefa = *****] ir no modulo tarefa procurar a tarefa que não tem projeto tarefa vinculado, verificar o ID e aplicar o projeto tarefa que ela deveria ser.

tle.Nome &lt;&gt;  'ARMAZENAGEM' OR tle.Nome IS NULL  

somar no sql (sum) SUM(Ltx.Valor_Pagamento_Unitario) OVER() as Total_Pagamento_Geral

Atualmente os campos Coleta/Entrega Origem e Coleta/Entrega Destino, estão configurados para puxar as informações dos campos livres "COLETA/ENTREGA DESTINO e COLETA/ENTREGA ORIGEM" da aba Embarque - Embarque Inicial - Prazos
Os campos são campos de Datas, não de Localidade de Origens e destinos.


Nota fiscal serviço, tracking, boletos são serviços adicionais que precisam ser contrato primeiro para depois usar, sempre passar para o comercial.

Quando não aparece nada no gerencial do usuario, verificar se ela está em uma equipe tarefa.

ROW_NUMBER() criar um indice para pegar somente o primeiro do selecionado
ROW_NUMBER() OVER (PARTITION BY Pess.Cpf_Cnpj ORDER BY Ppf.Data_Criacao ASC) as Ordem_Proposta

__________________________________________________________________________________________________________________________________


## modulos ##

Atualizar faturas - Logística = Propriedade de interface
Cadastros - Logística =  cadastros de logistica 
Cadastros de contatos = cadastro companhia de transporte
Cadastros de contatos da empresa = cadastro internos
Cadastros do financeiro =
Cadastros referentes a exportações =
Cadastros referentes aos produtos =
Central de mensagens =
Consultas - Logística =
Consultas comerciais = modulo Comercial e CRM
Consultas financeiras =
Controle assinaturas =
Controle de atividades =
Controle de cobranças =
Controle de pagamentos =
Controle financeiro =
Demurrage/Detention =
Gerenciamento de arquivos = modulo Comercial e CRM
Gerenciamento de relatórios = modulo Comercial e CRM
HeadCARGO Web - Essentials =
HeadCARGO Web - Standard =
Integração com sistemas = modulo Comercial e CRM
Integração INTTRA =
Integração mercante =
Integração Tracking =
Interface menu = modulo Comercial e CRM
Logística aérea =
Logística internacional =
Logística marítima =
Logística terrestre =
Nota fiscal de serviço =
Processos referentes as exportações =
Proposta logística = modulo Comercial e CRM
Tarifário logística =




## Wide Logistics #45639 - #45062 - #39813
Atividades 'Retornar Status ao cliente' e 'Acompanhar coleta da carga'

'Acompanhar coleta da carga' deve ser gerada quando a atividade 'Retornar Status ao cliente for concluida'


Se no mov_Logistica_House o campo Local_Coleta estiver preenchido na abertura do processo deve ser gerado como Não Iniciada
caso esteja null não fazer nada, para a atividade 'Acompanhar coleta da carga'



## Br Company #45773

pricing.teste
senha


## SMX #45782

'access violation at anddres 40005E67 in module 'rtl470.bpl'. Read of address 00000100'


## Tirrena #45562
mov_Logistica_Master
Master_Direto
Numero_Conhecimento



## ERROS ##
É obrigatório o preenchimento do campo 'Pessoa pagamento' (Outro). é porque está faltando a pessoa da taxa
É obrigatório o preenchimento do campo 'Conversão taxas pagamento'. - SK002-26  é porque está faltando a pessoa da taxa
É obrigatório o preenchimento do campo 'Condicao_Pagamento'. é porque está faltando a pessoa da taxa




Lhs.Tipo_Carga = 4
IdEquipamento_Maritimo = 26
Mensagem: “Incluir na aba carga LCL - CONSOLIDADO” com a quantidade “0”.



## Ebony #45843

Inserir nos títulos dos e-mails 'Referencia externa' e 'Referencia cliente'

mov_Logistica_House, IdLogistica_House
Referencia_Externa
Referencia_Cliente
Referencia_Interna


## CSS SPO

Criar Aviso quando destino for Fortaleza




## SMX  #45838
atividade da IM Projeto tarefa "SOLICITAR DOCS FINAIS"
não pode deixar usuario alterar a data das previsoes de inicio e termino.




## LOGMAKERS #45862

Atividade do 'IM' 'Termo de Container' não está sendo gerada
Recebimento do cliente



## Modelo de mensages ## 

  Case
  when Lms.Master_Direto = 1 THEN 'Modelo_Direto'
  Else 'Modelo_Padrao'
  End as Mensagem





## INTERTRANS #45913

Alterar campo de Master para House - Liberação de BL
Puxar informações da data de desembarque - Data de chegada  'OK'
Excluir colouna outras taxas recebimento e deixar apenas coluna outras taxas BRL


Liberacao_BL = Bill.Originais 
'Tst'
vis_Bill_Lading

Taxas removidas de recebimento:
'Tst.Taxas_USD_Recebimento,
Tst.Taxas_EUR_Recebimento,'
Tru.Taxas_USD_Recebimento,
Tre.Taxas_EUR_Recebimento,


BL's = Originals

mov_Bill_Lading
Originals 

Local_Emissao
1 Destino
2 Express release
3 Origem
4 Sea waybill
5 Outro



## TEX SHIPPING # 46029

Gerar uma atividade quando 'não aprovar' uma oferta no comercial, por um motivo específico.

Motivo: 'TARIFA / LOWER RATE WITH OTHER FFW'
Tab: cad_Motivo_Nao_Aprovacao_Proposta
Colun: IdMotivo_Nao_Aprovacao_Proposta = 27
Projeto: COMERCIAL - 2022
atv: 07.3 Oferta não aprovada por custo

tab: mov_Proposta_Frete
colun: Situacao = 3 'não aprovado'
colun: IdMotivo_Nao_Aprovacao_Proposta = 7 'base de teste'

TOfertaFrete: Concluída ao aprovar ou não aprovar oferta
ÚLTIMO TRANSBORDO/ESCALA



## SMX #45922

Criar atividade 'Atualização status processo'
Deve cair na agenda de 6 em 6 dias, somente enquanto nao tivermos a data de confirmação de 'DATA DE EMBARQUE'
Assim que tiver uma 'DATA DE EMBARUQE' concluir a atividade e deve gerar um FOLLOW - equipe responsável 'CS'
Processos finalizados e com embarque não deverão aparecer na agenda.



## SMX

Analista: Andressa Burger 'IdPessoa = 117117' - Assistente: Fernanda Scheistl 'IdPessoa =118757'

Analista: Heloisa Souza 'IdPessoa = 102466' - Assistente: Fernanda Scheistl 'IdPessoa = 118757'

Analista: Leonardo Bonsignori 'IdPessoa = 116185' - Assistente: Luisa Stallbaum 'IdPessoa =115856'

eu preciso trazer os processos que essas 3 pessoas fazem parte como analista e me trazer os processos e me dizer quem são os assistentes sem duplicar o numero dos processos
preciso saber quem são os assistentes que fazem parte do processo que tem esses analistas.

Lhs.Situacao_Agenciamento precisa ser 1,2,3,4
precisa me trazer processos que só tenham esses 4 status.



'IdPessoa = 117117'
'IdPessoa = 102466'
'IdPessoa = 116185'



Usuário sistema	Data início transação	Tabela	Tipo	Tempo transação (seg.)
kauan.headsoft	28/01/2026 11:02	mov_Projeto_Atividade_Responsavel	Atualização	3

Campo	Valor anterior	Valor atualizado
IdProjeto_Atividade_Responsavel		2385931

Campo	Valor anterior	Valor atualizado
IdResponsavel	118538	118757


Usuário sistema	Data início transação	Tabela	Tipo	Tempo transação (seg.)
kauan.headsoft	28/01/2026 11:02	mov_Atividade	Atualização	3

Campo	Valor anterior	Valor atualizado
IdAtividade		10643172
Campo	Valor anterior	Valor atualizado
IdResponsavel	110073	117117








## CAPITAL MAO #46048

CAPMAO para CAPCWB
Endereço: RUA MARECHAL DEODORO 869 SALA 303
CEP: 80010-010 CURITIBA - PR
CNPJ: 11.233.216/0004-66
INSC. MUN:200312794411
Observação (dados bancários): BANCO DO BRASIL - 001 AGENCIA 3336-7 C/C 8193-0
CAPITALLOG LOGISTICA LTDA 11.233.216/0004-66

As alterações devem ser feitas para os processos aéreos e marítimos.


Relatorio: NOVA FATURA S/ RETENÇÃO DE IMPOSTOS



 When Emp.IdPessoa = 48991 Then 58553 /*CAPITALLOG LOGISTICA LTDA (CAPMAO)*/
 When Emp.IdPessoa = 53431 Then 58552 /*CAPITALLOG LOGISTICA ITAJAÍ*/
 When Emp.IdPessoa = 53689 Then 65128 /*CAPITALLOG LOGISTICA CURITIBA*/



Left Outer Join
  mov_Proposta_Frete Pfr on Pfr.IdProposta_Frete = Ofr.IdProposta_Frete
Left Outer Join
  cad_Empresa Eps on Eps.IdEmpresa_Sistema = Pfr.IdEmpresa_Sistema
Left Outer Join
  cad_Pessoa Emp on Emp.IdPessoa = Eps.IdPessoa




  MAO
  CAPITALLOG LOGISTICA LTDA (CAPMAO)
  AVENIDA DJALMA BATISTA 3694 LOJA 6A
  69050-010 MANAUS - AM
  TEL.:  92 3021 3900

  CNPJ: 11.233.216/0002-02
  INSC. MUN.: 21117501

  Observação: BANCO DO BRASIL - 001 AGENCIA 1896-1C/C 111696-7
  CAPITALLOG LOGISTICA LTDA 11.233.216/0002-02



  CWB
  CAPITALLOG LOGISTICA LTDA (CAPCWB)
  RUA MARECHAL DEODORO 869 SALA 303
  80010-010 CURITIBA - PR

  CNPJ: 11.233.216/0004-66 
  INSC. MUN.: 200312794411


  Observação: BANCO DO BRASIL - 001 AGENCIA 3336-7 C/C 8193-0
  CAPITALLOG LOGISTICA LTDA 11.233.216/0004-66




## TEX #46188
Gerar Follow up quando cancelar processo.

IdPapel_Projeto = 11

IdEquipe_Tarefa = 52




## AGL #46150

Liberado para faturamento e voltou para Em andamento
Pegar situacao_agenciamento e verificar  o motivo de ter voltado.

Tirar log de processos

AGLIA0309-25
AGLIA1634-25
AGLIA2941-25
AGLIA3537-25
AGLIA3641-25
AGLIA3875-25
AGLIA2880-25
AGLIA4155-25
AGLIA3235-25
AGLIA3145-24 COMPLEMENTAR
AGLIA3259-25
AGLIA3119-25
AGLIA3035-25




## MASTERSUL #46114

Relatorio: EM - PROPOSTA COMERCIAL FCL

mov_Oferta_Frete_Free_Time
House_Origem

liga com IdOferta_Frete

COM - PROPOSTA COMERCIAL

OFERTA_FRETE_TAXA
Origem_Taxa







## TIRRENA #45562

Novo ajuste:

Prezados, 
Confirmamos o embarque de sua carga no referido navio, segue cópia do BL. 
Booking SSZ1731476 
Navio: LOG-IN PANTANAL / 0RO3MR1MA 
Saída: 26/01/2026 
Porto de Embarque: VITORIA 
Porto de Descarga: SYDNEY 
Local de emissão do BL:      
Exportador: BRAMAGRAN - BRASILEIRO MARMORE E GRANITO LTDA. 
CNEE: SNB STONE 
MBL: SSZ1731476  'MASTER DIRETO'
Modalidade Pagamento House: PREPAID ABROAD 

"Gentileza conferir o BL de acordo com o draft enviado, qualquer inserção de dados ou alteração haverá custo de reemissão, o BL WAYBILL será liberado após pagamentos das taxas locais, autorização do shipper e frete pelo importador."





## FLEX SHIPPING #46207
IdArquivo = 6381

7F4D9E roxo
FFFF00 amaralo






## TEX SHIPPING #46204
Consulta editor TEX

tabela para consultar primeiro passa pelo
mov_Tarifario_Origem_Destino do Tarifario local maritimo
apos entrar nele precisa conectar a mov_Tarifario_Taxa para poder buscar o Valor_Pagament_Unitario


cad_Origem_Destino-> 'IdOrigem_Destino' -> mov_Tarifario_Origem_Destino - > 'IdTarifario_Origem_Destino' -> mov_Tarifario_Taxa -> 'IdTarifario_Taxa' -> 'Valor_Pagamento_Unitario'



mov_Oferta_Frete_Viagem

mov_Oferta_Frete_Escala_Transbordo



## Leaderlog #46142

im2137-25


## TEX #46259
(Data_Prontidao_Previsao_Coleta) ERRO

## EXALOG #46264

OFERTA_TAXA_ORIGEM
OFERTA_TAXA_DESTINO IdTaxa_Logistica_Exibicao

 
## BRACHMANN #46110

eloisa.bianchin origem da copia
gustavo.tomasi copia da origem



## TEX
Bloqueio por situação














































































