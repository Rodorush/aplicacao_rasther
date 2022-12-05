unit uFrmCategoria;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, REST.Types, REST.Client, System.Types, System.StrUtils,
  Data.Bind.Components, Data.Bind.ObjectScope, System.JSON, System.Generics.Collections, System.UITypes;

type
  TFrmCategoria = class(TForm)
    ComboBox1: TComboBox;
    Label1: TLabel;
    RESTClientCategoria: TRESTClient;
    RESTRequestCategoria: TRESTRequest;
    RESTResponseCategoria: TRESTResponse;
    procedure FormShow(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
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

procedure TFrmCategoria.ComboBox1Select(Sender: TObject);
  var
    I: integer;
    item: TJSONObject;

begin
  FrmPrincipal.ListBoxMontadoras.Clear;

  sCategoriaSelecionada := ComboBox1.Items[ComboBox1.ItemIndex];
  FrmPrincipal.StatusBar1.SimpleText := FrmPrincipal.baseURL+'montadora'+FrmPrincipal.midURL+'&pm.type='+sCategoriaSelecionada;
  RESTClientCategoria.BaseURL := FrmPrincipal.StatusBar1.SimpleText;

  try
    RESTRequestCategoria.Execute;
    jsonMontadoras := TJSONObject.ParseJSONValue(RESTResponseCategoria.Content) as TJSONArray;

    {
      O ideal aqui � implementar com um 'Helper Load URL Stream', para o la�o ocorra
      idependente se a API retornar um �nico objeto ou um array de objetos.
      Mas infelizmente, por enquanto, n�o domino esta t�cnica.
    }
    for I := 0 to jsonMontadoras.Count - 1 do
      begin
        item := jsonMontadoras.Items[I] as TJSONObject;
        FrmPrincipal.ListBoxMontadoras.Items.Add(item.GetValue('nome').Value);
      end;

    {
      Optei por mostrar e ocultar os objetos do form pois ainda n�o domino
      a t�cnica de construir e detruir objetos em tempo de execu��o.
      Tamb�m n�o sei qual a melhor pr�tica.
    }
    FrmPrincipal.ListBoxMontadoras.Visible := True;
    FrmCategoria.Close;
  except
    MessageDlg('N�o foi poss�vel obter a lista de montadoras. Por favor, tente novamente.', mtError, [mbOK], 0);
  end;

end;

procedure TFrmCategoria.FormShow(Sender: TObject);
  var
    i: integer;
    retornoString: string;
    retornoVetor: TStringDynArray;

begin
  //*** tentar criar objeto direto de string
  ComboBox1.Clear;
  ResetaListBoxes();
  FrmPrincipal.StatusBar1.SimpleText := FrmPrincipal.baseURL+'tipo'+FrmPrincipal.midURL;
  RESTClientCategoria.BaseURL := FrmPrincipal.StatusBar1.SimpleText;

  try
    RESTRequestCategoria.Execute;
    {
      Optei por manipular strings pois infelizmente n�o conhe�o um m�todo
      em Delphi para popular a ComboBox de forma direta em forma de objeto
      com o array de retorno da API
    }
    retornoString := RESTRequestCategoria.Response.Content;
    retornoString := retornoString.Substring(1,length(retornoString)-2);
    retornoVetor := SplitString(retornoString, ',');
    for i := 0 to length(retornoVetor)-1 do
      ComboBox1.Items.Add(retornoVetor[i].Substring(1,length(retornoVetor[i])-2));
    except
      MessageDlg('N�o foi poss�vel obter as categorias. Por favor, tente novamente.', mtError, [mbOK], 0);
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
