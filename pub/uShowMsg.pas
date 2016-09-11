unit uShowMsg;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Imaging.GIFImg, Vcl.ExtCtrls,uMessage;

type
  TFrmShowMsg = class(TForm)
    lbMsg: TLabel;
    btnSure: TBitBtn;
    btnCancle: TBitBtn;
    imgAsk: TImage;
    imgErr: TImage;
    imgMsg: TImage;
    procedure FormShow(Sender: TObject);
    procedure btnSureClick(Sender: TObject);
    procedure btnCancleClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    res: Integer;
  end;

var
  FrmShowMsg: TFrmShowMsg;
  m_msg: widestring;


implementation

{$R *.dfm}

procedure TFrmShowMsg.btnCancleClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmShowMsg.btnSureClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFrmShowMsg.FormShow(Sender: TObject);
begin
  lbMsg.Caption := m_msg;
  if Self.Caption = '´íÎó' then
  begin
    imgErr.Show;
    imgAsk.Hide;
    imgMsg.Hide;
  end
  else if Self.Caption = 'Ñ¯ÎÊ' then
  begin
    imgAsk.Show;
    imgErr.Hide;
    imgMsg.Hide;
  end
  else
  begin
    imgMsg.Show;
    imgErr.Hide;
    imgAsk.Hide;
  end;
end;

end.
