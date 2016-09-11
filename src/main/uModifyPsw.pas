unit uModifyPsw;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TFrmModifyPsw = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtOld: TEdit;
    edtNew1: TEdit;
    edtNew2: TEdit;
    bbtnOk: TBitBtn;
    bbtnCancel: TBitBtn;
    procedure bbtnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmModifyPsw: TFrmModifyPsw;

implementation

{$R *.dfm}

uses MyPub, uMainForm;

procedure TFrmModifyPsw.bbtnCancelClick(Sender: TObject);
begin
  close;
end;

procedure TFrmModifyPsw.FormShow(Sender: TObject);
begin
  PutFormCenter(self,FrmMain);
end;

end.
