object FrmCategoria: TFrmCategoria
  Left = 0
  Top = 0
  Caption = 'Categoria'
  ClientHeight = 247
  ClientWidth = 407
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 30
    Width = 401
    Height = 25
    Margins.Top = 30
    Align = alTop
    Alignment = taCenter
    Caption = 'Escolha uma das categorias'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ExplicitTop = 50
  end
  object ComboBox1: TComboBox
    Left = 80
    Top = 86
    Width = 169
    Height = 21
    TabOrder = 0
    Text = 'Selecione um tipo de ve'#237'culo'
  end
  object Button1: TButton
    Left = 255
    Top = 84
    Width = 75
    Height = 25
    Caption = 'Obter'
    TabOrder = 1
    OnClick = Button1Click
  end
  object RESTClient1: TRESTClient
    BaseURL = 
      'https://service.tecnomotor.com.br/iRasther/tipo?pm.platform=1&pm' +
      '.version=23'
    Params = <>
    Left = 80
    Top = 136
  end
  object RESTRequest1: TRESTRequest
    Client = RESTClient1
    Params = <>
    Response = RESTResponse1
    Left = 168
    Top = 139
  end
  object RESTResponse1: TRESTResponse
    Left = 256
    Top = 139
  end
end
