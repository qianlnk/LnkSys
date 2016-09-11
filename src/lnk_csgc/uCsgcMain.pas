unit uCsgcMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB,MyPub,uMessage,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TfrmCsgcMain = class(TForm)
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
  frmCsgcMain: TfrmCsgcMain;

implementation

{$R *.dfm}

uses uCsgcSub, uCsgcDel;
procedure TfrmCsgcMain.btnAddClick(Sender: TObject);
begin
  frmCsgcSub := TfrmCsgcSub.Create(Application);
  SetSubFormPlace(frmCsgcSub);
  frmCsgcSub.Caption := 'DLL模块--增加';
  frmCsgcSub.m_umState := 'A';
  frmCsgcSub.m_cmd := cmd;
  frmCsgcSub.m_qryOperate := qryOperate;
  frmCsgcSub.m_qryUser := qryUser;
  frmCsgcSub.m_cdsOther := cdsOther;
  frmCsgcSub.m_User := g_user;

  if frmCsgcSub.ShowModal = mrOk then
  begin
    btnSearchClick(sender);
    //qryUser.Locate('FID',GetNextID(qryOperate,'tUser') - 1,[]);
  end;
  frmCsgcSub.Release;
end;

procedure TfrmCsgcMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCsgcMain.btnDeleteClick(Sender: TObject);
begin
  frmCsgcDel := TfrmCsgcDel.Create(Application);
  PutFormCenter(frmCsgcDel,Self);
  frmCsgcDel.Caption := 'DLL模块--删除';
  frmCsgcDel.m_cmd := cmd;
  frmCsgcDel.m_qryOperate := qryOperate;
  frmCsgcDel.m_qryUser := qryUser;
  frmCsgcDel.m_cdsOther := cdsOther;
  frmCsgcDel.m_User := g_user;

  if frmCsgcDel.ShowModal = mrOk then
  begin
    btnSearchClick(sender);
    //qryUser.Locate('FID',GetNextID(qryOperate,'tUser') - 1,[]);
  end;
  frmCsgcDel.Release;
end;

procedure TfrmCsgcMain.btnModifyClick(Sender: TObject);
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
  frmCsgcDel := TfrmCsgcDel.Create(Application);
  SetSubFormPlace(frmCsgcDel);
  frmCsgcDel.Caption := 'DLL模块--修改';
  frmCsgcDel.m_umState := 'M';
  frmCsgcDel.m_cmd := cmd;
  frmCsgcDel.m_qryOperate := qryOperate;
  frmCsgcDel.m_qryUser := qryUser;
  frmCsgcDel.m_cdsOther := cdsOther;
  frmCsgcDel.m_User := g_user;

  if frmCsgcDel.ShowModal = mrOk then
  begin
    btnSearchClick(sender);
    qryUser.Locate('FID',FID,[]);
  end;
  frmCsgcDel.Release;
end;

procedure TfrmCsgcMain.btnSearchClick(Sender: TObject);
begin
  //检查输入的内容是否是SQL敏感词语
  if SafeCheck(Self,self) then
  begin
    Exit;
  end;
  //
end;

procedure TfrmCsgcMain.btnViewClick(Sender: TObject);
var FID: Integer;
begin
  InitDBcon;
  if  (qryUser.Active= false) or (qryUser.RecordCount= 0) then
  begin
    ShowMsg('提示','请先检索出相应的信息',self);
    Exit;
  end;
  FID := qryUser.FieldByName('FID').AsInteger;
  frmCsgcDel := TfrmCsgcDel.Create(Application);
  SetSubFormPlace(frmCsgcDel);
  frmCsgcDel.Caption := '用户信息--查看';
  frmCsgcDel.m_umState := 'V';
  frmCsgcDel.m_cmd := cmd;
  frmCsgcDel.m_qryOperate := qryOperate;
  frmCsgcDel.m_qryUser := qryUser;
  frmCsgcDel.m_cdsOther := cdsOther;
  frmCsgcDel.m_User := g_user;

  if frmCsgcDel.ShowModal = mrOk then
  begin
    btnSearchClick(sender);
    qryUser.Locate('FID',FID,[]);
  end;
  frmCsgcDel.Release;
end;

procedure TfrmCsgcMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure TfrmCsgcMain.FormCreate(Sender: TObject);
begin
  g_Con := tmp_g_Con;
  g_User := tmp_g_User;
  g_moduleid := tmp_g_moduleid;
  Font.Charset := GB2312_CHARSET;
  Font.Size := 9;
  InitDBcon;
  InitModuleLimit(qryOperate,Self,g_moduleid,g_user);
end;

procedure TfrmCsgcMain.FormDestroy(Sender: TObject);
begin
  SendMessage(Application.MainForm.Handle, WM_USER_DLLFORMEXIT, integer(PCHAR(g_moduleid)), 0);
end;

procedure TfrmCsgcMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    btnSearchClick(Sender);
  end;
end;

procedure TfrmCsgcMain.FormShow(Sender: TObject);
begin
  btnSearch.SetFocus;
end;

procedure TfrmCsgcMain.InitDBcon;
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
