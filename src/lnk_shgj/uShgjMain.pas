unit uShgjMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB,MyPub,uMessage,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,StrUtils,math;

type
  TfrmShgjMain = class(TForm)
    pnlCtrl: TPanel;
    btnAdd: TBitBtn;
    btnDelete: TBitBtn;
    btnModify: TBitBtn;
    btnView: TBitBtn;
    pnlSearchOption: TPanel;
    btnSearch: TBitBtn;
    dbgrd1: TDBGrid;
    cmd: TADOCommand;
    cdsOther: TADODataSet;
    dsUser: TDataSource;
    qryUser: TADOQuery;
    qryOperate: TADOQuery;
    btnClose: TBitBtn;
    con1: TADOConnection;
    procedure InitDBcon;  //初始化ADO组件的链接
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnSearchClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnModifyClick(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    g_user: Integer;
    g_con: TADOConnection;
    g_moduleid: string;
  end;

var
  tmp_g_Con: TAdoConnection;
  tmp_g_User: Integer;
  tmp_g_moduleid: string;
  frmShgjMain: TfrmShgjMain;

implementation

{$R *.dfm}

uses uShgjSub, uShgjDel;
procedure TfrmShgjMain.btnAddClick(Sender: TObject);
begin
  frmShgjSub := TfrmShgjSub.Create(Application);
  SetSubFormPlace(frmShgjSub);
  frmShgjSub.Caption := 'DLL模块--增加';
  frmShgjSub.m_umState := 'A';
  frmShgjSub.m_cmd := cmd;
  frmShgjSub.m_qryOperate := qryOperate;
  frmShgjSub.m_qryUser := qryUser;
  frmShgjSub.m_cdsOther := cdsOther;
  frmShgjSub.m_User := g_user;

  if frmShgjSub.ShowModal = mrOk then
  begin
    btnSearchClick(sender);
    //qryUser.Locate('FID',GetNextID(qryOperate,'tUser') - 1,[]);
  end;
  frmShgjSub.Release;
end;

procedure TfrmShgjMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmShgjMain.btnDeleteClick(Sender: TObject);
begin
  frmShgjDel := TfrmShgjDel.Create(Application);
  PutFormCenter(frmShgjDel,Self);
  frmShgjDel.Caption := 'DLL模块--删除';
  frmShgjDel.m_cmd := cmd;
  frmShgjDel.m_qryOperate := qryOperate;
  frmShgjDel.m_qryUser := qryUser;
  frmShgjDel.m_cdsOther := cdsOther;
  frmShgjDel.m_User := g_user;

  if frmShgjDel.ShowModal = mrOk then
  begin
    btnSearchClick(sender);
    //qryUser.Locate('FID',GetNextID(qryOperate,'tUser') - 1,[]);
  end;
  frmShgjDel.Release;
end;

procedure TfrmShgjMain.btnModifyClick(Sender: TObject);
var FID: Integer;
begin
  InitDBcon;
  if  (qryUser.Active= false) or (qryUser.RecordCount= 0) then
  begin
    ShowMsg('提示','请先检索出相应的信息',self);
    Exit;
  end;
  {
  else if Trim(qryUser.FieldByName('FLogoutDate').AsString) <> '' then
  begin
    ShowMsg('提示','用户['+ Trim(qryUser.FieldByName('FCode').AsString) +']已于'+ Trim(qryUser.FieldByName('FLogoutDate').AsString) +'注销！',self);
    Exit;
  end;
  }
  FID := qryUser.FieldByName('FID').AsInteger;
  frmShgjDel := TfrmShgjDel.Create(Application);
  SetSubFormPlace(frmShgjDel);
  frmShgjDel.Caption := 'DLL模块--修改';
  frmShgjDel.m_umState := 'M';
  frmShgjDel.m_cmd := cmd;
  frmShgjDel.m_qryOperate := qryOperate;
  frmShgjDel.m_qryUser := qryUser;
  frmShgjDel.m_cdsOther := cdsOther;
  frmShgjDel.m_User := g_user;

  if frmShgjDel.ShowModal = mrOk then
  begin
    btnSearchClick(sender);
    qryUser.Locate('FID',FID,[]);
  end;
  frmShgjDel.Release;
end;
  function wwChangeUTF8ToWideString(szJson :string):string;
  function XDigit(Ch : AnsiChar) : Integer;
  begin
    if (Ch >= '0') and (Ch <= '9') then
        Result := Ord(Ch) - Ord('0')
    else
        Result := (Ord(Ch) and 15) + 9;
  end;
  function wwUtfToString(szUtf: string):string;
  var
    I:Integer;
    Index:Integer;
    WChar:WideChar;
    WCharWord:Word;
    AChar:AnsiChar;
  begin
    WCharWord:=0;
    for i := 1 to Length(szUtf) do
      begin
        AChar := AnsiChar(szUtf[i]);
        WCharWord := WCharWord + XDigit(AChar) * Ceil(Power(16,4-i));
      end;
    WChar := WideChar(WCharWord);
    Result := WChar;
  end;

var
  Index:Integer;
  HexStr:String;
begin
  szJson := LowerCase(szJson);
  szJson := StringReplace(szJson, '\"', '"', [rfReplaceAll]);
  szJson := StringReplace(szJson, '\r', #10, [rfReplaceAll]);
  szJson := StringReplace(szJson, '\n', #13, [rfReplaceAll]);
  szJson := StringReplace(szJson, '\\', '\', [rfReplaceAll]);

  Index := PosEx('\u',szJson,1);

  while Index>0 do
  begin
    HexStr:=Copy(szJson,Index+2,4);
    wwUtfToString(HexStr);
    szJson := StringReplace(szJson, '\u'+HexStr, wwUtfToString(HexStr),[rfReplaceAll]);
    Index:=PosEx('\u',szJson,1);
  end;

  Result := szJson; // byWarrially
end;

procedure TfrmShgjMain.btnSearchClick(Sender: TObject);
var sqltxt: string;
begin
  //检查输入的内容是否是SQL敏感词语
  if SafeCheck(Self,self) then
  begin
    Exit;
  end;
  //
  qryUser.Connection := con1;
  sqltxt := 'select * from tuser';
  OpenAdoQuery(qryUser,sqltxt);
  ShowMsg('tis',wwChangeUTF8ToWideString(qryUser.FieldByName('FName').AsString),self);
end;

procedure TfrmShgjMain.btnViewClick(Sender: TObject);
var FID: Integer;
begin
  InitDBcon;
  if  (qryUser.Active= false) or (qryUser.RecordCount= 0) then
  begin
    ShowMsg('提示','请先检索出相应的信息',self);
    Exit;
  end;
  FID := qryUser.FieldByName('FID').AsInteger;
  frmShgjDel := TfrmShgjDel.Create(Application);
  SetSubFormPlace(frmShgjDel);
  frmShgjDel.Caption := '用户信息--查看';
  frmShgjDel.m_umState := 'V';
  frmShgjDel.m_cmd := cmd;
  frmShgjDel.m_qryOperate := qryOperate;
  frmShgjDel.m_qryUser := qryUser;
  frmShgjDel.m_cdsOther := cdsOther;
  frmShgjDel.m_User := g_user;

  if frmShgjDel.ShowModal = mrOk then
  begin
    btnSearchClick(sender);
    qryUser.Locate('FID',FID,[]);
  end;
  frmShgjDel.Release;
end;

procedure TfrmShgjMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure TfrmShgjMain.FormCreate(Sender: TObject);
  var
  sDir, sPath,connTmp: string;
begin
  g_Con := tmp_g_Con;
  g_User := tmp_g_User;
  g_moduleid := tmp_g_moduleid;
  Font.Charset := GB2312_CHARSET;
  Font.Size := 9;
  InitDBcon;
  InitModuleLimit(qryOperate,Self,g_moduleid,g_user);

  //连接ACCESS数据库
  {getdir(0, sPath);
  sDir := ExtractFilePath(Application.ExeName);
  chDir(sDir); // 设置工作目录为程序目录。
  SetCurrentDir(sDir);
  connTmp := 'Provider=Microsoft.ACE.OLEDB.12.0;Data Source=' + sDir + '\SHGJ.accdb;Persist Security Info=False';
  con1.ConnectionString := connTmp;
  con1.Open;
  }
end;

procedure TfrmShgjMain.FormDestroy(Sender: TObject);
begin
  SendMessage(Application.MainForm.Handle, WM_USER_DLLFORMEXIT, integer(PCHAR(g_moduleid)), 0);
end;

procedure TfrmShgjMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    btnSearchClick(Sender);
  end;
end;

procedure TfrmShgjMain.FormShow(Sender: TObject);
begin
  btnSearch.SetFocus;
end;

procedure TfrmShgjMain.InitDBcon;
begin
  if qryUser.Connection = nil then
    qryUser.Connection := g_con;
  if cdsOther.Connection = nil then
    cdsOther.Connection := g_con;
  if qryOperate.Connection = nil then
    qryOperate.Connection := g_con;
  if cmd.Connection = nil then
    cmd.Connection := g_con;
end;


end.
