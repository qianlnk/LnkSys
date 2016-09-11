unit uDllSub;

interface

uses
  Winapi.Windows, Winapi.Messages, MyPub,System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,Data.DB, Data.Win.ADODB,
  Vcl.ComCtrls;

type
  TfrmDllSub = class(TForm)
    pnl4: TPanel;
    btnSave: TBitBtn;
    btnClose: TBitBtn;
    procedure btnCloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
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
  frmDllSub: TfrmDllSub;

implementation

{$R *.dfm}

procedure TfrmDllSub.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmDllSub.btnSaveClick(Sender: TObject);
begin
  //在这里添加代码
  //
  //
  ModalResult := mrOk;
end;

procedure TfrmDllSub.FormCreate(Sender: TObject);
begin
  Font.Charset := GB2312_CHARSET;
  Font.Size := 9;
end;

//按回车键跳到下一个输入项
procedure TfrmDllSub.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  ControlKey(key,Shift);
end;

//支持ctrl+c快捷关闭窗体   ctrl+s 快捷保存
procedure TfrmDllSub.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if(Key = #3) then
  begin
    btnCloseClick(Sender);
  end;
  if(Key = #$13) then
  begin
    btnSaveClick(Sender);
  end;
end;

end.
