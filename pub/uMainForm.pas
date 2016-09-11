unit uMainForm;

interface

uses

 AdoDB,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls,
  ExtCtrls, StdCtrls ;

type
  TMainForm = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TntFormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    g_AdoCon: TAdoConnection;
    m_sModualBBH: string;

    function MsgBox(sMsg: WideString): integer;
    procedure ShowMsg(sMsg: WideString);
    //语言转换
    function GetNote(str: WideString): WideString;
    //语言转换支持带参数 ,如：你好，操作员[李馨俊]。，[]里不进行转换
    function GetNote_Para(sMsg: WideString): WideString;
  end;

var
  tmp_g_AdoCon: TAdoConnection;
  tmp_m_sModualBBH: string;
  MainForm: TMainForm;

implementation

uses uShowMsg;

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  inherited;
  g_adoCon := tmp_g_adoCon;
  m_sModualBBH := tmp_m_sModualBBH;
  Font.Charset := GB2312_CHARSET;
  Font.Size := 9;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
var
  pMsg: PCHAR;
begin
  inherited;
  pMsg := PCHAR(m_sModualBBH);
  //发送窗口退出消息
  SendMessage(Application.MainForm.Handle, WM_USER_DLLFORMEXIT, integer(pMsg), 0);
end;

procedure TMainForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
end;

function TMainForm.MsgBox(sMsg: WideString): integer;
begin
  inherited;
  if g_Para = nil then
    raise Exception.Create('请传入g_Para参数。');
  frmMsgBox := TfrmMsgBox.Create(self);
  //g_Para.GetChangeLang.ChangeLang(frmMsgBox);
  with frmMsgBox do
  begin
    btnOK.Caption := g_Para.GetChangeLang.GetNote(btnOK.Caption);
    btnCancel.Caption := g_Para.GetChangeLang.GetNote(btnCancel.Caption);
    m_sTitle := g_Para.GetChangeLang.GetNote(Caption);
    m_sMsg := g_Para.GetChangeLang.GetTranslatedMsg(sMsg);
  end;

  if frmMsgBox.ShowModal = mrOK then
  begin
    frmMsgBox.Free;
    Result := mrOK;
  end
  else
  begin
    frmMsgBox.Free;
    Result := mrCancel;
  end;


end;

procedure TMainForm.ShowMsg(sMsg: WideString);
begin
  inherited;
  if g_Para = nil then
    raise Exception.Create('请传入g_Para参数。');
  frmShowMsg := TfrmShowMsg.Create(self);
  with frmShowMsg do
  begin
    btnOK.Caption := g_Para.GetChangeLang.GetNote(btnOK.Caption);
    m_sTitle := g_Para.GetChangeLang.GetNote(Caption);
    m_sMsg := g_Para.GetChangeLang.GetTranslatedMsg(sMsg);
    ShowModal;
  end;
  frmShowMsg.Free;
end;

procedure TMainForm.TntFormShow(Sender: TObject);
begin
  inherited;
  if g_Para = nil then
    raise Exception.Create('请传入g_Para参数。');
  //语言初始化
  g_Para.GetChangeLang.ChangeLang(self);
end;

//语言转换

function TMainForm.GetNote(str: WideString): WideString;
begin
  if g_Para = nil then
    raise Exception.Create('请传入g_Para参数。');
  Result := g_Para.GetChangeLang.GetNote(str);
end;

//语言转换支持带参数 ,如：你好，操作员[李馨俊]。，[]里不进行转换

function TMainForm.GetNote_Para(sMsg: WideString): WideString;
begin
  if g_Para = nil then
    raise Exception.Create('请传入g_Para参数。');
  Result := g_Para.GetChangeLang.GetTranslatedMsg(sMsg);
end;
end.
