unit uXtdmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB,MyPub,uMessage,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TfrmXtdmMain = class(TForm)
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
    lbl1: TLabel;
    cbbType: TComboBox;
    chkExpeired: TCheckBox;
    procedure InitDBcon;  //初始化ADO组件的链接
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnSearchClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
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
  frmXtdmMain: TfrmXtdmMain;

implementation

{$R *.dfm}

uses uXtdmSub;
procedure TfrmXtdmMain.btnAddClick(Sender: TObject);
begin
  frmXtdmSub := TfrmXtdmSub.Create(Application);
  SetSubFormPlace(frmXtdmSub);
  frmXtdmSub.Caption := '系统代码--增加';
  frmXtdmSub.m_umState := 'A';
  frmXtdmSub.m_cmd := cmd;
  frmXtdmSub.m_qryOperate := qryOperate;
  frmXtdmSub.m_qryUser := qryUser;
  frmXtdmSub.m_cdsOther := cdsOther;
  frmXtdmSub.m_User := g_user;

  if frmXtdmSub.ShowModal = mrOk then
  begin
    cbbType.Clear;
    FormShow(Sender);
    btnSearchClick(sender);
    qryUser.Locate('FID',GetNextID(qryOperate,'tUser') - 1,[]);
  end;
  frmXtdmSub.Release;
end;

procedure TfrmXtdmMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmXtdmMain.btnModifyClick(Sender: TObject);
var FID: Integer;
begin
  if  (qryUser.Active= false) or (qryUser.RecordCount= 0) then
  begin
    ShowMsg('提示','请先检索出相应的信息',self);
    Exit;
  end;
  FID := qryUser.FieldByName('FID').AsInteger;
  frmXtdmSub := TfrmXtdmSub.Create(Application);
  SetSubFormPlace(frmXtdmSub);
  frmXtdmSub.Caption := '系统代码--修改';
  frmXtdmSub.m_umState := 'M';
  frmXtdmSub.m_cmd := cmd;
  frmXtdmSub.m_qryOperate := qryOperate;
  frmXtdmSub.m_qryUser := qryUser;
  frmXtdmSub.m_cdsOther := cdsOther;
  frmXtdmSub.m_User := g_user;

  if frmXtdmSub.ShowModal = mrOk then
  begin
    cbbType.Clear;
    FormShow(Sender);
    btnSearchClick(sender);
    qryUser.Locate('FID',FID,[]);
  end;
  frmXtdmSub.Release;
end;

procedure TfrmXtdmMain.btnSearchClick(Sender: TObject);
var sqltxt:string;
begin
  sqltxt := 'select FID,FType,FValue,FSort from tCodeList where 1 = 1 ';
  if Trim(cbbType.Text) <> '' then
  begin
    sqltxt := sqltxt + ' and FType = ''' + Trim(cbbType.Text) + ''' ';
  end;
  if not chkExpeired.Checked then
  begin
    sqltxt := sqltxt + ' and FType <> ''True''';
  end;
  OpenAdoQuery(qryUser,sqltxt);
end;

procedure TfrmXtdmMain.btnViewClick(Sender: TObject);
var FID: Integer;
begin
  if  (qryUser.Active= false) or (qryUser.RecordCount= 0) then
  begin
    ShowMsg('提示','请先检索出相应的信息',self);
    Exit;
  end;
  FID := qryUser.FieldByName('FID').AsInteger;
  frmXtdmSub := TfrmXtdmSub.Create(Application);
  SetSubFormPlace(frmXtdmSub);
  frmXtdmSub.Caption := '系统代码--查看';
  frmXtdmSub.m_umState := 'V';
  frmXtdmSub.m_cmd := cmd;
  frmXtdmSub.m_qryOperate := qryOperate;
  frmXtdmSub.m_qryUser := qryUser;
  frmXtdmSub.m_cdsOther := cdsOther;
  frmXtdmSub.m_User := g_user;

  if frmXtdmSub.ShowModal = mrOk then
  begin
    cbbType.Clear;
    FormShow(Sender);
    btnSearchClick(sender);
    qryUser.Locate('FID',FID,[]);
  end;
  frmXtdmSub.Release;
end;

procedure TfrmXtdmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure TfrmXtdmMain.FormCreate(Sender: TObject);
begin
  g_Con := tmp_g_Con;
  g_User := tmp_g_User;
  g_moduleid := tmp_g_moduleid;
  Font.Charset := GB2312_CHARSET;
  Font.Size := 9;
  InitDBcon;
  InitModuleLimit(qryOperate,Self,g_moduleid,g_user);
end;

procedure TfrmXtdmMain.FormDestroy(Sender: TObject);
begin
  SendMessage(Application.MainForm.Handle, WM_USER_DLLFORMEXIT, integer(PCHAR(g_moduleid)), 0);
end;

procedure TfrmXtdmMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    btnSearchClick(Sender);
  end;
end;

procedure TfrmXtdmMain.FormShow(Sender: TObject);
var sqltxt:string;
begin
  btnSearch.SetFocus;
  //加载代码类型
  sqltxt := 'select distinct FType from tCodeList';
  OpenAdoQuery(qryOperate,sqltxt);
  cbbType.Items.Add('');
  AddItemToCommbox(qryOperate,'FType',cbbType,False);
end;

procedure TfrmXtdmMain.InitDBcon;
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
