object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 312
  ClientWidth = 581
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ListView1: TListView
    Left = 8
    Top = 40
    Width = 449
    Height = 249
    Columns = <>
    TabOrder = 0
  end
  object Button1: TButton
    Left = 472
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Set path'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 8
    Width = 449
    Height = 21
    TabOrder = 2
    Text = 'C:\'
  end
end
