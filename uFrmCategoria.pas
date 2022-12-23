unit uFrmCategoria;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, REST.Types, REST.Client, System.Types, System.StrUtils,
  Data.Bind.Components, Data.Bind.ObjectScope, System.JSON, System.Generics.Collections, System.UITypes;

type
  TFrmCategoria = class(TForm)
    cboCategorias: TComboBox;
    Label1: TLabel;
    RESTClientCategoria: TRESTClient;
    RESTRequestCategoria: TRESTRequest;
    RESTResponseCategoria: TRESTResponse;
    procedure FormShow(Sender: TObject);
    procedure cboCategoriasSelect(Sender: TObject);
    procedure ResetaListBoxes();
  private
    { Private declarations }
  public
    { Public declarations }
    jsonMontadoras: TJSONArray;
    sCategoriaSelecionada: string;
  end;

var
  FrmCategoria: TFrmCategoria;

implementation

{$R *.dfm}

uses uFrmPrincipal;

procedure TFrmCategoria.cboCategoriasSelect(Sender: TObject);
  var
    I: integer;
    item: TJSONObject;

begin
  FrmPrincipal.ListBoxMontadoras.Clear;

  sCategoriaSelecionada := cboCategorias.Items[cboCategorias.ItemIndex];
  FrmPrincipal.StatusBar1.SimpleText := sCategoriaSelecionada;
  RESTClientCategoria.BaseURL := FrmPrincipal.baseURL+'montadora'+FrmPrincipal.midURL+'&pm.type='+sCategoriaSelecionada;

  try
    RESTRequestCategoria.Execute;
    jsonMontadoras := TJSONObject.ParseJSONValue(RESTResponseCategoria.Content) as TJSONArray;

    {
      O ideal aqui é implementar com um 'Helper Load URL Stream', para o laço ocorra
      idependente se a API retornar um único objeto ou um array de objetos.
      Mas infelizmente, por enquanto, não domino esta técnica.
    }
    for I := 0 to jsonMontadoras.Count - 1 do
      begin
        item := jsonMontadoras.Items[I] as TJSONObject;
        FrmPrincipal.ListBoxMontadoras.Items.Add(item.GetValue('nome').Value);
      end;

    {
      Optei por mostrar e ocultar os objetos do form pois ainda não domino
      a técnica de construir e detruir objetos em tempo de execução.
      Também não sei qual a melhor prática.
    }
    FrmPrincipal.ListBoxMontadoras.Visible := True;
    FrmCategoria.Close;
  except
    MessageDlg('Não foi possível obter a lista de montadoras. Por favor, tente novamente.', mtError, [mbOK], 0);
  end;

end;

procedure TFrmCategoria.FormShow(Sender: TObject);
  var
    i: integer;
    retornoString: string;
    retornoVetor: TStringDynArray;
    listaRetorno: TStringList;

begin
  cboCategorias.Clear;
  FrmPrincipal.StatusBar1.SimpleText := '';
  ResetaListBoxes();
  RESTClientCategoria.BaseURL := FrmPrincipal.baseURL+'tipo'+FrmPrincipal.midURL;

  try
    RESTRequestCategoria.Execute;
    {
      Melhorei um pouco este trecho manipulando menos strings com o uso de uma
      lista de strings. Mas ainda gostaria de gerar um objeto com menos
      manipulação de strings ainda.
    }
    listaRetorno := TStringList.Create;
    try
      retornoString := RESTRequestCategoria.Response.Content;

      //removemos os colchetes
      retornoString:= StringReplace(retornoString, '[', '', [rfReplaceAll]);
      retornoString:= StringReplace(retornoString, ']', '', [rfReplaceAll]);
      listaRetorno.DelimitedText := retornoString;
      listaRetorno.Delimiter := ',';

      cboCategorias.Items.AddStrings(listaRetorno);
    finally
      listaRetorno.Free;
    end;

    except
      MessageDlg('Não foi possível obter as categorias. Por favor, tente novamente.', mtError, [mbOK], 0);
      PostMessage(FrmCategoria.Handle, WM_Close, 0, 0);
    end;

end;

procedure TFrmCategoria.ResetaListBoxes();
begin
  FrmPrincipal.ListBoxMontadoras.Visible := false;
  FrmPrincipal.ListBoxMontadoras.Clear;
  FrmPrincipal.ListBoxVeiculos.Visible := false;
  FrmPrincipal.ListBoxVeiculos.Clear;
  FrmPrincipal.ListBoxMotorizacao.Visible := false;
  FrmPrincipal.ListBoxMotorizacao.Clear;
  FrmPrincipal.ListBoxTiposSistema.Visible := false;
  FrmPrincipal.ListBoxTiposSistema.Clear;
  FrmPrincipal.ListBoxSistemas.Visible := false;
  FrmPrincipal.ListBoxSistemas.Clear;
end;

end.
