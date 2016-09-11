{**********************************************************************
* 文件名称: uMainForm.pas
* 版本信息：2014.07(lnk)
* 文件描述：
            所有模块编译成dll由该主程序调用
* 创 建 者：qianlnk
* 历史记录：
*           时间            操作者            描述
*           2014.07.19      谢振家            创建
*           2014.10.07      谢振家            添加快捷菜单分组（暂未应用）
***********************************************************************}
unit uMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB,IniFiles,ShellAPI,
  Vcl.Menus, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.ComCtrls,uMessage,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls,
  Vcl.ActnMenus;

type
  //调用dll原型，所有dll必须按照这样的模式创建  详细请参照lnkDemoDll
  //TCreateDllForm = procedure (app: TApplication; AppSession: TSession;
  //AppScreen: TSCreen;adoCon: TAdoConnection;
  //                            sUser: string;var frm:TForm);stdcall;
   TCreateDllForm = procedure (app: TApplication;adoCon: TAdoConnection;
                              nUser: Integer;var frm:TForm);stdcall;
  //模块节点纪录
  moduleRecord = record     //模块节点记录
    ModuleID: string;       //模块代码
    Path: string;           //可执行文件名
    Handle: HMODULE;        //动态联接库句柄
    frm: TForm;             //窗体句柄
  end;
  pModuleRecord = ^moduleRecord;

  TFrmMain = class(TForm)
    ADOCon: TADOConnection;
    MainMenu: TMainMenu;
    NFile: TMenuItem;
    NWindows: TMenuItem;
    NHelp: TMenuItem;
    NLogin: TMenuItem;
    NModifyPsw: TMenuItem;
    NLogout: TMenuItem;
    cdsOther: TADODataSet;
    adsMenu1: TADODataSet;
    adsMenu2: TADODataSet;
    adsMenu3: TADODataSet;
    StatusBar: TStatusBar;
    NCengd: TMenuItem;
    NAllMin: TMenuItem;
    NCloseAll: TMenuItem;
    procedure NLoginClick(Sender: TObject);     //登录
    function GetConnectString(sUser: string; sPwd: string): string;  //获取ini文件记录的连接信息
    procedure FormCreate(Sender: TObject);      //初始化全局变量
    procedure InitMainMenu;                     //初始化菜单
    procedure DelHistoryMenu;                   //删除原有菜单
    procedure MenuClick(Sender: TObject);       //菜单点击事件
    procedure NLogoutClick(Sender: TObject);    //退出
    procedure NModifyPswClick(Sender: TObject); //修改密码
    procedure  RunDllForm(var msg: TMessage);message WM_USER_CALLDLL; //运行一个dll
    procedure ExitDllForm(var msg: TMessage);message WM_USER_DLLFORMEXIT;//退出dll
    function FindModuleRecord(ModuleID: string;
              var tmpModuleRecord: PModuleRecord): boolean;
    procedure FormShow(Sender: TObject);
    procedure ShowLoginForm(var msg: TMessage);message WM_USER_SHOWFORM;  //显示登录对话框
    procedure NCengdClick(Sender: TObject);
    procedure NAllMinClick(Sender: TObject);
    procedure NCloseAllClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    //procedure btnGroupClick(Sender: TObject);
    //procedure CreateMenuGroup(Sender: TObject);//创建菜单分组 测试版
  private
    { Private declarations }
      sDBHost: string;      //主机名
      sDatabase: string;    //数据库名
      abtnGroup: Array[0..15] of TBitBtn;
      const  BTN_NUM = 15;

  public
    { Public declarations }
      m_bLogin: boolean;   //是否登录
      m_Operator: string;  //登录系统的操作者

  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

uses uLogin, MyPub, uModifyPsw;

function TFrmMain.FindModuleRecord(ModuleID: string;
              var tmpModuleRecord: PModuleRecord): boolean;
{查找和模块版本号匹配的记录}
var
  iFirst, iSecond, iThird: integer;
  mnu: TMenu;
  mnuitemFirst, mnuItemSecond, mnuItemThird: TMenuItem;
  pmr: PModuleRecord;
