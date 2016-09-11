unit uLimit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Data.Win.ADODB, Data.DB,Mypub, Vcl.ImgList, Vcl.Grids,
  Vcl.DBGrids, Vcl.Menus;

type
  TfrmLimit = class(TForm)
    pnl4: TPanel;
    btnSave: TBitBtn;
    btnClose: TBitBtn;
    pgcLimit: TPageControl;
    pgcUser: TPageControl;
    tsLimit: TTabSheet;
    tsUser: TTabSheet;
    tvMenu: TTreeView;
    dsMenu3: TADODataSet;
    dsMenu2: TADODataSet;
    dsMenu1: TADODataSet;
    qryMenu: TADOQuery;
    il1: TImageList;
    dbgrdUser: TDBGrid;
    qryUser: TADOQuery;
    dsUser: TDataSource;
    qryOperate: TADOQuery;
    chkChoose: TCheckBox;
    pmUser: TPopupMenu;
    pmMenu: TPopupMenu;
    NShowLimit: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure CreateMenu;
    procedure dbgrdUserDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dbgrdUserCellClick(Column: TColumn);
    procedure dbgrdUserTitleClick(Column: TColumn);
    procedure btnCloseClick(Sender: TObject);
    procedure tvMenuClick(Sender: TObject);
    procedure tvMenuExpanded(Sender: TObject; Node: TTreeNode);
    procedure tvMenuCollapsed(Sender: TObject; Node: TTreeNode);
    procedure btnSaveClick(Sender: TObject);
    procedure NShowLimitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    m_User :Integer;
  end;

var
  frmLimit: TfrmLimit;

implementation

{$R *.dfm}

uses uMenu;

procedure TfrmLimit.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfrmLimit.btnSaveClick(Sender: TObject);
var sqltxt: string;
    sLimit: string; //选中的菜单
    sUser: string;  //选中的用户
    i: Integer;
    sLog: string;
begin
  for i := 0 to tvMenu.Items.Count - 1 do
  begin
    if tvMenu.Items[i].StateIndex = 2 then
    begin
      if sLimit = '' then
      begin
        sLimit := '''' + tvMenu.Items[i].Text + ''' ';
      end
      else
      begin
        sLimit := sLimit + ',''' + tvMenu.Items[i].Text + ''' ';
      end;
    end;
  end;
  if   sLimit = '' then
  begin
      sLimit := '''''';
  end;
  try
    sqltxt := 'select (CONCAT(''['',FCode,'']'',FName)) as FUser from tUser where FIsCheck = ''True'' ';
    OpenAdoQuery(qryOperate,sqltxt);
    sUser := wm_concat(qryOperate,'FUser');
    if sUser = '' then
    begin
      ShowMsg('提示','请选择要赋予权限的用户！',Self);
      Exit;
    end;
    //清除以前的权限
    sqltxt := 'delete from tLimit where FUserID in(select FID from tUser where FIsCheck = ''True'')';
    ExecAdoQuery(qryOperate,sqltxt);
    //重新分配权限
    sqltxt := 'Insert into tLimit(FUserID,FMenuID) '
            + 'select b.FID,a.FID from tMenu a,tUser b '
            + 'where a.FName in(' + sLimit + ') and b.FIsCheck = ''True'' ';
    ExecAdoQuery(qryOperate,sqltxt);

    sLog := '给用户:{' + sUser + '}赋权限：['
          + stringReplace(sLimit,'''','"',[rfReplaceAll]) +']';
    MakeLog(qryOperate,m_User,'权限管理','权限设置',sLog);
    ModalResult := mrOk;
  except
    on E: Exception do
      ShowMsg('错误','错误是' + E.ClassName + '!  错误信息' + E.Message,self);
  end;
end;

procedure TfrmLimit.CreateMenu;
var sqlStr : string;
    i,j,k : Integer;
    mnuRoot, mnuSecond, mnuThird: TTreeNode;
