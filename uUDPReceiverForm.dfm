object UDPReceiverForm: TUDPReceiverForm
  Left = 729
  Top = 349
  Width = 224
  Height = 77
  Caption = 'UDP Receiver'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDefaultPosOnly
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 7
    Height = 23
    Caption = '-'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object IdUDPServer1: TIdUDPServer
    Active = True
    Bindings = <>
    DefaultPort = 5000
    OnUDPRead = IdUDPServer1UDPRead
    Left = 168
    Top = 96
  end
end
