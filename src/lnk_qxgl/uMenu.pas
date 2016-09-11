unit uMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ComCtrls, Vcl.ExtCtrls,MyPub, Vcl.Menus, Vcl.ImgList,uMessage;

type
  TfrmMenu = class(TForm)
    pnl2: TPanel;
    pnl1: TPanel;
    pnl3: TPanel;
    pnl4: TPanel;
    tvMenu: TTreeView;
    lbl1: TLabel;
    edtMenuName: TEdit;
    chkIsEnd: TCheckBox;
    cbbModule: TComboBox;
    lblFF: TLabel;
    edtFMenu: TEdit;
    chkIsFirstMenu: TCheckBox;
    lbl2: TLabel;
    dsMenu2: TADODataSet;
    qryMenu: TADOQuery;
    dsMenu1: TADODataSet;
    dsMenu3: TADODataSet;
    btnAdd: TBitBtn;
    lbl3: TLabel;
    edtSort: TEdit;
    btnClose: TBitBtn;
    cmd: TADOCommand;
    pmTree: TPopupMenu;
    nDel: TMenuItem;
    il1: TImageList;
    procedure CreateMenu;
    procedure FormShow(Sender: TObject);
    procedure chkIsFirstMenuClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure chkIsEndClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure tvMenuClick(Sender: TObject);
    procedure nDelClick(Sender: TObject); //形成菜单
  private
    { Private declarations }
  public
    { Public declarations }
    m_user :Integer;
  end;

var
  frmMenu: TfrmMenu;

implementation

{$R *.dfm}

procedure TfrmMenu.btnAddClick(Sender: TObject);
var FID,FFID:Integer;
    FModuleID:Integer;
    FIsEnd: Integer;
    FLevel: Integer;
    sqlStr: widestring;
    sLog: widestring;
