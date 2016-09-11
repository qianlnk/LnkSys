unit uGcysMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB,MyPub,uMessage,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TfrmGcysMain = class(TForm)
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
  frmGcysMain: TfrmGcysMain;

implementation

{$R *.dfm}

uses uGcysSub, uGcysDel;
procedure TfrmGcysMain.btnAddClick(Sender: TObject);
begin
  frmGcysSub := TfrmGcysSub.Create(Application);
  SetSubFormPlace(frmGcysSub);
  frmGcysSub.Caption := 'DLL模块--增加';
  frmGcysSub.m_umState := 'A';
  frmGcysSub.m_cmd := cmd;
  frmGcysSub.m_qryOperate := qryOperate;
  frmGcysSub.m_qryUser := qryUser;
  frmGcysSub.m_cdsOther := cdsOther;
  frmGcysSub.m_User := g_user;

  if frmGcysSub.ShowModal = mrOk then
  begin
    btnSearchClick(sender);
    //qryUser.Locate('FID',GetNextID(qryOperate,'tUser') - 1,[]);
  end;
  frmGcysSub.Release;
end;

procedure TfrmGcysMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmGcysMain.btnDeleteClick(Sender: TObject);
begin
  frmGcysDel := TfrmGcysDel.Create(Application);
  PutFormCenter(frmGcysDel,Self);
  frmGcysDel.Caption := 'DLL模块--删除';
  frmGcysDel.m_cmd := cmd;
  frmGcysDel.m_qryOperate := qryOperate;
  frmGcysDel.m_qryUser := qryUser;
  frmGcysDel.m_cdsOther := cdsOther;
  frmGcysDel.m_User := g_user;

  if frmGcysDel.ShowModal = mrOk then
  begin
    btnSearchClick(sender);
    //qryUser.Locate('FID',GetNextID(qryOperate,'tUser') - 1,[]);
  end;
  frmGcysDel.Release;
end;

procedure TfrmGcysMain.btnModifyClick(Sender: TObject);
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
  frmGcysDel := TfrmGcysDel.Create(Application);
  SetSubFormPlace(frmGcysDel);
  frmGcysDel.Caption := 'DLL模块--修改';
  frmGcysDel.m_umState := 'M';
  frmGcysDel.m_cmd := cmd;
  frmGcysDel.m_qryOperate := qryOperate;
  frmGcysDel.m_qryUser := qryUser;
  frmGcysDel.m_cdsOther := cdsOther;
  frmGcysDel.m_User := g_user;

  if frmGcysDel.ShowModal = mrOk then
  begin
    btnSearchClick(sender);
    qryUser.Locate('FID',FID,[]);
  end;
  frmGcysDel.Release;
end;

procedure TfrmGcysMain.btnSearchClick(Sender: TObject);
begin
  //检查输入的内容是否是SQL敏感词语
  if SafeCheck(Self,self) then
  begin
    Exit;
  end;
  //
end;

procedure TfrmGcysMain.btnViewClick(Sender: TObject);
var FID: Integer;
begin
  InitDBcon;
  if  (qryUser.Active= false) or (qryUser.RecordCount= 0) then
  begin
    ShowMsg('提示','请先检索出相应的信息',self);
    Exit;
  end;
  FID := qryUser.FieldByName('FID').AsInteger;
  frmGcysDel := TfrmGcysDel.Create(Application);
  SetSubFormPlace(frmGcysDel);
  frmGcysDel.Caption := '用户信息--查看';
  frmGcysDel.m_umState := 'V';
  frmGcysDel.m_cmd := cmd;
  frmGcysDel.m_qryOperate := qryOperate;
  frmGcysDel.m_qryUser := qryUser;
  frmGcysDel.m_cdsOther := cdsOther;
  frmGcysDel.m_User := g_user;

  if frmGcysDel.ShowModal = mrOk then
  begin
    btnSearchClick(sender);
    qryUser.Locate('FID',FID,[]);
  end;
  frmGcysDel.Release;
end;

procedure TfrmGcysMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure TfrmGcysMain.FormCreate(Sender: TObject);
begin
  g_Con := tmp_g_Con;
  g_User := tmp_g_User;
  g_moduleid := tmp_g_moduleid;
  Font.Charset := GB2312_CHARSET;
  Font.Size := 9;
  InitDBcon;
  InitModuleLimit(qryOperate,Self,g_moduleid,g_user);
end;

procedure TfrmGcysMain.FormDestroy(Sender: TObject);
begin
  SendMessage(Application.MainForm.Handle, WM_USER_DLLFORMEXIT, integer(PCHAR(g_moduleid)), 0);
end;

procedure TfrmGcysMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    btnSearchClick(Sender);
  end;
end;

procedure TfrmGcysMain.FormShow(Sender: TObject);
begin
  btnSearch.SetFocus;
end;

procedure TfrmGcysMain.InitDBcon;
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
