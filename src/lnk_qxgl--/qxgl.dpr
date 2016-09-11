library qxgl;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  System.SysUtils,
  System.Classes,
  Windows,
  forms,
  dbtables,
  ADODB,
  uMessage in '..\..\pub\uMessage.pas',
  uQxglMain in 'uQxglMain.pas' {QxglMain};

{$R *.res}
 var
  SaveDLLApp: TApplication;
{
  功能：生成MDICHILDFORM
  参数：APP传入的应用程序句柄
        CORBACONNECT和APP SERVER连接的句柄
        FRM窗口指针（传出）
}

procedure CreateForm(App: TApplication; adoCon: TAdoConnection; sUser: string; var frm: TForm);stdcall;export;
var
  frmDll: TQxglMain;
  strMsg: string;
  strTitle: string;
begin
  if  not  Assigned(SaveDllApp)  then
  begin
    SaveDllApp:= Application;
    Application := App;
  end;



  //MODIFY 创建窗体
  frmDll := TQxglMain.Create(Application);
  with frmDll do
  begin
    FormStyle := fsMDIChild;
    m_user := sUser;
    con1 := adoCon;
    frm := frmDll;
  end;
end;
procedure  MyLibraryProc(Reason:integer);
begin
  if  Reason=0 then
  begin
    Application := SaveDllApp;

  end;
end;
exports
  CreateForm;

begin
  DllProc:=@MyLibraryProc;
end.