begin
  cmd.Connection := qryMenu.Connection;
  sqlStr := 'select max(FID) as FID from tMenu';
  OpenAdoQuery(qryMenu,sqlStr);
  FID := qryMenu.FieldByName('FID').AsInteger + 1;
  if chkIsFirstMenu.Checked then
  begin
    FFID := 0;
    FLevel := 1;
  end
  else
  begin
    if edtFMenu.Text = '请从预览菜单中选择' then
    begin
      ShowMsg('提示','请选择上级菜单！',self);
      Exit;
    end;
    sqlStr := 'select FID,Flevel from tMenu where FName = ''' + Trim(edtFMenu.Text) + ''' ';
    OpenAdoQuery(qryMenu,sqlStr);
    FFID := qryMenu.FieldByName('FID').AsInteger;
    FLevel := qryMenu.FieldByName('Flevel').AsInteger + 1;
    if FLevel = 4 then
    begin
      ShowMsg('提示','上级菜单不能为第三级菜单，请重新选择！',self);
      edtFMenu.Text := '请从预览菜单中选择';
      Exit;
    end;
  end;
  if chkIsEnd.Checked then
  begin
    if Trim(cbbModule.Text) = '请选择' then
    begin
      ShowMsg('提示','请选择模块！',self);
      Exit;
    end;
    sqlStr := 'select isnull(FID,0) as FID from tModule where FName = ''' + Trim(cbbModule.Text) + ''' ';
    OpenAdoQuery(qryMenu,sqlStr);
    FModuleID := qryMenu.FieldByName('FID').AsInteger;
    FIsEnd := 1;
  end
  else
  begin
    FModuleID := 0;
    FIsEnd := 0;
  end;
  if Trim(edtMenuName.Text) = '' then
  begin
    ShowMsg('提示','请填写菜单名称！',self);
    Exit;
  end;
  if Trim(edtSort.Text) = '' then
  begin
    ShowMsg('提示','请填写菜单顺序！',self);
    Exit;
  end;
  try
    with cmd do
    begin
      cmd.Connection.BeginTrans;
      CommandText := 'Insert into tMenu(FName, FFID, FIsEnd, FModuleID, FSort, FLevel, FIsExpired) '
                   + 'values(:FName, :FFID, :FIsEnd, :FModuleID, :FSort, :FLevel, :FIsExpired)';
      Parameters.ParamByName('FName').Value :=  trim(edtMenuName.Text);
      Parameters.ParamByName('FFID').Value :=  FFID;
      Parameters.ParamByName('FIsEnd').Value := FIsEnd;
      Parameters.ParamByName('FModuleID').Value :=  FModuleID;
      Parameters.ParamByName('FSort').Value :=  trim(edtSort.Text);
      Parameters.ParamByName('FLevel').Value := FLevel;
      Parameters.ParamByName('FIsExpired').Value := 'False';
      Execute;
      cmd.Connection.CommitTrans;

      sLog := '添加菜单项:{' + trim(edtMenuName.Text) + '}';
      MakeLog(qryMenu,m_User,'权限管理','菜单设置',sLog);
      //ShowMsg('消息','添加成功',self);
      //生成预览效果
      CreateMenu;
      //还原设置界面
      chkIsFirstMenu.Checked := True;
      edtMenuName.Text := '无';
      chkIsEnd.Checked := False;
      chkIsEnd.OnClick(Sender);
      edtMenuName.Clear;
      edtSort.Clear;
    end;
  except
      on E: Exception do
      begin
        cmd.Connection.RollbackTrans;
        ShowMsg('错误','错误是' + E.ClassName + '!  错误信息' + E.Message,self);
      end;
  end;
end;

procedure TfrmMenu.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMenu.chkIsEndClick(Sender: TObject);
var sqlStr: string;
begin
  if chkIsEnd.Checked = False then
  begin
    cbbModule.ItemIndex := 0;
    cbbModule.Enabled := False;
    cbbModule.Clear;
    cbbModule.Items.Add('无');
    cbbModule.ItemIndex := 0;
  end
  else
  begin
    //加载未加入菜单的模块
    sqlStr := 'select FName from tModule where FID not in(select FModuleID from tMenu where FModuleID is not NULL)';
    OpenAdoQuery(qryMenu,sqlStr);
    cbbModule.Clear;
    cbbModule.Items.Add('请选择');
    AddItemToCommbox(qryMenu,'FName',cbbModule,False);
    cbbModule.ItemIndex := 0;
    cbbModule.Enabled := True;
  end;
end;

procedure TfrmMenu.chkIsFirstMenuClick(Sender: TObject);
begin
  if chkIsFirstMenu.Checked then
  begin
    edtFMenu.Text := '无';
  end
  else
  begin
    edtFMenu.Text := '请从预览菜单中选择';
  end;
end;

procedure TfrmMenu.CreateMenu;
var sqlStr : string;
    i,j,k : Integer;
    mnuRoot, mnuSecond, mnuThird: TTreeNode;
begin
  dsMenu1.Connection := qryMenu.Connection;
  dsMenu2.Connection := qryMenu.Connection;
  dsMenu3.Connection := qryMenu.Connection;
  self.Tag := 0;
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
  self.Tag := 1;
end;

procedure TfrmMenu.FormShow(Sender: TObject);
begin
  CreateMenu;
end;

procedure TfrmMenu.nDelClick(Sender: TObject);
var DelMenu: string;
var sqltxt: string;
    sLog : string;
begin
  GetTvTextAndChild(DelMenu,tvMenu.Selected);
  {if (Pos('系统设置',DelMenu) > 0) then
  begin
    ShowMsg('错误','不允许删除系统设置及其子菜单',self);
    Exit;
  end;
  if (tvMenu.Selected.Parent.Text = '系统设置') then
  begin
    ShowMsg('错误','不允许删除系统设置及其子菜单',self);
    Exit;
  end;
  }
  if (Pos('权限管理',DelMenu) > 0) then
  begin
    ShowMsg('错误','不允许删除菜单项：[权限管理]！',self);
    Exit;
  end;
  if ShowMsg('询问','是否删除菜单项' + DelMenu + '?',self,2) = mrOK then
  begin
    //删除菜单
    sqltxt := 'delete from tMenu where FName in (' + DelMenu + ') ';
    ExecAdoQuery(qryMenu,sqltxt);
    //删除权限表中对应的菜单
    sqltxt := 'delete from tLimit where FMenuID not in (select FID from tMenu) ';
    ExecAdoQuery(qryMenu,sqltxt);
    CreateMenu;
    sLog := '删除菜单项:{' + stringReplace(DelMenu,'''','"',[rfReplaceAll]) +'}';
    MakeLog(qryMenu,m_User,'权限管理','菜单设置',sLog);
  end
  else
  begin
    Exit;
  end;
end;

procedure TfrmMenu.tvMenuClick(Sender: TObject);
begin
  {
  if tvMenu.Selected.StateIndex <>1 then
    tvMenu.Selected.StateIndex := 1
  else
    tvMenu.Selected.StateIndex := 2;
  }
  if self.Tag = 1 then
  begin
    if chkIsFirstMenu.Checked = False then
    begin
      edtFMenu.Text := tvMenu.Selected.Text;
    end;
  end;
end;

end.