begin
  mnu := MainMenu;
  for iFirst := 0 to mnu.Items.Count - 1 do
  begin
    mnuItemFirst := mnu.Items[iFirst];
    for iSecond := 0 to mnuItemFirst.Count - 1 do
    begin
      mnuItemSecond := mnuItemFirst.Items[iSecond];
      if mnuItemSecond.Tag <> 0 then
      begin
        pmr := ptr(mnuItemSecond.Tag);
        if (pmr.ModuleID = ModuleID) then
        begin
          tmpModuleRecord := pmr;
          Result := TRUE;
          Exit;
        end;
      end;
      for iThird := 0 to mnuItemSecond.Count - 1 do
      begin
        mnuItemThird := mnuItemSecond.Items[iThird];
        pmr := ptr(mnuItemThird.Tag);
        if (pmr.ModuleID = ModuleID) then
        begin
          tmpModuleRecord := pmr;
          Result := TRUE;
          Exit;
        end;
      end;
    end;
  end;
  Result := FALSE;
end;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var i: Integer;
begin
  if ShowMsg('询问','确定退出系统？',self,2) = mrOK then
  begin
    try
      if Adocon.Connected then
        Adocon.Connected := false;
      for I := MDIChildCount-1 downto 0 do
        MDIChildren[I].Close;
    except
    end;
    Action := caFree;
  end
  else Action := caNone;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
  iniSys: TIniFile;
  sCompany: string;
  sAppName: string;
begin
  iniSys := TIniFile.Create(ExtractFilePath(Application.ExeName)+'\SYSTEM.ini');
  sCompany := iniSys.ReadString('SYSTEM','COMPANY','请设置SYSTEM.ini中[SYSTEM]COMPANY');
  sAppName := iniSys.ReadString('SYSTEM','AppName','请设置SYSTEM.ini中[SYSTEM]APPNAME');
  sDBHost := iniSys.ReadString('SYSTEM','DBHOST','请设置SYSTEM.ini中[SYSTEM]DBHOST');
  sDatabase := iniSys.ReadString('SYSTEM','DATABASE','请设置SYSTEM.ini中[SYSTEM]DATABASE');
  iniSys.Destroy;
  Caption := sAppName;
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
  PostMessage(self.Handle, WM_USER_SHOWFORM, 0, 0);
  //CreateMenuGroup(Sender);
end;

function TFrmMain.GetConnectString(sUser: string; sPwd: string): string;
begin
  result := 'Provider=SQLOLEDB.1;'
          + 'Password=' + sPwd + ';'
          + 'Persist Security Info=False;'
          + 'User ID=' + sUser + ';'
          + 'Initial Catalog=' + sDatabase + ';'
          + 'Data Source='  + sDBHost;
end;
procedure TFrmMain.NCloseAllClick(Sender: TObject);
var i: integer;
begin
  if MDIChildCount <= 0 then exit;
   for I := MDIChildCount-1 downto 0 do
    MDIChildren[I].Close;
end;

procedure TFrmMain.NAllMinClick(Sender: TObject);
var  I: integer;
begin
  if MDIChildCount <= 0 then exit;
  for I := MDIChildCount - 1 downto 0 do
    MDIChildren[I].WindowState := wsMinimized;
end;

procedure TFrmMain.NCengdClick(Sender: TObject);
var  I: integer;
begin
  if MDIChildCount <= 0 then exit;
  for I := MDIChildCount - 1 downto 0 do
  MDIChildren[I].WindowState := wsNormal;
  Cascade;
end;

procedure TFrmMain.NLoginClick(Sender: TObject);
begin
  if Self.MDIChildCount <> 0 then
  begin
    if ShowMsg('询问','关闭现有窗口？',self,2) = mrOK then
    begin
      NCloseAllClick(Sender);
    end
    else
    begin
      Exit;
    end;
  end;
  if frmLogin.ShowModal = mrOK then
  begin
    InitMainMenu;
  end;

end;

procedure TFrmMain.NLogoutClick(Sender: TObject);
begin
  close;
end;

procedure TFrmMain.NModifyPswClick(Sender: TObject);
begin
  if m_bLogin then
  begin
    FrmModifyPsw.Show;
  end
  else
  begin
    ShowMsg('系统提示','请先登录系统!',self);
  end;
end;

procedure TFrmMain.DelHistoryMenu;     //删除原有菜单
var
  i: integer;
  pMdRecord: pModuleRecord;
  mnuRoot, mnuSecond, mnuThird: TMenuItem;
