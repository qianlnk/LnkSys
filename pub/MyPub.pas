{**********************************************************************
* 文件名称: MyPub.pas
* 版本信息：2014.07(lnk)
* 文件描述：
            存放所有通用函数，加入函数请按例子说明好函数功能、参数、
            返回值等信息，必要时给出调用实例
* 创 建 者：qianlnk
* 创建时间：2014.07.19
***********************************************************************}
unit MyPub;

interface

uses SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Variants,
  Controls, Forms, Dialogs, ExtCtrls, StdCtrls, DBClient, DB, Mask,
  DBCtrls, URLMON, AdoDB,Math,Vcl.ComCtrls,Vcl.Buttons
  ;

{**********************************************************************
过程功能：通用ADO查询,根据用户输入SQL检索数据
参数说明：adoqry—TADOQuery组件,sqltxt-SQL语句
历史信息：2014.07.19 created by qianlnk
**********************************************************************}
procedure OpenAdoQuery(adoQry: TADOquery; sqltxt: widestring);

{**********************************************************************
过程功能：通用ADO执行,根据用户输入SQL提交数据
参数说明：adoqry1—TADOQuery组件,sqltxt-EXECSQL语句
历史信息：2014.07.19 created by qianlnk
**********************************************************************}
procedure ExecAdoQuery(adoQry: TADOquery; sqltxt: widestring);

//过程功能：通用ADODataSet执行,根据用户输入SQLCOMMAND检索数据
procedure OpenAdoDataSet(adoDataSet: TADODataSet; commandStr: widestring);
{**********************************************************************
过程功能：窗口屏幕焦点控制,支持回车跳到下一控件
参数说明：参数对应组件keyDown方法中的参数
历史信息：2014.07.19 created by qianlnk
**********************************************************************}
procedure ControlKey(var Key: Word; Shift: TShiftState);

{**********************************************************************
过程功能：窗口居中
参数说明：无
历史信息：2014.07.19 created by qianlnk
**********************************************************************}
procedure PutFormCenter(subForm: TForm; MainForm: TForm);
{**********************************************************************
过程功能：弹窗位置设置
参数说明：无
历史信息：2014.08.05 created by qianlnk
**********************************************************************}
procedure SetSubFormPlace(subForm: TForm);
{**********************************************************************
过程功能：判断Edit不能为空
参数说明：Edit1 输入框
          MainForm 调用该过程的窗体
历史信息：2014.07.19 created by qianlnk
**********************************************************************}
function EditValid(Edit1: TEdit; strMsg: string; MainForm: TForm):boolean;

{**********************************************************************
函数功能：消息提示弹窗
参数说明：sTitle 弹窗标题
          sMsg 消息
          MainForm 调用该弹窗的窗体 用于弹窗居中
          btnCount 按钮数量
历史信息：2014.07.19 created by qianlnk
**********************************************************************}
function ShowMsg(sTitle: Widestring; sMsg: widestring; MainForm: TForm; btnCount:Integer = 1):Integer;
{**********************************************************************
过程功能：向combobox中添加数据库选项
参数说明：qry1查询结果集
          itemName选项代码
          IsDel是否清空
历史信息：2014.08.04 created by qianlnk
**********************************************************************}
procedure AddItemToCommbox(qry1: TADOQuery; itemName: string;
                           cbb1:TComboBox; IsDel:Boolean = True);
{**********************************************************************
过程功能：获取treeview的结点及子节点的text值，用逗号隔开
参数说明：strText
          node
历史信息：2014.08.05 created by qianlnk
**********************************************************************}
procedure GetTvTextAndChild(var strText: string; node: TTreeNode);
{**********************************************************************
过程功能：获取treeview的结点Node同级结点及子节点的text值，用逗号隔开
参数说明：strText
          node
历史信息：2014.08.05 created by qianlnk
**********************************************************************}
procedure GetAllTvTextAfterNode(var strText: string; node: TTreeNode);

{**********************************************************************
过程功能：设置treeview的结点Node和同级结点及他们的子节点的状态
参数说明：node
          state
历史信息：2014.08.05 created by qianlnk
**********************************************************************}
procedure SetTvNodeStateIndex(node: TTreeNode; nState: Integer);

