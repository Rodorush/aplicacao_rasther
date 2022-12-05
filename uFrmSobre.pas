unit uFrmSobre;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls;

type
  TFrmSobre = class(TForm)
    Image1: TImage;
    Button1: TButton;
    Label2: TLabel;
    Panel1: TPanel;
    Label1: TLabel;
    Label4: TLabel;
    Panel2: TPanel;
    Label5: TLabel;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmSobre: TFrmSobre;

implementation

{$R *.dfm}

procedure TFrmSobre.Button1Click(Sender: TObject);
begin
  FrmSobre.Close;
end;

end.