begin
  while (MainMenu.Items.Count > 3) do
  begin
    mnuRoot := TMenuItem(MainMenu.Items[1]);
    while (mnuRoot.Count > 0) do
    begin
      mnuSecond := TMenuItem(mnuRoot.Items[0]);
      while (mnuSecond.Count > 0) do
      begin
        mnuThird := TMenuItem(mnuSecond.Items[0]);
        if mnuThird.Tag > 0 then
        begin
          pMdRecord := PModuleRecord(mnuThird.Tag);
          Dispose(pMdRecord);
        end;
        mnuThird.Free;
      end;
      if mnuSecond.Tag > 0 then
      begin
        pMdRecord := PModuleRecord(mnuSecond.Tag);
        Dispose(pMdRecord);
      end;
      mnuSecond.Free;
    end;
    if mnuRoot.Tag > 0 then
    begin
      pMdRecord := PModuleRecord(mnuRoot.Tag);
      Dispose(pMdRecord);
    end;
    mnuRoot.Free;
  end;
end;
procedure TFrmMain.InitMainMenu;
var commandStr1: widestring;
    commandStr2: widestring;
    commandStr3: widestring;
    i: integer;
    j: integer;
    k: integer;
    FFMenuID: string;
    FModuleID: string;
    FMenuName: widestring;
    level: integer;
    mnuRoot, mnuSecond, mnuThird: TMenuItem;
    pMdRecord: pModuleRecord;
