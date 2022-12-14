unit uFrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, REST.Types, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, Vcl.StdCtrls, Vcl.Menus, uFrmCategoria, uFrmSobre,
  Vcl.ComCtrls, System.JSON, System.Generics.Collections, System.UITypes;

type
  TFrmPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    Arquivo1: TMenuItem;
    Novaescolha1: TMenuItem;
    N1: TMenuItem;
    Sair1: TMenuItem;
    Sobre1: TMenuItem;
    ListBoxMontadoras: TListBox;
    ListBoxVeiculos: TListBox;
    RESTClientPrincipal: TRESTClient;
    RESTRequestPrincipal: TRESTRequest;
    RESTResponsePrincipal: TRESTResponse;
    ListBoxMotorizacao: TListBox;
    StatusBar1: TStatusBar;
    ListBoxTiposSistema: TListBox;
    ListBoxSistemas: TListBox;
    procedure Novaescolha1Click(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
    procedure ListBoxMontadorasClick(Sender: TObject);
    procedure ListBoxVeiculosClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBoxMotorizacaoClick(Sender: TObject);
    procedure ListBoxTiposSistemaClick(Sender: TObject);
    procedure ListBoxSistemasClick(Sender: TObject);
    procedure Sobre1Click(Sender: TObject);
  private
    { Private declarations }
    jaVeiculos: TJSONArray;
    jaMotorizacao: TJSONArray;
    jaTipoSistema: TJSONArray;
    jaSistema: TJSONArray;
    idMontadoraSelecionada: string;
    nomeMontadoraSelecionada: string;
    idVeiculoSelecionado: string;
    nomeVeiculoSelecionado: string;
    idMotorizacaoSelecionada: string;
    nomeMotorizacaoSelecionada: string;
    idTipoSistemaSelecionado: string;
    nomeTipoSistemaSelecionado: string;
  public
    { Public declarations }
    baseURL: string;
    midURL: string;
    //path: string
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
  baseURL := 'https://service.tecnomotor.com.br/iRasther/';
  midURL := '?pm.platform=1&pm.version=23';
end;

procedure TFrmPrincipal.ListBoxMontadorasClick(Sender: TObject);
  var
    joMontadoraSelecionada: TJSONObject;
    I: integer;
    item: TJSONObject;

begin
  ListBoxVeiculos.Clear;
  ListBoxMotorizacao.Clear;
  ListBoxMotorizacao.Visible := false;
  ListBoxTiposSistema.Clear;
  ListBoxTiposSistema.Visible := false;
  ListBoxSistemas.Clear;
  ListBoxSistemas.Visible := false;

  joMontadoraSelecionada := FrmCategoria.jsonMontadoras.Items[ListBoxMontadoras.ItemIndex] as TJSONObject;
  idMontadoraSelecionada := joMontadoraSelecionada.GetValue('id').Value;
  nomeMontadoraSelecionada := joMontadoraSelecionada.GetValue('nome').Value;
  StatusBar1.SimpleText := FrmCategoria.sCategoriaSelecionada+'\'+nomeMontadoraSelecionada;
  RESTClientPrincipal.BaseURL := baseURL+'veiculo'+midURL+'&pm.type='+FrmCategoria.sCategoriaSelecionada+'&pm.assemblers='
   +idMontadoraSelecionada;

  try
    RESTRequestPrincipal.Execute;
    jaVeiculos := TJSONObject.ParseJSONValue(RESTResponsePrincipal.Content) as TJSONArray;
    for I := 0 to jaVeiculos.Count - 1 do
      begin
        item := jaVeiculos.Items[I] as TJSONObject;
        ListBoxVeiculos.Items.Add(item.GetValue('nome').Value);
      end;

    ListBoxVeiculos.Visible := True;
  except
    MessageDlg('N?o foi poss?vel obter a lista de veiculos. Por favor, tente novamente.', mtError, [mbOK], 0);
  end;

end;

procedure TFrmPrincipal.ListBoxMotorizacaoClick(Sender: TObject);
  var
    joMotorizacaoSelecionada: TJSONObject;
    I: integer;
    item: TJSONObject;

begin
  ListBoxTiposSistema.Clear;
  ListBoxSistemas.Visible := false;
  ListBoxSistemas.Clear;

  joMotorizacaoSelecionada := jaMotorizacao.Items[ListBoxMotorizacao.ItemIndex] as TJSONObject;
  idMotorizacaoSelecionada := joMotorizacaoSelecionada.GetValue('id').Value;
  nomeMotorizacaoSelecionada := joMotorizacaoSelecionada.GetValue('nome').Value;
  StatusBar1.SimpleText := FrmCategoria.sCategoriaSelecionada+'\'+nomeMontadoraSelecionada+'\'+nomeVeiculoSelecionado+'\'
   +nomeMotorizacaoSelecionada;
  RESTClientPrincipal.BaseURL := baseURL+'tiposistema'+midURL+'&pm.type='+FrmCategoria.sCategoriaSelecionada
   +'&pm.assemblers='+idMontadoraSelecionada+'&pm.vehicles='+idVeiculoSelecionado+'&pm.engines='+idMotorizacaoSelecionada;

  try
    RESTRequestPrincipal.Execute;
    jaTipoSistema := TJSONObject.ParseJSONValue(RESTResponsePrincipal.Content) as TJSONArray;
    for I := 0 to jaTipoSistema.Count - 1 do
      begin
        item := jaTipoSistema.Items[I] as TJSONObject;
        ListBoxTiposSistema.Items.Add(item.GetValue('nome').Value);
      end;

    ListBoxTiposSistema.Visible := True;
  except
    MessageDlg('N?o foi poss?vel obter a lista de tipos de sistema. Por favor, tente novamente.', mtError, [mbOK], 0);
  end;

end;

procedure TFrmPrincipal.ListBoxSistemasClick(Sender: TObject);
  var
    joSistemaSelecionado: TJSONObject;
    nomeSistemaSelecionado: string;

begin
  joSistemaSelecionado := jaSistema.Items[ListBoxSistemas.ItemIndex] as TJSONObject;
  nomeSistemaSelecionado := joSistemaSelecionado.GetValue('nome').Value;
  StatusBar1.SimpleText := FrmCategoria.sCategoriaSelecionada+'\'+nomeMontadoraSelecionada+'\'+nomeVeiculoSelecionado+'\'
   +nomeMotorizacaoSelecionada+'\'+nomeTipoSistemaSelecionado+'\'+nomeSistemaSelecionado;
end;

procedure TFrmPrincipal.ListBoxTiposSistemaClick(Sender: TObject);
  var
    joTipoSistemaSelecionado: TJSONObject;
    I: integer;
    item: TJSONObject;

begin
  ListBoxSistemas.Clear;
  joTipoSistemaSelecionado := jaTipoSistema.Items[ListBoxTiposSistema.ItemIndex] as TJSONObject;
  idTipoSistemaSelecionado := joTipoSistemaSelecionado.GetValue('id').Value;
  nomeTipoSistemaSelecionado := joTipoSistemaSelecionado.GetValue('nome').Value;
  StatusBar1.SimpleText := FrmCategoria.sCategoriaSelecionada+'\'+nomeMontadoraSelecionada+'\'+nomeVeiculoSelecionado+'\'
   +nomeMotorizacaoSelecionada+'\'+nomeTipoSistemaSelecionado;

  RESTClientPrincipal.BaseURL := baseURL+'sistema'+midURL+'&pm.type='+FrmCategoria.sCategoriaSelecionada+'&pm.assemblers='
   +idMontadoraSelecionada+'&pm.vehicles='+idVeiculoSelecionado+'&pm.engines='+idMotorizacaoSelecionada+'&pm.typeOfSystems='
   +idTipoSistemaSelecionado;

  try
    RESTRequestPrincipal.Execute;
    jaSistema := TJSONObject.ParseJSONValue(RESTResponsePrincipal.Content) as TJSONArray;
    for I := 0 to jaSistema.Count - 1 do
      begin
        item := jaSistema.Items[I] as TJSONObject;
        ListBoxSistemas.Items.Add(item.GetValue('nome').Value);
      end;

    ListBoxSistemas.Visible := True;
  except
    MessageDlg('N?o foi poss?vel obter a lista de sistemas. Por favor, tente novamente.', mtError, [mbOK], 0);
  end;

end;

procedure TFrmPrincipal.ListBoxVeiculosClick(Sender: TObject);
{
  Em aten??o ? observa??o do item 5, consegui realizar o tratamento exibindo
   o tipo de sistema ao inv?s de motoriza??o.
  Ocorre que em seguida n?o consigo exibir o sistema a partir do tipo de
   sistema selecionado, para casos de aus?ncia de motoriza??o.
}

  var
    joVeiculoSelecionado: TJSONObject;
    I: integer;
    item: TJSONObject;

begin
  ListBoxMotorizacao.Clear;
  ListBoxTiposSistema.Clear;
  ListBoxTiposSistema.Visible := false;
  ListBoxSistemas.Clear;
  ListBoxSistemas.Visible := false;

  joVeiculoSelecionado := jaVeiculos.Items[ListBoxVeiculos.ItemIndex] as TJSONObject;
  idVeiculoSelecionado := joVeiculoSelecionado.GetValue('id').Value;
  nomeVeiculoSelecionado := joVeiculoSelecionado.GetValue('nome').Value;
  StatusBar1.SimpleText := FrmCategoria.sCategoriaSelecionada+'\'+nomeMontadoraSelecionada+'\'+nomeVeiculoSelecionado;
  RESTClientPrincipal.BaseURL := baseURL+'motorizacao'+midURL+'&pm.type='+FrmCategoria.sCategoriaSelecionada
   +'&pm.assemblers='+idMontadoraSelecionada+'&pm.vehicles='+idVeiculoSelecionado;

  try
    RESTRequestPrincipal.Execute;
    if(RESTResponsePrincipal.Content = '[null]') then
      begin
        StatusBar1.SimpleText := baseURL+'tiposistema'+midURL+'&pm.type='+FrmCategoria.sCategoriaSelecionada
          +'&pm.assemblers='+idMontadoraSelecionada+'&pm.vehicles='+idVeiculoSelecionado;
        RESTClientPrincipal.BaseURL := StatusBar1.SimpleText;
        RESTRequestPrincipal.Execute;
      end;
    jaMotorizacao := TJSONObject.ParseJSONValue(RESTResponsePrincipal.Content) as TJSONArray;
    for I := 0 to jaMotorizacao.Count - 1 do
      begin
        item := jaMotorizacao.Items[I] as TJSONObject;
        ListBoxMotorizacao.Items.Add(item.GetValue('nome').Value);
      end;

    ListBoxMotorizacao.Visible := True;
  except
    MessageDlg('N?o foi poss?vel obter a lista de motoriza??o. Por favor, tente novamente.', mtError, [mbOK], 0);
  end;

end;

procedure TFrmPrincipal.Novaescolha1Click(Sender: TObject);
begin
  FrmCategoria.ShowModal;
end;

procedure TFrmPrincipal.Sair1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFrmPrincipal.Sobre1Click(Sender: TObject);
begin
  FrmSobre.ShowModal;
end;

end.
