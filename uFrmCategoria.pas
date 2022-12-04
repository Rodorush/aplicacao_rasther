unit uFrmCategoria;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, REST.Types, REST.Client, System.Types, System.StrUtils,
  Data.Bind.Components, Data.Bind.ObjectScope;

type
  TFrmCategoria = class(TForm)
    ComboBox1: TComboBox;
    Button1: TButton;
    Label1: TLabel;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCategoria: TFrmCategoria;

implementation

{$R *.dfm}

procedure TFrmCategoria.Button1Click(Sender: TObject);
begin
  //Obter montadoras
end;

procedure TFrmCategoria.FormShow(Sender: TObject);
  var
    i: integer;
    retornoString: string;
    retornoVetor: TStringDynArray;

begin
  ComboBox1.Clear;
  RESTRequest1.Execute;
  //Optei por manipular strings pois infelizmente não conheço um método
  //em Delphi para popular a ComboBox de forma direta em forma de objeto
  //com o array de retorno da API
  retornoString := RESTRequest1.Response.Content;
  retornoString := retornoString.Substring(1,length(retornoString)-2);
  retornoVetor := SplitString(retornoString, ',');
  for i := 0 to length(retornoVetor)-1 do
    ComboBox1.Items.Add(retornoVetor[i].Substring(1,length(retornoVetor[i])-2));
end;

end.
