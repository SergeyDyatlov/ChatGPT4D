object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'ChatGPT'
  ClientHeight = 576
  ClientWidth = 1024
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    1024
    576)
  PixelsPerInch = 96
  TextHeight = 16
  object lblSecretKey: TLabel
    Left = 16
    Top = 10
    Width = 71
    Height = 16
    Caption = 'SECRET KEY'
  end
  object edtAPIKey: TEdit
    Left = 16
    Top = 32
    Width = 992
    Height = 24
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
  end
  object memChat: TMemo
    Left = 16
    Top = 80
    Width = 992
    Height = 432
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object edtQuestion: TEdit
    Left = 16
    Top = 538
    Width = 992
    Height = 24
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 2
    OnKeyPress = edtQuestionKeyPress
  end
end