begin
  DelHistoryMenu;
  FFMenuID := '0';
  level := 1;
  commandStr1 := 'select a.FID,a.FName,a.FModuleID,b.FCode,b.FPath,a.FIsEnd from tMenu a '
              + 'left join tModule b on a.FModuleID = b.FID '
              + 'where a.FLevel = '+ IntTostr(level)+' and a.FFID = ''' + FFMenuID + ''' '
              + 'and a.FID in(select FMenuID from tLimit where FUserID = ''' + m_Operator + ''') '
              + 'order by FSort';
  OpenAdoDataSet(adsMenu1, commandStr1);

  for i := 1 to adsMenu1.RecordCount do
  begin
    FFMenuID := adsMenu1.FieldByName('FID').AsString;
    FMenuName :=  adsMenu1.FieldByName('FName').AsString;
    FModuleID := adsMenu1.FieldByName('FCode').AsString;
    level := 2;
    mnuRoot := TMenuItem.Create(self);
    mnuRoot.Caption :=trim(FMenuName);
    if adsMenu1.FieldByName('FIsEnd').Value then
    begin
      mnuRoot.OnClick := MenuClick;
      pMdRecord := New(pModuleRecord);
      pMdRecord.ModuleID := FModuleID;
      pMdRecord.Path := adsMenu1.FieldByName('FPath').AsString;
      pMdRecord.Handle := 0;
      pMdRecord.frm := nil;
      mnuRoot.Tag := Integer(pMdRecord);
    end;
    MainMenu.Items.Insert(MainMenu.Items.Count-2, mnuRoot);

    commandStr2 := 'select a.FID,a.FName,a.FModuleID,b.FCode,b.FPath,a.FIsEnd from tMenu a '
                + 'left join tModule b on a.FModuleID = b.FID '
                + 'where a.FLevel = '+ IntTostr(level)+' and a.FFID = ''' + FFMenuID + ''' '
                + 'and a.FID in(select FMenuID from tLimit where FUserID = ''' + m_Operator + ''') '
                + 'order by FSort';
    OpenAdoDataSet(adsMenu2, commandStr2);
    for j := 1 to adsMenu2.RecordCount do
    begin
      FFMenuID := adsMenu2.FieldByName('FID').AsString;
      FMenuName :=  adsMenu2.FieldByName('FName').AsString;
      FModuleID := adsMenu2.FieldByName('FCode').AsString;
      level := 3;
      mnuSecond := TMenuItem.Create(self);
      mnuSecond.Caption :=trim(FMenuName);
      if adsMenu2.FieldByName('FIsEnd').Value then
      begin
        mnuSecond.OnClick := MenuClick;
        pMdRecord := New(pModuleRecord);
        pMdRecord.ModuleID := FModuleID;
        pMdRecord.Path := adsMenu2.FieldByName('FPath').AsString;
        pMdRecord.Handle := 0;
        pMdRecord.frm := nil;
        mnuSecond.Tag := Integer(pMdRecord);
      end;
      mnuRoot.Add(mnuSecond);

      commandStr3 := 'select a.FID,a.FName,a.FModuleID,b.FPath,b.FCode,a.FIsEnd from tMenu a '
                  + 'left join tModule b on a.FModuleID = b.FID '
                  + 'where a.FLevel = '+ IntTostr(level)+' and a.FFID = ''' + FFMenuID + ''' '
                  + 'and a.FID in(select FMenuID from tLimit where FUserID = ''' + m_Operator + ''') '
                  + 'order by FSort';
        OpenAdoDataSet(adsMenu3, commandStr3);
        for k := 1 to adsMenu3.RecordCount do
        begin
          FFMenuID := adsMenu3.FieldByName('FID').AsString;
          FMenuName :=  adsMenu3.FieldByName('FName').AsString;
          FModuleID := adsMenu3.FieldByName('FCode').AsString;
          mnuThird := TMenuItem.Create(self);
          mnuThird.Caption :=trim(FMenuName);
          if adsMenu3.FieldByName('FIsEnd').Value then
          begin
            mnuThird.OnClick := MenuClick;
            pMdRecord := New(pModuleRecord);
            pMdRecord.ModuleID := FModuleID;
            pMdRecord.Path := adsMenu3.FieldByName('FPath').AsString;
            pMdRecord.Handle := 0;
            pMdRecord.frm := nil;
            mnuThird.Tag := Integer(pMdRecord);
          end;
          mnuSecond.Add(mnuThird);
          adsMenu3.Next;
    end;
      adsMenu2.Next;
    end;

    adsMenu1.Next;
  end;
end;

procedure TFrmMain.MenuClick(Sender: TObject);
var i : Integer;
begin
  if (Sender is TMenuItem) then
  begin
    i := (Sender as TMenuItem).tag;
    Perform(WM_User_CALLDLL, i, 0);
  end;


  //if (Sender is TBitBtn) then
  //  Perform(WM_User_CALLDLL, (Sender as TBitBtn).tag, 0);
end;

procedure  TFrmMain.RunDllForm(var msg: TMessage);
var
  tmpModuleRecord: PModuleRecord;
  CreateDllForm: TCreateDllForm;

begin
  tmpModuleRecord := PModuleRecord(msg.WPARAM);
  //窗体已经存在
  if tmpModuleRecord.frm <> nil then
  begin
    if (tmpModuleRecord.frm <> Application.MainForm.ActiveMDIChild) then
    begin
      tmpModuleRecord.frm.BringToFront;
      ActiveMDIChild.WindowState := wsMaximized;
    end;
    tmpModuleRecord.frm.SetFocus;
    ActiveMDIChild.WindowState := wsMaximized;
    Exit;
  end;

  tmpModuleRecord.Handle  := LoadLibrary(PChar(tmpModuleRecord.Path));
  try
    if tmpModuleRecord.Handle < 32 then
    begin
      ShowMsg('错误','没有找到' + tmpModuleRecord.Path + 'DLL文件！',self);
      //MessageBox(0, Pchar('没有找到' + tmpModuleRecord.Path + 'DLL文件！'),'加载DLL失败', MB_OK);
      Exit;
    end;
    @CreateDllForm := GetProcAddress(tmpModuleRecord.Handle,pchar('CreateForm'));
    if @CreateDllForm <> nil then
       try
         CreateDllForm(Application, ADOCon,StrToInt(m_Operator),tmpModuleRecord.frm);
         if Self.ActiveMDIChild <> nil then
         begin
          ActiveMDIChild.WindowState := wsMaximized;
         end;
       except
         raise Exception.Create('对不起,窗体创建失败！');
       end
     else
     raise Exception.Create('无效的方法名调用');
  finally
    //FreeLibrary(GetDllHWND);
  end;
end;

procedure TFrmMain.ExitDllForm(var msg: TMessage);
{处理DLL中窗体退出事件}
var
  tmpModuleRecord: PModuleRecord;
  ModuleID: string;
begin
  ModuleID := string(PCHAR(msg.WParam));
  if (FindModuleRecord(ModuleID, tmpModuleRecord)) then
  begin
    if tmpModuleRecord.frm <> nil then
    begin
      tmpModuleRecord.frm := nil;
    end;
  end;
end;
procedure TFrmMain.ShowLoginForm(var msg: TMessage);
begin
  self.NLoginClick(Self);
end;
{
 procedure TFrmMain.CreateMenuGroup(Sender: TObject);//创建菜单分组 测试版
 var
  i: Integer;
  nTop :Integer;
 begin
   nTop := 0;
   for i := 0 to BTN_NUM - 1 do
   begin
     if abtnGroup[i] <> nil then
     begin
       abtnGroup[i].Destroy;
       abtnGroup[i] := nil;
     end;
    end;
   for i := 0 to BTN_NUM - 1 do
   begin
     if ((i = 0) or (i = 4) or (i = 7) or (i = 10)) then
     begin
       abtnGroup[i] := TBitBtn.Create(Self);
       abtnGroup[i].Width := 130;
       abtnGroup[i].Height := 25;
       abtnGroup[i].Left := 0;
       abtnGroup[i].Name := 'btn_' + inttostr(i);
       abtnGroup[i].Tag := 0;
       abtnGroup[i].OnClick := btnGroupClick;
       abtnGroup[i].Top := nTop;
       nTop := abtnGroup[i].Top + abtnGroup[i].Height;
     end
     else
     begin
       abtnGroup[i] := TBitBtn.Create(Self);
       abtnGroup[i].Width := 55;
       abtnGroup[i].Height := 55;
       abtnGroup[i].Left := 40;
       abtnGroup[i].Name := 'btn_' + inttostr(i);
       abtnGroup[i].Tag := 2;
       abtnGroup[i].Visible := False;
     end;
     abtnGroup[i].Parent := scrlbx1;
   end;
 end;
procedure TFrmMain.btnGroupClick(Sender: TObject);
var
  btnTmp : Tbitbtn;
  nOldTop : Integer;
  i : Integer;
  nFlag : Integer;
begin
  //获取被点击的分组按钮
  if Sender is TBitBtn then
  begin
    btnTmp := Sender as TBitBtn;
  end;

  //该分组已经被打开就不做任何动作
  if btnTmp.Tag = 1 then
  begin
    Exit;
  end
  else//否则关闭已打开的分组，再打开本次被点击的分组
  begin
    //步骤1、关闭已打开的分组
    nOldTop := 0;
    for i := 0 to BTN_NUM - 1 do
    begin
      //隐藏模块按钮
      if abtnGroup[i].Tag = 2 then
      begin
        abtnGroup[i].Visible := False;
      end
      else//分组按钮设为未打开状态
      begin
        abtnGroup[i].Tag := 0;
        abtnGroup[i].Top := nOldTop;
        nOldTop := abtnGroup[i].Top + abtnGroup[i].Height;
      end;
    end;
    //步骤2、打开本次被点击的分组
    nFlag := 0;
    for i := 0 to BTN_NUM - 1 do
    begin
        if ((abtnGroup[i] <> btnTmp) and (nFlag = 0)) then
        begin
          Continue;
        end;
        if nFlag = 0 then
        begin
          nFlag := 1;
        end;

        if(nFlag = 1) then
        begin
          if abtnGroup[i].Tag = 2 then
          begin
            abtnGroup[i].Visible := True;
            abtnGroup[i].Top := nOldTop;
            nOldTop := abtnGroup[i].Top + abtnGroup[i].Height + 5;
          end
          else if abtnGroup[i] = btnTmp then
          begin
            abtnGroup[i].Tag := 1;
            nOldTop := abtnGroup[i].Top + abtnGroup[i].Height + 5;
          end
          else
          begin
            nFlag := 2;
            abtnGroup[i].Top := nOldTop;
            nOldTop := abtnGroup[i].Top + abtnGroup[i].Height;
          end;
        end
        else
        begin
          if abtnGroup[i].Tag <> 2 then
          begin
            abtnGroup[i].Top := nOldTop;
            nOldTop := abtnGroup[i].Top + abtnGroup[i].Height;
          end;
        end;
    end;

  end;

end;
}

end.