{**********************************************************************
过程功能：展开treeview的结点
参数说明：treeview
历史信息：2014.08.05 created by qianlnk
**********************************************************************}
procedure ExpandTvItem(tv: TTreeView);

{**********************************************************************
过程功能：在treeview的结点前画一个复选框
参数说明：treeview
历史信息：2014.08.09 created by qianlnk
**********************************************************************}
procedure DrowChkBoxForTv(tv: TTreeView);

{**********************************************************************
过程功能：将指定容器下的所有编辑控件设置为只读
参数说明：AComponent: TComponent
历史信息：2014.08.06 created by qianlnk
**********************************************************************}
procedure SetReadOnly(AComponent: TComponent);

{**********************************************************************
过程功能：创建操作日志
参数说明：adoQry  qry控件 用于操作
          UserId  用户ID
          Module  模块名称
          type    操作类型
          remark  操作描述
历史信息：2014.08.07 created by qianlnk
**********************************************************************}
procedure MakeLog(adoQry: TADOquery; UserId: Integer; sModule: string;
                  sType: string; sRemark: string);

{**********************************************************************
过程功能：判断插入的指定字段值是否重复
参数说明：sCloum --字段
          sValue --值
          sTbale --表
历史信息：2014.08.06 created by qianlnk
**********************************************************************}
function IsExist(adoQry: TADOquery; sCloum: string; sValue:string; sTable:string):Boolean;

{**********************************************************************
过程功能：获取下一条记录的FID
参数说明：adoQry: TADOquery
          sTbale
历史信息：2014.08.06 created by qianlnk
**********************************************************************}
function GetNextID(adoQry: TADOquery; sTable:string):Integer;

{**********************************************************************
过程功能：拼接结果集的记录
参数说明：adoQry: TADOquery --结果集
          sColumn:          --要拼接的列名
历史信息：2014.08.06 created by qianlnk
**********************************************************************}
function wm_concat(adoQry: TADOquery; sColumn:string):string;

{**********************************************************************
过程功能：初始化模块权限
参数说明：adoQry: TADOquery
          frm:          --模块主窗体
          sModileId：   --模块版本号
          nUser：       --当前登录用户
历史信息：2014.08.06 created by qianlnk
**********************************************************************}
procedure InitModuleLimit(adoqry: TADOQuery; frm: TForm;
                          sModileId: string; nUser: integer);

{**********************************************************************
过程功能：对容器下的所有编辑控件输入的数据进行安全检查 防止黑客的SQL注入
参数说明：AComponent: TComponent
          frm: 被判断的容器所在的窗体   用于消息显示
历史信息：2014.08.20 created by qianlnk
描    述：所有的SQL查询发生时必须调用该过程
**********************************************************************}
function SafeCheck(AComponent: TComponent; frm:TForm):Boolean;
//在 SafeCheck中调用
function CheckString(sContent:string;frm:TForm):Boolean;
{---------------------------------------------------------------------}
{                                  实现                               }
{---------------------------------------------------------------------}
implementation

uses uShowMsg;

//过程功能：通用ADO查询,根据用户输入SQL检索数据
procedure OpenAdoQuery(adoQry: TADOquery; sqltxt: widestring);
begin
  with adoQry do
  begin
    if active then close;
    SQL.clear;
    SQL.add(sqltxt);
    open;
  end;
end;

//过程功能：通用ADO执行,根据用户输入SQL提交数据
procedure ExecAdoQuery(adoQry: TADOquery; sqltxt: widestring);
begin
  with adoQry do
  begin
    if active then close;
    SQL.clear;
    SQL.add(sqltxt);
    EXECSQL;
  end;
end;

//过程功能：通用ADO执行,根据用户输入SQL提交数据
procedure OpenAdoDataSet(adoDataSet: TADODataSet; commandStr: widestring);
begin
  with adoDataSet do
  begin
    if active then close;
    CommandText := commandStr;
    open;
  end;
end;
//窗口屏幕快键控制
procedure ControlKey(var Key: Word; Shift: TShiftState);
var
  CurForm: TForm;
  CurControl: TWinControl;
  bSelectNext: boolean;
