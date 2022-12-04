unit uFrmCategoria;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, REST.Types, REST.Client, System.Types, System.StrUtils,
  Data.Bind.Components, Data.Bind.ObjectScope, System.JSON;

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
  end;

var
  FrmCategoria: TFrmCategoria;

implementation

{$R *.dfm}

uses uFrmPrincipal;

procedure TFrmCategoria.ComboBox1Select(Sender: TObject);
  var
    I: integer;
    retornoString: string;
    retornoVetor: TStringDynArray;
    baseURL: string;
    item: TJSONObject;

begin
  FrmPrincipal.ListBoxMontadoras.Clear;

  baseURL := 'https://service.tecnomotor.com.br/iRasther/montadora?pm.platform=1&pm.version=23&pm.type='
   + ComboBox1.Items[ComboBox1.ItemIndex];
  RESTClientCategoria.BaseURL := baseURL;

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

begin
  //*** tentar criar objeto direto de string
  ComboBox1.Clear;
  ResetaListBoxes();
  RESTClientCategoria.BaseURL := 'https://service.tecnomotor.com.br/iRasther/tipo?pm.platform=1&pm.version=23';

  try
    RESTRequestCategoria.Execute;
    {
      Optei por manipular strings pois infelizmente não conheço um método
      em Delphi para popular a ComboBox de forma direta em forma de objeto
      com o array de retorno da API
    }
    retornoString := RESTRequestCategoria.Response.Content;
    retornoString := retornoString.Substring(1,length(retornoString)-2);
    retornoVetor := SplitString(retornoString, ',');
    for i := 0 to length(retornoVetor)-1 do
      ComboBox1.Items.Add(retornoVetor[i].Substring(1,length(retornoVetor[i])-2));
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
end;

end.