begin
  dsMenu1.Connection := qryMenu.Connection;
  dsMenu2.Connection := qryMenu.Connection;
  dsMenu3.Connection := qryMenu.Connection;
  tvMenu.Items.Clear;
  sqlStr := 'select FID,FName from tmenu where FLevel = 1 order by FSort';
  OpenAdoDataSet(dsMenu1,sqlStr);
  mnuRoot := nil;
  for i := 0 to dsMenu1.RecordCount - 1 do
  begin
    mnuSecond := tvMenu.Items.Add(mnuRoot,dsMenu1.FieldByName('FName').AsString);
    sqlStr := 'select FID,FName from tmenu where FLevel = 2 and FFID = '''
            + dsMenu1.FieldByName('FID').AsString + ''' order by FSort';
    OpenAdoDataSet(dsMenu2,sqlStr);

    for j := 0 to dsMenu2.RecordCount - 1 do
    begin
      mnuThird := tvMenu.Items.AddChild(mnuSecond,dsMenu2.FieldByName('FName').AsString);
      sqlStr := 'select FID,FName from tmenu where FLevel = 3 and FFID = '''
            + dsMenu2.FieldByName('FID').AsString + ''' order by FSort';
      OpenAdoDataSet(dsMenu3,sqlStr);
      for k := 0 to dsMenu3.RecordCount - 1 do
      begin
        tvMenu.Items.AddChild(mnuThird,dsMenu3.FieldByName('FName').AsString);
        dsMenu3.Next;
      end;
      dsMenu2.Next;
    end;
      dsMenu1.Next;
  end;
  ExpandTvItem(tvMenu);
end;
procedure TfrmLimit.dbgrdUserCellClick(Column: TColumn);
var FCode: string;
begin
  if Column.Title.Caption = ' ' then
  begin
    FCode := qryUser.FieldByName('FCode').AsString;
    ExecAdoQuery(qryOperate,'update tUser set FIsCheck = ~FIsCheck where FCode = '''+ qryUser.FieldByName('FCode').AsString + ''' ');
    OpenAdoQuery(qryUser,'select FID,FIsCheck,FCode,FName from tUser where FLogoutDate is null order by FID DESC');
    qryUser.Locate('FCode',FCode,[]);
  end;
end;

procedure TfrmLimit.dbgrdUserDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
const
 CtrlState: array[Boolean] of Integer = (DFCS_BUTTONCHECK, DFCS_BUTTONCHECK or DFCS_CHECKED);
 begin
 if Column.Field.DataType = ftBoolean then
 begin
 dbgrdUser.Canvas.CleanupInstance;
  dbgrdUser.Canvas.Refresh;
 dbgrdUser.Canvas.FillRect(Rect);
 DrawFrameControl(dbgrdUser.Canvas.Handle,Rect, DFC_BUTTON, CtrlState[Column.Field.AsBoolean]);
 end;
end;

procedure TfrmLimit.dbgrdUserTitleClick(Column: TColumn);
var FCode: string;
begin
  FCode := qryUser.FieldByName('FCode').AsString;
 if (Column.Title.Caption = ' ') and (dbgrdUser.Tag = 0) then
  begin
    ExecAdoQuery(qryOperate,'update tUser set FIsCheck = ''True'' ');
    OpenAdoQuery(qryUser,'select FID,FIsCheck,FCode,FName from tUser where FLogoutDate is null order by FID DESC');
    dbgrdUser.Tag := 1;
  end
  else
  begin
  begin
    ExecAdoQuery(qryOperate,'update tUser set FIsCheck = ''False'' ');
    OpenAdoQuery(qryUser,'select FID,FIsCheck,FCode,FName from tUser where FLogoutDate is null order by FID DESC');
    dbgrdUser.Tag := 0;
  end
  end;
  qryUser.Locate('FCode',FCode,[]);
end;

procedure TfrmLimit.FormShow(Sender: TObject);
begin
  CreateMenu;
  DrowChkBoxForTv(tvMenu);
  chkChoose.SetFocus;
  ExecAdoQuery(qryOperate,'update tUser set FIsCheck = ''False''');
  OpenAdoQuery(qryUser,'select FID,FIsCheck,FCode,FName from tUser where FLogoutDate is null order by FID DESC');
end;

procedure TfrmLimit.NShowLimitClick(Sender: TObject);
var sqltxt: string;
    sHadLimit: string;
    i: Integer;
begin
  DrowChkBoxForTv(tvMenu);
  sqltxt := 'select FName from tMenu where FID in(select FMenuID from tLimit where FUserID = '
          + qryUser.FieldByName('FID').AsString +')';
  OpenAdoQuery(qryOperate,sqltxt);
  sHadLimit := wm_concat(qryOperate,'FName');
  for I := 0 to tvMenu.Items.Count - 1 do
  begin
    if (Pos(tvMenu.Items[i].Text,sHadLimit) > 0) then
    begin
      tvMenu.Items[i].StateIndex := 2;
    end;
  end;

end;

procedure TfrmLimit.tvMenuClick(Sender: TObject);
begin
  if   self.Tag = 2 then
  begin
      self.Tag := 1;
      Exit;
  end;
  if tvMenu.Selected.StateIndex <>1 then //不被选中，则其所有下级节点不能选中
  begin
    tvMenu.Selected.StateIndex := 1;
    SetTvNodeStateIndex(tvMenu.Selected.getFirstChild,1);
  end
  else //被选中则其所有上级节点要选中
  begin
    tvMenu.Selected.StateIndex := 2;
    if tvMenu.Selected.Parent <> nil then
    begin
      tvMenu.Selected.Parent.StateIndex := 2;
      if tvMenu.Selected.Parent.Parent <> nil then
      begin
        tvMenu.Selected.Parent.Parent.StateIndex := 2;
      end;
    end;
    //全选下级菜单
    if chkChoose.Checked = True then
    begin
      SetTvNodeStateIndex(tvMenu.Selected.getFirstChild,2);
    end;
  end;
end;

procedure TfrmLimit.tvMenuCollapsed(Sender: TObject; Node: TTreeNode);
begin
  self.Tag := 2;
end;

procedure TfrmLimit.tvMenuExpanded(Sender: TObject; Node: TTreeNode);
begin
  self.Tag := 2;
end;

end.
