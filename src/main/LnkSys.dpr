program LnkSys;

uses
  Vcl.Forms,
  uMainForm in 'uMainForm.pas' {FrmMain},
  uLogin in 'uLogin.pas' {FrmLogin},
  MyPub in '..\..\pub\MyPub.pas',
  uMessage in '..\..\pub\uMessage.pas',
  uShowMsg in '..\..\pub\uShowMsg.pas' {FrmShowMsg},
  uModifyPsw in 'uModifyPsw.pas' {FrmModifyPsw},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.CreateForm(TFrmModifyPsw, FrmModifyPsw);
  Application.Run;
end.
