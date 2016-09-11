unit uQxglMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Data.Win.ADODB,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.ToolWin, Vcl.ActnMan,
  Vcl.ActnCtrls, Vcl.ActnMenus, Vcl.Grids, Vcl.DBGrids;

type
  TFrmQxgl = class(TForm)
    pnl1: TPanel;
    btnAdd: TBitBtn;
    btnDelete: TBitBtn;
    btnModify: TBitBtn;
    pnlSearchOption: TPanel;
    dbgrd1: TDBGrid;
    btnView: TBitBtn;
    btnMenu: TBitBtn;
    btnLimit: TBitBtn;
    cmd: TADOCommand;
    cdsOther: TADODataSet;
    dsUser: TDataSource;
    qryUser: TADOQuery;
    lbl1: TLabel;
    edtCode: TEdit;
    lbl2: TLabel;
    edtName: TEdit;
    btnSearch: TBitBtn;
    qryOperate: TADOQuery;
    chkIsLoginOut: TCheckBox;
    btnClose: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnMenuClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure InitDBcon;
    procedure btnAddClick(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
    procedure btnModifyClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnLimitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    g_user : Integer;
    g_moduleid : string;
    g_con: TADOConnection;
  end;

var
  tmp_g_Con: TAdoConnection;
  tmp_g_User: Integer;
  tmp_g_moduleid: string;
  FrmQxgl: TFrmQxgl;

implementation

{$R *.dfm}
uses MyPub,uMessage, uMenu, uUserInfo, uLimit;

procedure TFrmQxgl.InitDBcon;
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
procedure TFrmQxgl.btnAddClick(Sender: TObject);
begin
  InitDBcon;
  frmUserInfo := TfrmUserInfo.Create(Application);
  SetSubFormPlace(frmUserInfo);
  frmUserInfo.Caption := '用户信息--增加';
  frmUserInfo.m_umState := 'A';
  frmUserInfo.m_cmd := cmd;
  frmUserInfo.m_qryOperate := qryOperate;
  frmUserInfo.m_qryUser := qryUser;
  frmUserInfo.m_cdsOther := cdsOther;
  frmUserInfo.m_User := g_user;

  if frmUserInfo.ShowModal = mrOk then
  begin
    btnSearchClick(sender);
    qryUser.Locate('FID',GetNextID(qryOperate,'tUser') - 1,[]);
  end;
  frmUserInfo.Release;
end;

procedure TFrmQxgl.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmQxgl.btnDeleteClick(Sender: TObject);
var sLog: string;
begin
  InitDBcon;
  if  (qryUser.Active= false) or (qryUser.RecordCount= 0) then
  begin
    ShowMsg('提示','请先检索出相应的信息',self);
    Exit;
  end
  else if Trim(qryUser.FieldByName('FLogoutDate').AsString) <> '' then
  begin
    ShowMsg('提示','用户['+ Trim(qryUser.FieldByName('FCode').AsString) +']已于'+ Trim(qryUser.FieldByName('FLogoutDate').AsString) +'注销！',self);
    Exit;
  end;

  if ShowMsg('询问','是否注销？',self,2) = mrOK then
  begin
    with cmd do
    begin
      Connection.BeginTrans;
      CommandText := 'update tUser set FLogoutDate = getdate() where FCode = :FCode ';
      Parameters.ParamByName('FCode').Value := qryUser.FieldByName('FCode').AsString;
      Execute;
      Connection.CommitTrans;
    end;
    sLog := '注销用户：' + qryUser.FieldByName('FCode').AsString;
    MakeLog(qryOperate,g_User,'权限管理','注销',sLog);
    btnSearchClick(sender);
  end;
end;

procedure TFrmQxgl.btnLimitClick(Sender: TObject);
begin
  frmLimit := TfrmLimit.Create(Application);
  SetSubFormPlace(frmLimit);
  with frmLimit do
  begin
    qryMenu.Connection := g_con;
    qryUser.Connection := g_con;
    qryOperate.Connection := g_con;
    frmLimit.m_User := g_user;
    Caption := '权限设置';
  end;
  if frmLimit.ShowModal = IDOK then
  begin
    frmLimit.Release;
  end;
end;

procedure TFrmQxgl.btnMenuClick(Sender: TObject);
begin
  frmMenu := TfrmMenu.Create(Application);
  SetSubFormPlace(frmMenu);
  with frmMenu do
  begin
    qryMenu.Connection := g_con;
    frmMenu.m_user := g_user;
  end;
  if frmMenu.ShowModal = IDOK then
  begin
    frmMenu.Release;
  end;

end;

procedure TFrmQxgl.btnModifyClick(Sender: TObject);
var FID: Integer;
begin
  InitDBcon;
  if  (qryUser.Active= false) or (qryUser.RecordCount= 0) then
  begin
    ShowMsg('提示','请先检索出相应的信息',self);
    Exit;
  end
  else if Trim(qryUser.FieldByName('FLogoutDate').AsString) <> '' then
  begin
    ShowMsg('提示','用户['+ Trim(qryUser.FieldByName('FCode').AsString) +']已于'+ Trim(qryUser.FieldByName('FLogoutDate').AsString) +'注销！',self);
    Exit;
  end;
  FID := qryUser.FieldByName('FID').AsInteger;
  frmUserInfo := TfrmUserInfo.Create(Application);
  SetSubFormPlace(frmUserInfo);
  frmUserInfo.Caption := '用户信息--修改';
  frmUserInfo.m_umState := 'M';
  frmUserInfo.m_cmd := cmd;
  frmUserInfo.m_qryOperate := qryOperate;
  frmUserInfo.m_qryUser := qryUser;
  frmUserInfo.m_cdsOther := cdsOther;
  frmUserInfo.m_User := g_user;

  if frmUserInfo.ShowModal = mrOk then
  begin
    btnSearchClick(sender);
    qryUser.Locate('FID',FID,[]);
  end;
  frmUserInfo.Release;
end;

procedure TFrmQxgl.btnSearchClick(Sender: TObject);
var sqltxt: widestring;
begin
  InitDBcon;
  sqltxt := 'select * from tUser where 1=1 ';
  if chkIsLoginOut.Checked = False then
  begin
    sqltxt := sqltxt + ' and FLogoutDate is null ';
  end;
  if Trim(edtCode.Text) <> '' then
  begin
    sqltxt := sqltxt + ' and FCode like ''%' + Trim(edtCode.Text) + '%'' ';
  end;
  if Trim(edtName.Text) <> '' then
  begin
    sqltxt := sqltxt + 'and FName like ''%' + Trim(edtName.Text) + '%'' ';
  end;
  sqltxt := sqltxt + 'order by FID DESC';
  OpenAdoQuery(qryUser,sqltxt);
end;

procedure TFrmQxgl.btnViewClick(Sender: TObject);
var FID: Integer;
begin
  InitDBcon;
  if  (qryUser.Active= false) or (qryUser.RecordCount= 0) then
  begin
    ShowMsg('提示','请先检索出相应的信息',self);
    Exit;
  end;
  FID := qryUser.FieldByName('FID').AsInteger;
  frmUserInfo := TfrmUserInfo.Create(Application);
  SetSubFormPlace(frmUserInfo);
  frmUserInfo.Caption := '用户信息--查看';
  frmUserInfo.m_umState := 'V';
  frmUserInfo.m_cmd := cmd;
  frmUserInfo.m_qryOperate := qryOperate;
  frmUserInfo.m_qryUser := qryUser;
  frmUserInfo.m_cdsOther := cdsOther;
  frmUserInfo.m_User := g_user;

  if frmUserInfo.ShowModal = mrOk then
  begin
    btnSearchClick(sender);
    qryUser.Locate('FID',FID,[]);
  end;
  frmUserInfo.Release;
end;

procedure TFrmQxgl.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Action := caFree;
end;

procedure TFrmQxgl.FormCreate(Sender: TObject);
begin
  g_Con := tmp_g_Con;
  g_User := tmp_g_User;
  g_moduleid := tmp_g_moduleid;
  Font.Charset := GB2312_CHARSET;
  Font.Size := 9;
  InitDBcon;
  InitModuleLimit(qryOperate,Self,g_moduleid,g_user);
end;

procedure TFrmQxgl.FormDestroy(Sender: TObject);
begin
  SendMessage(Application.MainForm.Handle, WM_USER_DLLFORMEXIT, integer(PCHAR(g_moduleid)), 0);
end;

procedure TFrmQxgl.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    btnSearchClick(Sender);
  end;
end;

end.
