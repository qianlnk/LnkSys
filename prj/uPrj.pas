unit uPrj;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,Mypub,ShellAPI;

type
  TfrmPrj = class(TForm)
    lbl1: TLabel;
    edtName: TEdit;
    lbl2: TLabel;
    edtCode: TEdit;
    lbl3: TLabel;
    edtMan: TEdit;
    btnSure: TBitBtn;
    btnCancel: TBitBtn;
    lstMsg: TListBox;
    mmo1: TMemo;
    procedure btnCancelClick(Sender: TObject);
    procedure btnSureClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    function SetFirstUpper(sText: string):string;
  private
    { Private declarations }
  public
    { Public declarations }
    ErrNo: Integer;
    CrtNo: Integer;
  end;

var
  frmPrj: TfrmPrj;

implementation

{$R *.dfm}
function TfrmPrj.SetFirstUpper(sText: string):string;
var sFirst: string;
    sLast: string;
begin
  sFirst := Copy(sText,1,1);
  sLast := Copy(sText,2,length(sText));
  Result := UpperCase(sFirst) + sLast;
end;
procedure TfrmPrj.btnCancelClick(Sender: TObject);
begin
  Close;
end;



procedure TfrmPrj.btnSureClick(Sender: TObject);
var ModuleID : string;
    fSrcFile : TFileStream;
    fDstFile : TFileStream;
    sSrcPath : array[0..10] of string;
    sDstPath : array[0..10] of string;
    sFileTxt : WideString;
    tFile:TextFile;
    i,j,nFlag: Integer;
    bIsOK: Boolean;
    sSql: string;
