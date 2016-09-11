program crtPrj;

uses
  Vcl.Forms,
  uPrj in 'uPrj.pas' {frmPrj},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Ruby Graphite');
  Application.CreateForm(TfrmPrj, frmPrj);
  Application.Run;
end.