begin
  CurForm := Screen.ActiveForm;
  CurControl := CurForm.ActiveControl;
  if Shift = [] then
  begin
    case Key of
      VK_RETURN:
        begin
          bSelectNext := FALSE;
          if (CurControl is TEdit) then bSelectNext := TRUE;
          if (CurControl is TCombobox) then bSelectNext := TRUE;
          if (CurControl is TMaskEdit) then bSelectNext := TRUE;
          if (CurControl is TDBEdit) then bSelectNext := TRUE;
          //if (CurControl is TDateTime) then bSelectNext := TRUE;
          if bSelectNext then CurForm.Perform(CM_DIALOGKEY, VK_TAB, 0);
        end;
    end;
  end;
end;

//窗口居中
procedure PutFormCenter(subForm: TForm; MainForm: TForm);
begin
  subForm.Left := (MainForm.Width - subForm.Width) div 2 + MainForm.Left;
  subForm.Top := (MainForm.Height - subForm.Height)div 2 + MainForm.Top;
end;
//弹窗位置设置
procedure SetSubFormPlace(subForm: TForm);
begin
  subForm.Top := 105;
  subForm.Left := (screen.Width - subForm.Width) div 2;
end;
//函数功能：消息提示弹窗
function ShowMsg(sTitle: Widestring; sMsg: widestring; MainForm: TForm; btnCount:Integer = 1):Integer;
var msgLen : integer;
begin
  FrmShowMsg := TFrmShowMsg.Create(Application);
  msgLen := length(sMsg) * 10;
  with FrmShowMsg do
  begin
    if msgLen > 180 then
    begin
      width := msgLen + 130;
    end
    else
    begin
      width := 350;
    end;

    height := 150;
    Caption := sTitle;
    m_msg := sMsg;
    lbMsg.Left := 85;
    lbMsg.Top := 30;
    if btnCount = 1 then
    begin
      btnCancle.Visible := False;
      btnSure.Visible := True;
      btnSure.Left := FrmShowMsg.Width - btnSure.Width - 20;
    end
    else
    begin
      btnCancle.Visible := True;
      btnSure.Visible := True;
      btnSure.Left := FrmShowMsg.Width - btnSure.Width - btnSure.Width - 30;
      btnCancle.Left := FrmShowMsg.Width - btnCancle.Width - 20;
    end;
    PutFormCenter(FrmShowMsg,MainForm);
  end;
  //if FrmShowMsg.ShowModal = IDOK then
  begin
    Result := FrmShowMsg.ShowModal;
  end;
  FrmShowMsg.Release;
end;

//判断Edit不能为空
function EditValid(Edit1: TEdit; strMsg:string ; MainForm: TForm):boolean;
begin
  if (trim(Edit1.Text)='') then
  begin
    ShowMsg('系统提示', '请输入完整的' + strMsg, MainForm);
    if Edit1.Enabled then Edit1.SetFocus;
    result := TRUE;
  end
  else
    result := FALSE;
end;

//加载数据选项到选项框
procedure AddItemToCommbox(qry1: TADOQuery; itemName: string;
                           cbb1:TComboBox;IsDel:Boolean = True);
var i: Integer;
begin
  if IsDel then
  begin
    cbb1.Clear;
  end;
  if(qry1.RecordCount = 0) then
  begin
    Exit;
  end;
  for i := 0 to qry1.RecordCount - 1 do
  begin
    cbb1.Items.Add(trim(qry1.FieldValues[itemName]));
    qry1.Next;
  end;
   if cbb1.Items.count <>0 then
    cbb1.ItemIndex := 0;
end;

//获取treeview的结点及其子节点的text值，用逗号隔开
procedure GetTvTextAndChild(var strText: string; node: TTreeNode);
var
    tmpNode: TTreeNode;
begin
  tmpNode := node;
  if tmpNode <> nil then
  begin
    if strText = '' then
    begin
      strText := '''' + tmpNode.Text + '''';
    end
    else
    begin
      strText := strText + ',' + '''' + tmpNode.Text + '''';
    end;
    if tmpNode.HasChildren then
    begin
      GetAllTvTextAfterNode(strText,tmpNode.getFirstChild);
    end;
  end;