begin
  nFlag := 0; //标记是否是工程文件的第一行  解决乱码问题 2014,08,20 by lnk
  //有效性判断
  if trim(edtName.Text) = '' then
  begin
    ErrNo := ErrNo + 1;
    if ErrNo = 1 then
    begin
      lstMsg.Items.Add('错误提示：');
      lstMsg.ItemIndex := lstMsg.Count - 1;
    end;
    lstMsg.Items.Add(IntToStr(ErrNo) + '、 请输入工程名称！');
    lstMsg.ItemIndex := lstMsg.Count - 1;
    exit;
  end;
  if trim(edtCode.Text) = '' then
  begin
    ErrNo := ErrNo + 1;
    if ErrNo = 1 then
    begin
      lstMsg.Items.Add('错误提示：');
      lstMsg.ItemIndex := lstMsg.Count - 1;
    end;
    lstMsg.Items.Add(IntToStr(ErrNo) + '、 请输入工程代码！');
    lstMsg.ItemIndex := lstMsg.Count - 1;
    exit;
  end;
  if trim(edtMan.Text) = '' then
  begin
    ErrNo := ErrNo + 1;
    if ErrNo = 1 then
    begin
      lstMsg.Items.Add('错误提示：');
      lstMsg.ItemIndex := lstMsg.Count - 1;
    end;
    lstMsg.Items.Add(IntToStr(ErrNo) + '、 请输入创建者！');
    lstMsg.ItemIndex := lstMsg.Count - 1;
    exit;
  end;
  //开始创建
  lstMsg.Items.Add('创建进度：');
  lstMsg.ItemIndex := lstMsg.Count - 1;
  CrtNo := CrtNo + 1;
  sSrcPath[0] := 'lnkDll.dpr';
  sSrcPath[8] := 'lnkDll.dproj';
  sSrcPath[2] := 'lnkDll.res';
  sSrcPath[3] := 'uDllDel.dfm';
  sSrcPath[4] := 'uDllDel.pas';
  sSrcPath[5] := 'uDllMain.dfm';
  sSrcPath[6] := 'uDllMain.pas';
  sSrcPath[7] := 'uDllSub.dfm';
  sSrcPath[1] := 'uDllSub.pas';
  sSrcPath[9] := 'lnkDll.dproj.local';
  sSrcPath[10] := 'lnkDll.identcache';

  sDstPath[0] := Trim(edtCode.Text) +'.dpr';
  sDstPath[8] := Trim(edtCode.Text) +'.dproj';
  sDstPath[2] := Trim(edtCode.Text) +'.res';
  sDstPath[3] := 'u' + SetFirstUpper(Trim(edtCode.Text)) +'Del.dfm';
  sDstPath[4] := 'u' + SetFirstUpper(Trim(edtCode.Text)) +'Del.pas';
  sDstPath[5] := 'u' + SetFirstUpper(Trim(edtCode.Text)) +'Main.dfm';
  sDstPath[6] := 'u' + SetFirstUpper(Trim(edtCode.Text)) +'Main.pas';
  sDstPath[7] := 'u' + SetFirstUpper(Trim(edtCode.Text)) +'Sub.dfm';
  sDstPath[1] := 'u' + SetFirstUpper(Trim(edtCode.Text)) +'Sub.pas';
  sDstPath[9] := Trim(edtCode.Text) +'.dproj.local';
  sDstPath[10] := Trim(edtCode.Text) +'.identcache';
  //1、创建工程文件夹
  lstMsg.Items.Add(IntToStr(CrtNo) + '、 创建工程文件夹.....');
  lstMsg.ItemIndex := lstMsg.Count - 1;
  bIsOK := CreateDirectory(PWideChar('../../../src/'+trim(edtMan.Text) + '_' + Trim(edtCode.Text)),nil);
  if bIsOK then
  begin
    lstMsg.Items.Add('      成功创建工程文件夹：'+ trim(edtMan.Text) + '_' + Trim(edtCode.Text));
    lstMsg.ItemIndex := lstMsg.Count - 1;
  end
  else
  begin
    if ShowMsg('询问','该工程已存在，是否覆盖？',self,2) = mrCancel then
    begin
      Exit;
    end
    else
    begin
      lstMsg.Items.Add('      成功覆盖工程文件夹：'+ trim(edtMan.Text) + '_' + Trim(edtCode.Text));
      lstMsg.ItemIndex := lstMsg.Count - 1;
    end;
  end;

  //2、拷贝Demo工程到工程文件夹
  CrtNo := CrtNo + 1;
  lstMsg.Items.Add(IntToStr(CrtNo) + '、 拷贝Demo工程.....');
  lstMsg.ItemIndex := lstMsg.Count - 1;
  for I := 0 to 10 do
  begin
    fSrcFile := TFileStream.Create('../../../pub/lnkDll/' + sSrcPath[I],fmOpenRead);
    try
      fDstFile := TFileStream.Create('../../../src/'+trim(edtMan.Text) + '_' + Trim(edtCode.Text) +'/'+ sDstPath[i],fmOpenWrite or fmCreate);
      try
        fDstFile.CopyFrom(fSrcFile,fSrcFile.size);
      finally
        fDstFile.Free;
      end;
    finally
      fSrcFile.Free;
    end;
    lstMsg.Items.Add('      成功拷贝['+sSrcPath[i] + ']到[' + sDstPath[i] +']！');
    lstMsg.ItemIndex := lstMsg.Count - 1;
  end;

  //3、创建模块ID
  CrtNo := CrtNo + 1;
  lstMsg.Items.Add(IntToStr(CrtNo) + '、 创建模块ID......');
  lstMsg.ItemIndex := lstMsg.Count - 1;
  ModuleID := Trim(edtCode.Text)+'by'+trim(edtMan.Text);
  if Length(ModuleID) < 20 then
  begin
    for I := 1 to 20 - Length(ModuleID) do
    begin
      ModuleID := ModuleID+'0';
    end;
  end;
  lstMsg.Items.Add('      模块ID:' + ModuleID);
  lstMsg.ItemIndex := lstMsg.Count - 1;

  //4、重写模块信息
  CrtNo := CrtNo + 1;
  lstMsg.Items.Add(IntToStr(CrtNo) + '、 重写模块信息......');
  lstMsg.ItemIndex := lstMsg.Count - 1;
  for I := 0 to 10 do
  begin
    if i = 2 then
    begin
      Continue;
    end;
    if i > 8 then
    begin
      Break;
    end;
    //读取文件
    sFileTxt := '../../../src/'+trim(edtMan.Text) + '_' + Trim(edtCode.Text)
                                    +'/'+ sDstPath[i];
    assignFile(tFile,sFileTxt);
    Reset(tFile);
    mmo1.Clear;
    sFileTxt := '';
    lstMsg.Items.Add('      成功读取文件[' + sDstPath[i] +']！');
    lstMsg.ItemIndex := lstMsg.Count - 1;
    while not Eof(tFile) do
    begin
      Readln(tFile,sFileTxt);
      if (i = 8) and (nFlag = 0) then
      begin
        sFileTxt :='<Project xmlns="http://schemas.microsoft.com/developer/msbuild/2003">';
        nFlag := 1;
      end;
      mmo1.Lines.add(sFileTxt);
    end;
    CloseFile(tFile);

    mmo1.Text := StringReplace(mmo1.Text,PChar('lnkDll00000000000000'),PChar(ModuleID),[rfReplaceAll]);
    mmo1.Text := StringReplace(mmo1.Text,PChar('lnkDll'),PChar(Trim(edtCode.Text)),[rfReplaceAll]);
    mmo1.Text := StringReplace(mmo1.Text,PChar('Dll'),PChar(SetFirstUpper(Trim(edtCode.Text))),[rfReplaceAll]);
    mmo1.Text := StringReplace(mmo1.Text,PChar('Gen' + SetFirstUpper(Trim(edtCode.Text))),PChar('GenDll'),[rfReplaceAll]);

    //重写文件
    sFileTxt := '../../../src/'+trim(edtMan.Text) + '_' + Trim(edtCode.Text)
                                    +'/'+ sDstPath[i];
    assignFile(tFile,sFileTxt);
    Rewrite(tFile);
    for j := 0 to mmo1.Lines.Count - 1 do
    begin
      Writeln(tFile,mmo1.Lines[j]);
    end;
    CloseFile(tFile);
    lstMsg.Items.Add('      成功重写文件[' + sDstPath[i] +']！');
    lstMsg.ItemIndex := lstMsg.Count - 1;
  end;
  //模块写入数据库
  CrtNo := CrtNo + 1;
  lstMsg.Items.Add(IntToStr(CrtNo) + '、 正在生成数据库脚本.....');
  lstMsg.ItemIndex := lstMsg.Count - 1;

  sFileTxt := 'InitNewModule.sql';
  assignFile(tFile,sFileTxt);
  Rewrite(tFile);

  sSql := 'delete from tModule where FID = '''+ ModuleID +''';';
  Writeln(tFile,sSql);
  sSql := 'go';
  Writeln(tFile,sSql);
  sSql := 'insert into tModule values(''' + ModuleID + ''','''
        + edtName.Text + ''',''' + edtCode.Text + ''',''False'');';
  Writeln(tFile,sSql);

  CloseFile(tFile);
  lstMsg.Items.Add('      成功生成数据库脚本！');
  lstMsg.ItemIndex := lstMsg.Count - 1;

  //通过SQLCMD直接提交SQL文件
  CrtNo := CrtNo + 1;
  lstMsg.Items.Add(IntToStr(CrtNo) + '、 正在执行数据库脚本.....');
  lstMsg.ItemIndex := lstMsg.Count - 1;
  ShellExecute(Handle, 'open','SQLCMD.exe',PWideChar('-S 127.0.0.1 -E -d LnkSys -i "' +sFileTxt + '"'), nil, SW_HIDE);

  lstMsg.Items.Add('      成功执行数据库脚本！');
  lstMsg.ItemIndex := lstMsg.Count - 1;
  lstMsg.Items.Add('创建工程成功！');
  lstMsg.ItemIndex := lstMsg.Count - 1;


end;

procedure TfrmPrj.FormShow(Sender: TObject);
begin
  CrtNo := 0;
  ErrNo := 0;
  self.Left := (Screen.Width - Self.Width) div 2;
  Self.Top := (Screen.Height - Self.Height) div 2;
end;

end.
