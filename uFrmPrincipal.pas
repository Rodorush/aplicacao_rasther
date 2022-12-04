unit uFrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, REST.Types, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, Vcl.StdCtrls, Vcl.Menus, uFrmCategoria,
  Vcl.ComCtrls, System.JSON;

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
    procedure Novaescolha1Click(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
    procedure ListBoxMontadorasClick(Sender: TObject);
  private
    { Private declarations }
    jsonVeiculos: TJSONArray;
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

procedure TFrmPrincipal.ListBoxMontadorasClick(Sender: TObject);
  var
    baseURL: string;
    montadoraSelecionada: TJSONObject;
    I: integer;
    item: TJSONObject;

begin
  ListBoxVeiculos.Clear;
  montadoraSelecionada := FrmCategoria.jsonMontadoras.Items[ListBoxMontadoras.ItemIndex] as TJSONObject;
  baseURL := FrmCategoria.RESTClientCategoria.BaseURL;
  baseURL := StringReplace(baseURL, 'montadora', 'veiculo', [])+'&pm.assemblers='+montadoraSelecionada.GetValue('id').Value;

  //Memo1.Lines.Add(baseURL);

  RESTClientPrincipal.BaseURL := baseURL;
  try
    RESTRequestPrincipal.Execute;
    jsonVeiculos := TJSONObject.ParseJSONValue(RESTResponsePrincipal.Content) as TJSONArray;
    for I := 0 to jsonVeiculos.Count - 1 do
      begin
        item := jsonVeiculos.Items[I] as TJSONObject;
        FrmPrincipal.ListBoxVeiculos.Items.Add(item.GetValue('nome').Value);
      end;

    ListBoxVeiculos.Visible := True;
  except
    MessageDlg('Não foi possível obter a lista de veiculos. Por favor, tente novamente.', mtError, [mbOK], 0);
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
