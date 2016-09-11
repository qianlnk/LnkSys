{**********************************************************************
* 文件名称: uMessage.pas
* 版本信息：2014.07(lnk)
* 文件描述：
            自定义消息单元
* 创 建 者：qianlnk
* 创建时间：2014.07.28
***********************************************************************}

unit uMessage;

interface
uses Messages;
const
  WM_USER_UNDOCK = WM_USER + 100; //停靠窗体不停靠事件
  WM_User_CALLDLL = WM_USER + 101; //运行一个DLL中的窗体消息
  WM_USER_DLLFORMEXIT = WM_USER + 102; //DLL中的窗体关闭向主窗体发送消息
  WM_USER_SHOWFORM = WM_USER + 103;
  MSG_OK = 0;
  MSG_CANCLE = 1;

implementation

end.