end;
//获取treeview的结点Node和同级结点以及他们的子节点的text值，用逗号隔开
procedure GetAllTvTextAfterNode(var strText: string; node: TTreeNode);
var
    tmpNode: TTreeNode;
begin
  tmpNode := node;
  while tmpNode <> nil do
  begin
    if strText = '' then
    begin
      strText := '''' + tmpNode.Text + '''';
    end
    else
    begin
      strText := strText + ',' + '''' + tmpNode.Text + '''';
    end;
    if tmpNode.HasChildren then
    begin
      GetAllTvTextAfterNode(strText,tmpNode.getFirstChild);
    end;
    tmpNode := tmpNode.getNextSibling;
  end;
end;

//设置treeview的结点Node和同级结点及他们的子节点的状态
procedure SetTvNodeStateIndex(node: TTreeNode; nState: Integer);
var
    tmpNode: TTreeNode;
begin
  tmpNode := node;
  while tmpNode <> nil do
  begin
    tmpNode.StateIndex := nState;

    if tmpNode.HasChildren then
    begin
      SetTvNodeStateIndex(tmpNode.getFirstChild,nState);
    end;
    tmpNode := tmpNode.getNextSibling;
  end;
end;
//展开treeview所有结点
procedure ExpandTvItem(tv: TTreeView);
var i:Integer;
begin
  for i := 0 to tv.Items.Count - 1 do
    begin
      tv.Items[i].Expanded := True;
    end;
end;

//将指定容器下的所有编辑控件设置为只读
procedure SetReadOnly(AComponent: TComponent);
var i: Integer;
begin
  //说明：没有控制到的控件请在这里添加
  if AComponent is TEdit then TEdit(AComponent).ReadOnly := True;
  if AComponent is TComboBox then TComboBox(AComponent).Enabled := False;
  if AComponent is TMemo then TMemo(AComponent).ReadOnly := True;
  if AComponent is TCheckBox then TCheckBox(AComponent).Enabled := False;
  if AComponent is TDateTimePicker then TDateTimePicker(AComponent).Enabled := False;


  if AComponent is TWinControl then //控件仍是容器则递归
  begin
    for i := 0 to TWinControl(AComponent).ControlCount - 1 do
    begin
      SetReadOnly(TWinControl(AComponent).Controls[i]);
    end;

  end;
end;

//创建操作日志
procedure MakeLog(adoQry: TADOquery; UserId: Integer; sModule: string; sType: string; sRemark: string);
var sqltxt: string;
    //FID: Integer;
