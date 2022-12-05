unit uFrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, REST.Types, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, Vcl.StdCtrls, Vcl.Menus, uFrmCategoria,
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
  private
    { Private declarations }
    jaVeiculos: TJSONArray;
    jaMotorizacao: TJSONArray;
    jaTipoSistema: TJSONArray;
    sMontadoraSelecionada: string;
    sVeiculoSelecionado: string;
    sMotorizacaoSelecionada: string;
    sTipoSistemaSelecionado: string;
  public
    { Public declarations }
    baseURL: string;
    midURL: string;
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
  baseURL := 'https://service.tecnomotor.com.br/iRasther/';
  midURL := '?pm.platform=1&pm.version=23';
  StatusBar1.SimpleText := baseURL;
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
  sMontadoraSelecionada := joMontadoraSelecionada.GetValue('id').Value;
  StatusBar1.SimpleText := baseURL+'veiculo'+midURL+'&pm.type='+FrmCategoria.sCategoriaSelecionada+'&pm.assemblers='
   +sMontadoraSelecionada;
  RESTClientPrincipal.BaseURL := StatusBar1.SimpleText;

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
    MessageDlg('N�o foi poss�vel obter a lista de veiculos. Por favor, tente novamente.', mtError, [mbOK], 0);
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
  sMotorizacaoSelecionada := joMotorizacaoSelecionada.GetValue('id').Value;
  StatusBar1.SimpleText := baseURL+'tiposistema'+midURL+'&pm.type='+FrmCategoria.sCategoriaSelecionada
   +'&pm.assemblers='+sMontadoraSelecionada+'&pm.vehicles='+sVeiculoSelecionado+'&pm.engines='+sMotorizacaoSelecionada;
  RESTClientPrincipal.BaseURL := StatusBar1.SimpleText;

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
    MessageDlg('N�o foi poss�vel obter a lista de tipos de sistema. Por favor, tente novamente.', mtError, [mbOK], 0);
  end;

end;

procedure TFrmPrincipal.ListBoxTiposSistemaClick(Sender: TObject);
  var
    joTipoSistemaSelecionado: TJSONObject;
    I: integer;
    item: TJSONObject;
    jaSistema: TJSONArray;

begin
  ListBoxSistemas.Clear;
  joTipoSistemaSelecionado := jaTipoSistema.Items[ListBoxTiposSistema.ItemIndex] as TJSONObject;
  sTipoSistemaSelecionado := joTipoSistemaSelecionado.GetValue('id').Value;
  StatusBar1.SimpleText := baseURL+'sistema'+midURL+'&pm.type='+FrmCategoria.sCategoriaSelecionada+'&pm.assemblers='
   +sMontadoraSelecionada+'&pm.vehicles='+sVeiculoSelecionado+'&pm.engines='+sMotorizacaoSelecionada+'&pm.typeOfSystems='
   +sTipoSistemaSelecionado;
  RESTClientPrincipal.BaseURL := StatusBar1.SimpleText;

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
    MessageDlg('N�o foi poss�vel obter a lista de sistemas. Por favor, tente novamente.', mtError, [mbOK], 0);
  end;

end;

procedure TFrmPrincipal.ListBoxVeiculosClick(Sender: TObject);
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
  sVeiculoSelecionado := joVeiculoSelecionado.GetValue('id').Value;
  StatusBar1.SimpleText := baseURL+'motorizacao'+midURL+'&pm.type='+FrmCategoria.sCategoriaSelecionada
   +'&pm.assemblers='+sMontadoraSelecionada+'&pm.vehicles='+sVeiculoSelecionado;
  RESTClientPrincipal.BaseURL := StatusBar1.SimpleText;

  try
    RESTRequestPrincipal.Execute;
    if(RESTResponsePrincipal.Content = '[null]') then //Tentar pular um listbox
      begin
        StatusBar1.SimpleText := baseURL+'tiposistema'+midURL+'&pm.type='+FrmCategoria.sCategoriaSelecionada
          +'&pm.assemblers='+sMontadoraSelecionada+'&pm.vehicles='+sVeiculoSelecionado;
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
    MessageDlg('N�o foi poss�vel obter a lista de motoriza��o. Por favor, tente novamente.', mtError, [mbOK], 0);
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

end.
