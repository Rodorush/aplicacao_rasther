program AplicacaoRasther;

uses
  Vcl.Forms,
  uFrmPrincipal in 'uFrmPrincipal.pas' {FrmPrincipal},
  uFrmCategoria in 'uFrmCategoria.pas' {FrmCategoria},
  uFrmSobre in 'uFrmSobre.pas' {FrmSobre};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.CreateForm(TFrmCategoria, FrmCategoria);
  Application.CreateForm(TFrmSobre, FrmSobre);
  Application.Run;
end.
