object SliderExampleForm: TSliderExampleForm
  Left = 288
  Top = 101
  Width = 490
  Height = 330
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'Touch Screen Slider GUI'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 457
    Height = 289
  end
  object Label0: TLabel
    Left = 24
    Top = 272
    Width = 31
    Height = 13
    Caption = 'Label0'
  end
  object Label1: TLabel
    Left = 80
    Top = 272
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object Timer1: TTimer
    Interval = 15
    OnTimer = Timer1Timer
    Left = 176
    Top = 168
  end
  object UdpClient: TIdUDPClient
    Active = True
    Host = 'localhost'
    Port = 5000
    Left = 256
    Top = 160
  end
end
