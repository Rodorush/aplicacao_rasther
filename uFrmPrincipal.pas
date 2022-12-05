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
    procedure Novaescolha1Click(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
    procedure ListBoxMontadorasClick(Sender: TObject);
    procedure ListBoxVeiculosClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    jsonVeiculos: TJSONArray;
    jsonMotorizacao: TJSONArray;
    sMontadoraSelecionada: string;
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
    jMontadoraSelecionada: TJSONObject;
    I: integer;
    item: TJSONObject;

begin
  ListBoxVeiculos.Clear;
  ListBoxMotorizacao.Clear;
  ListBoxMotorizacao.Visible := false;
  jMontadoraSelecionada := FrmCategoria.jsonMontadoras.Items[ListBoxMontadoras.ItemIndex] as TJSONObject;
  sMontadoraSelecionada := jMontadoraSelecionada.GetValue('id').Value;
  StatusBar1.SimpleText := baseURL+'veiculo'+midURL+'&pm.type='+FrmCategoria.sCategoriaSelecionada+'&pm.assemblers='
   +sMontadoraSelecionada;
  RESTClientPrincipal.BaseURL := StatusBar1.SimpleText;

  try
    RESTRequestPrincipal.Execute;
    jsonVeiculos := TJSONObject.ParseJSONValue(RESTResponsePrincipal.Content) as TJSONArray;
    for I := 0 to jsonVeiculos.Count - 1 do
      begin
        item := jsonVeiculos.Items[I] as TJSONObject;
        ListBoxVeiculos.Items.Add(item.GetValue('nome').Value);
      end;

    ListBoxVeiculos.Visible := True;
  except
    MessageDlg('N�o foi poss�vel obter a lista de veiculos. Por favor, tente novamente.', mtError, [mbOK], 0);
  end;

end;

procedure TFrmPrincipal.ListBoxVeiculosClick(Sender: TObject);
  var
    jVeiculoSelecionado: TJSONObject;
    sVeiculoSelecionado: string;
    I: integer;
    item: TJSONObject;

begin
  ListBoxMotorizacao.Clear;
  jVeiculoSelecionado := jsonVeiculos.Items[ListBoxVeiculos.ItemIndex] as TJSONObject;
  sVeiculoSelecionado := jVeiculoSelecionado.GetValue('id').Value;
  StatusBar1.SimpleText := baseURL+'motorizacao'+midURL+'&pm.type='+FrmCategoria.sCategoriaSelecionada
   +'&pm.assemblers='+sMontadoraSelecionada+'&pm.vehicles='+sVeiculoSelecionado;
  RESTClientPrincipal.BaseURL := StatusBar1.SimpleText;

  try
    RESTRequestPrincipal.Execute;
    if(RESTResponsePrincipal.Content = '[null]') then
      begin
        StatusBar1.SimpleText := baseURL+'tiposistema'+midURL+'&pm.type='+FrmCategoria.sCategoriaSelecionada
          +'&pm.assemblers='+sMontadoraSelecionada+'&pm.vehicles='+sVeiculoSelecionado;
        RESTClientPrincipal.BaseURL := StatusBar1.SimpleText;
        RESTRequestPrincipal.Execute;
      end;
    jsonMotorizacao := TJSONObject.ParseJSONValue(RESTResponsePrincipal.Content) as TJSONArray;
    for I := 0 to jsonMotorizacao.Count - 1 do
      begin
        item := jsonMotorizacao.Items[I] as TJSONObject;
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
