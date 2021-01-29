object Form_Main: TForm_Main
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'MyChangeLocale'
  ClientHeight = 261
  ClientWidth = 367
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 11
    Width = 52
    Height = 13
    Caption = 'Hostname:'
  end
  object Label2: TLabel
    Left = 8
    Top = 78
    Width = 52
    Height = 13
    Caption = 'Username:'
  end
  object Label3: TLabel
    Left = 8
    Top = 107
    Width = 55
    Height = 13
    Caption = 'Passsword:'
  end
  object Label4: TLabel
    Left = 8
    Top = 139
    Width = 50
    Height = 13
    Caption = 'Database:'
  end
  object Label5: TLabel
    Left = 8
    Top = 44
    Width = 24
    Height = 13
    Caption = 'Port:'
  end
  object Label6: TLabel
    Left = 8
    Top = 171
    Width = 45
    Height = 13
    Caption = 'Collation:'
  end
  object Label7: TLabel
    Left = 8
    Top = 240
    Width = 147
    Height = 13
    Caption = '(c) 2021 Universal Ware GmbH'
    OnClick = Label7Click
  end
  object Edit_Hostname: TEdit
    Left = 87
    Top = 8
    Width = 170
    Height = 21
    TabOrder = 0
    OnChange = Edit_HostnameChange
  end
  object Edit_Username: TEdit
    Left = 87
    Top = 75
    Width = 170
    Height = 21
    TabOrder = 1
    OnChange = Edit_UsernameChange
  end
  object Edit_Password: TEdit
    Left = 87
    Top = 102
    Width = 170
    Height = 21
    PasswordChar = '*'
    TabOrder = 2
    OnChange = Edit_PasswordChange
  end
  object ComboBox_Database: TComboBox
    Left = 87
    Top = 136
    Width = 170
    Height = 21
    Style = csDropDownList
    Enabled = False
    TabOrder = 3
    OnChange = ComboBox_DatabaseChange
  end
  object SpinEdit_Port: TSpinEdit
    Left = 87
    Top = 41
    Width = 66
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 4
    Value = 3306
  end
  object Button_Connect: TButton
    Left = 280
    Top = 100
    Width = 75
    Height = 25
    Caption = 'Connect'
    TabOrder = 5
    OnClick = Button_ConnectClick
  end
  object ComboBox_Collations: TComboBox
    Left = 87
    Top = 168
    Width = 170
    Height = 21
    Style = csDropDownList
    Enabled = False
    TabOrder = 6
    OnChange = ComboBox_CollationsChange
  end
  object Button_Change: TButton
    Left = 280
    Top = 166
    Width = 75
    Height = 25
    Caption = 'Change'
    TabOrder = 7
    OnClick = Button_ChangeClick
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 203
    Width = 347
    Height = 17
    TabOrder = 8
  end
  object Button1: TButton
    Left = 280
    Top = 228
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 9
    OnClick = Button1Click
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Password=NT130ai'
      'DriverID=MySQL')
    Left = 272
    Top = 3
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    Left = 272
    Top = 51
  end
  object FDQuery2: TFDQuery
    Connection = FDConnection1
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    Left = 320
    Top = 51
  end
end
