unit uGcysSub;

interface

uses
  Winapi.Windows, Winapi.Messages, MyPub,System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,Data.DB, Data.Win.ADODB,
  Vcl.ComCtrls;

type
  TfrmGcysSub = class(TForm)
    pnl4: TPanel;
    btnSave: TBitBtn;
    btnClose: TBitBtn;
    procedure btnCloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    m_umState: char; //主界面操作标志
    m_cdsOther :TAdoDataSet;
    m_qryOperate : TAdoQuery;//用于校验
    m_cmd: TAdoCommand;  //用于操作的
    m_qryUser: TAdoQuery; //传入一条操作信息
    m_User : Integer;
  end;

var
  frmGcysSub: TfrmGcysSub;

implementation

{$R *.dfm}

procedure TfrmGcysSub.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmGcysSub.btnSaveClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrmGcysSub.FormCreate(Sender: TObject);
begin
  Font.Charset := GB2312_CHARSET;
  Font.Size := 9;
end;

procedure TfrmGcysSub.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  ControlKey(key,Shift);
end;

end.
