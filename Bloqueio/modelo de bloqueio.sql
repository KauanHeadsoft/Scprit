
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
---------------------------
OK
---------------------------
