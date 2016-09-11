object frmPrj: TfrmPrj
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'lnkSys-'#26032#24314#24037#31243
  ClientHeight = 411
  ClientWidth = 1113
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object lbl1: TLabel
    Left = 56
    Top = 16
    Width = 60
    Height = 16
    Caption = #24037#31243#21517#31216
  end
  object lbl2: TLabel
    Left = 56
    Top = 57
    Width = 60
    Height = 16
    Caption = #24037#31243#20195#30721
  end
  object lbl3: TLabel
    Left = 56
    Top = 98
    Width = 61
    Height = 16
    Caption = #21019'  '#24314'  '#32773
  end
  object edtName: TEdit
    Left = 128
    Top = 13
    Width = 120
    Height = 24
    TabOrder = 0
  end
  object edtCode: TEdit
    Left = 128
    Top = 54
    Width = 120
    Height = 24
    TabOrder = 1
  end
  object edtMan: TEdit
    Left = 128
    Top = 95
    Width = 120
    Height = 24
    TabOrder = 2
  end
  object btnSure: TBitBtn
    Left = 56
    Top = 132
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 3
    OnClick = btnSureClick
  end
  object btnCancel: TBitBtn
    Left = 173
    Top = 132
    Width = 75
    Height = 25
    Caption = #20851#38381
    TabOrder = 4
    OnClick = btnCancelClick
  end
  object lstMsg: TListBox
    Left = 0
    Top = 168
    Width = 1113
    Height = 243
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    Items.Strings = (
      
        '****************************************************************' +
        '***********'
      
        '************************** 2014.08.18 created by qianlnk *******' +
        '*******************'
      
        '****************************************************************' +
        '***********'
      #27880#24847#20107#39033#65306
      '1'#12289#26412#24212#29992#31243#24207#25552#20132#25968#25454#24211#33050#26412#21040#26412#22320#25968#25454#24211#65288#36825#37324#19981#37319#29992'ADO'#36830#25509#25216#26415#65292#20351#24471#31243#24207#26356#28789#27963#65289
      '2'#12289#24037#31243#21517#31216#20026#20013#25991#65288#20316#20026#27169#22359#33756#21333#36873#25321#39033#30340#21517#31216#65289
      '3'#12289#24037#31243#20195#30721#19968#33324#20026#24037#31243#21517#31216#39318#23383#27597#65288#24037#31243#25991#20214#21517#31216#20027#35201#21442#32771#21442#25968#65289
      '4'#12289#21019#24314#32773#20026#24320#21457#20154#21592#22995#21517#39318#23383#27597#65288#24037#31243#25991#20214#22841#21517#31216#20026#24320#21457#20154#21592#22995#21517#39318#23383#27597'_'#24037#31243#20195#30721#65289)
    ParentFont = False
    TabOrder = 5
  end
  object mmo1: TMemo
    Left = 302
    Top = 0
    Width = 811
    Height = 165
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 6
  end
end
