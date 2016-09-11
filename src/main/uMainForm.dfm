object FrmMain: TFrmMain
  Left = 0
  Top = 0
  Caption = 'FrmMain'
  ClientHeight = 424
  ClientWidth = 569
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu
  OldCreateOrder = False
  Position = poDesigned
  Visible = True
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 405
    Width = 569
    Height = 19
    AutoHint = True
    BiDiMode = bdLeftToRight
    Panels = <
      item
        BiDiMode = bdRightToLeft
        ParentBiDiMode = False
        Width = 300
      end>
    ParentBiDiMode = False
  end
  object ADOCon: TADOConnection
    LoginPrompt = False
    Provider = 'SQLNCLI11.1'
    Left = 344
    Top = 96
  end
  object MainMenu: TMainMenu
    AutoHotkeys = maManual
    AutoLineReduction = maManual
    BiDiMode = bdLeftToRight
    ParentBiDiMode = False
    Left = 400
    Top = 96
    object NFile: TMenuItem
      Caption = #25991#20214
      object NLogin: TMenuItem
        Caption = #29992#25143#30331#24405
        OnClick = NLoginClick
      end
      object NModifyPsw: TMenuItem
        Caption = #20462#25913#23494#30721
        OnClick = NModifyPswClick
      end
      object NLogout: TMenuItem
        Caption = #36864#20986
        OnClick = NLogoutClick
      end
    end
    object NWindows: TMenuItem
      Caption = #31383#21475
      object NCengd: TMenuItem
        Caption = #23618#21472
        OnClick = NCengdClick
      end
      object NAllMin: TMenuItem
        Caption = #20840#37096#26368#23567#21270
        OnClick = NAllMinClick
      end
      object NCloseAll: TMenuItem
        Caption = #20851#38381#25152#26377#31383#21475
        OnClick = NCloseAllClick
      end
    end
    object NHelp: TMenuItem
      Caption = #24110#21161
    end
  end
  object cdsOther: TADODataSet
    Connection = ADOCon
    Parameters = <>
    Left = 488
    Top = 152
  end
  object adsMenu1: TADODataSet
    Connection = ADOCon
    Parameters = <>
    Left = 472
    Top = 96
  end
  object adsMenu2: TADODataSet
    Connection = ADOCon
    Parameters = <>
    Left = 352
    Top = 152
  end
  object adsMenu3: TADODataSet
    Connection = ADOCon
    Parameters = <>
    Left = 424
    Top = 152
  end
end
