unit uXtrzMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB,MyPub,uMessage,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TfrmXtrzMain = class(TForm)
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
    edtUser: TEdit;
    lbl2: TLabel;
    dtpDate: TDateTimePicker;
    lbl3: TLabel;
    edtModule: TEdit;
    lbl4: TLabel;
    cbbType: TComboBox;
    procedure InitDBcon;  //初始化ADO组件的链接
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnSearchClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dtpDateChange(Sender: TObject);
    procedure dtpDateKeyPress(Sender: TObject; var Key: Char);
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
  frmXtrzMain: TfrmXtrzMain;

implementation

{$R *.dfm}

uses uXtrzSub;
procedure TfrmXtrzMain.btnAddClick(Sender: TObject);
begin
  frmXtrzSub := TfrmXtrzSub.Create(Application);
  SetSubFormPlace(frmXtrzSub);
  frmXtrzSub.Caption := '用户信息--增加';
  frmXtrzSub.m_umState := 'A';
  frmXtrzSub.m_cmd := cmd;
  frmXtrzSub.m_qryOperate := qryOperate;
  frmXtrzSub.m_qryUser := qryUser;
  frmXtrzSub.m_cdsOther := cdsOther;
  frmXtrzSub.m_User := g_user;

  if frmXtrzSub.ShowModal = mrOk then
  begin
    btnSearchClick(sender);
    //qryUser.Locate('FID',GetNextID(qryOperate,'tUser') - 1,[]);
  end;
  frmXtrzSub.Release;
end;

procedure TfrmXtrzMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmXtrzMain.btnSearchClick(Sender: TObject);
var sqltxt: string;
begin
  sqltxt := 'select a.FUserID,a.FDate,a.FModule,a.FType,a.FRemark,b.FName from tLog a '
          + 'left join tUser b on a.FUserID = b.FID where 1 = 1';
  if dtpDate.Format <> ' ' then
  begin
    sqltxt := sqltxt + 'and a.FDate between '''+ FormatDateTime('yyyy-mm-dd',dtpDate.Date)
            + ' 00:00:00'' and ''' + FormatDateTime('yyyy-mm-dd',dtpDate.Date) +' 23:59:59'' ';
  end;
  if Trim(edtModule.Text) <> '' then
  begin
    sqltxt := sqltxt + 'and a.FModule = ''' + Trim(edtModule.Text) + '''';
  end;
  if Trim(cbbType.Text) <> '' then
  begin
    sqltxt := sqltxt + 'and a.FType = ''' + Trim(cbbType.Text) + '''';
  end;
  if trim(edtUser.Text) <> '' then
  begin
    sqltxt := sqltxt + 'and FUserID in(select FID from tUser where FName like ''%'
          + edtUser.Text + '%'') ';
  end;

  OpenAdoQuery(qryUser,sqltxt);
//
end;

procedure TfrmXtrzMain.dtpDateChange(Sender: TObject);
begin
  dtpDate.Format:='';
end;

procedure TfrmXtrzMain.dtpDateKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #8 then
  begin
    dtpDate.Format:= ' ';
  end;
end;

procedure TfrmXtrzMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure TfrmXtrzMain.FormCreate(Sender: TObject);
begin
  g_Con := tmp_g_Con;
  g_User := tmp_g_User;
  g_moduleid := tmp_g_moduleid;
  Font.Charset := GB2312_CHARSET;
  Font.Size := 9;
  InitDBcon;
  InitModuleLimit(qryOperate,Self,g_moduleid,g_user);
end;

procedure TfrmXtrzMain.FormDestroy(Sender: TObject);
begin
  SendMessage(Application.MainForm.Handle, WM_USER_DLLFORMEXIT, integer(PCHAR(g_moduleid)), 0);
end;

procedure TfrmXtrzMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    btnSearchClick(Sender);
  end;
end;

procedure TfrmXtrzMain.FormShow(Sender: TObject);
var sqltxt:string;
begin
  btnSearch.SetFocus;
  //加载操作类型
  sqltxt := 'select distinct FType from tLog';
  OpenAdoQuery(qryOperate,sqltxt);
  cbbType.Items.Add('');
  AddItemToCommbox(qryOperate,'FType',cbbType,False);

end;

procedure TfrmXtrzMain.InitDBcon;
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