begin
  //FID := GetNextID(adoQry,'tLog');

  sqltxt := 'Insert into tLog(FUserID, FDate, FModule, FType, FRemark) '
          + 'values(' + IntToStr(UserId) + ',getdate(),''' + sModule
          + ''',''' + sType + ''',''' + sRemark + ''')';
  ExecAdoQuery(adoQry,sqltxt);
end;

{**********************************************************************
过程功能：判断插入的指定字段值是否重复
参数说明：sCloum --字段
          sValue --值
          sTbale --表
历史信息：2014.08.06 created by qianlnk
**********************************************************************}
function IsExist(adoQry: TADOquery; sCloum: string; sValue:string; sTable:string):Boolean;
var sqltxt:string;
begin
  sqltxt := 'select * from ' + sTable + ' where ' + sCloum + ' = ''' + sValue + ''' ';
  OpenAdoQuery(adoQry,sqltxt);
  if adoQry.RecordCount > 0 then
  begin
    Result := True;
  end
  else
  begin
    Result := False;
  end;
end;

//获取下一条记录的FID
function GetNextID(adoQry: TADOquery; sTable:string):Integer;
var sqltxt: string;
begin
  sqltxt := 'select isnull(max(FID),0) as FID from ' + sTable;
  OpenAdoQuery(adoQry,sqltxt);
  if adoQry.RecordCount = 0 then
  begin
    Result := 1;
  end
  else
  begin
    Result := StrToInt(trim((adoQry.FieldByName('FID').AsString))) + 1;
  end;
end;

//在treeview的结点前画一个复选框
procedure DrowChkBoxForTv(tv: TTreeView);
var i:Integer;
begin
  for i := 0 to tv.Items.Count - 1 do
    begin
      tv.Items[i].StateIndex := 1;
    end;
end;

//拼接结果集的记录
function wm_concat(adoQry: TADOquery; sColumn:string):string;
var sRes: string;
    i: Integer;
begin
  if adoQry.RecordCount = 0 then
  begin
    Result := '';
    Exit;
  end;
  for i := 0 to adoQry.RecordCount - 1 do
  begin
    if sRes = '' then
    begin
      sRes := adoQry.FieldByName(sColumn).AsString;
    end
    else
    begin
      sRes := sRes + ',' + adoQry.FieldByName(sColumn).AsString;
    end;
    adoQry.Next;
  end;
  Result := sRes;
end;

//初始化模块权限
procedure InitModuleLimit(adoqry: TADOQuery; frm: TForm; sModileId: string; nUser:integer);
var i: Integer;
    Compon : TComponent;
    OldLeft: Integer; //上一个组件的left值
    sqltxt: string;
    j: Integer;
    sFuncs: WideString;
begin
  OldLeft := 5;
  sqltxt := 'select FFuncCaption from tModuleFunc where FModuleID = (select FID from tModule where FCode = ''' + sModileId + ''')'
          + 'and FID in(select FModuleFuncID from tFuncLimit where FUserID = '+ IntToStr(nUser) +')';
  OpenAdoQuery(adoqry,sqltxt);
  sFuncs := wm_concat(adoqry,'FFuncCaption');
  for i := 0 to frm.ComponentCount - 1 do
  begin
    Compon := frm.Components[i];
    if Compon is TBitBtn then
    begin
      if (Compon As TBitBtn).Visible = False then
      begin //不干扰系统设计时的设置
        Continue;
      end;

      if Pos((Compon As TBitBtn).Caption,sFuncs) > 0 then
      begin
        (Compon As TBitBtn).Visible := False;
      end
      else
      begin
        (Compon As TBitBtn).Visible := True;
      end;
      if (Compon As TBitBtn).Visible and ((Compon As TBitBtn).Caption <> '查询') then
      begin
        (Compon As TBitBtn).Left := OldLeft;
        OldLeft := OldLeft + (Compon As TBitBtn).Width;
      end;
    end;
  end;
end;

//对容器下的所有编辑控件输入的数据进行安全检查 防止黑客的SQL注入
function SafeCheck(AComponent: TComponent; frm:TForm):Boolean;
var i: Integer;
    sContent: string;//编辑框中的内容
    nFlag: Integer;
begin
  //说明：没有控制到的编辑控件请在这里添加
  if AComponent is TEdit then
  begin
    sContent := TEdit(AComponent).Text;
    if CheckString(sContent,frm) then
    begin
      TEdit(AComponent).SetFocus;
      Result := True;
      Exit;
    end;
  end;
  if AComponent is TComboBox then
  begin
    sContent := TComboBox(AComponent).Text;
    if CheckString(sContent,frm) then
    begin
      TComboBox(AComponent).SetFocus;
      Result := True;
      Exit;
    end;
  end;
  if AComponent is TMemo then
  begin
    sContent := TMemo(AComponent).Text;
    if CheckString(sContent,frm) then
    begin
      TMemo(AComponent).SetFocus;
      Result := True;
      Exit;
    end;
  end;

  // nFlag 数据类型标记目前先不用


  if AComponent is TWinControl then //控件仍是容器则递归
  begin
    for i := 0 to TWinControl(AComponent).ControlCount - 1 do
    begin
      if SafeCheck(TWinControl(AComponent).Controls[i],frm) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;
  Result := False;
end;
const
CK_SQLInjection: array[0..13] of string=(
'''',';','--','/*','#','SELECT','DELETE','DROP','INSERT','UNION',
'UPDATE','ALTER','CREATE','EXEC'
);
function CheckString(sContent:string;frm:TForm):Boolean;
var i :Integer;
begin
  // 过滤对SQL语句敏感的字符串
  for I := 0 to 13 do
  begin
    if Pos(CK_SQLInjection[i],UpperCase(sContent))>0 then
    begin
      ShowMsg('错误','输入的信息不允许包含['+ CK_SQLInjection[i] +']！',frm);
      Result := True;
      Exit;
    end;
  end;
  Result := False;
end;
end.

