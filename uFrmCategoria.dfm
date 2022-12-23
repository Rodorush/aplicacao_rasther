object FrmCategoria: TFrmCategoria
  Left = 0
  Top = 0
  Caption = 'Categoria'
  ClientHeight = 247
  ClientWidth = 387
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
    Width = 381
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
    ExplicitWidth = 259
  end
  object cboCategorias: TComboBox
    Left = 112
    Top = 86
    Width = 169
    Height = 21
    TabOrder = 0
    Text = 'Selecione um tipo de ve'#237'culo'
    OnSelect = cboCategoriasSelect
  end
  object RESTClientCategoria: TRESTClient
    Accept = 
      'https://service.tecnomotor.com.br/iRasther/tipo?pm.platform=1&pm' +
      '.version=23'
    Params = <>
    Left = 48
    Top = 120
  end
  object RESTRequestCategoria: TRESTRequest
    Client = RESTClientCategoria
    Params = <>
    Response = RESTResponseCategoria
    Left = 144
    Top = 155
  end
  object RESTResponseCategoria: TRESTResponse
    Left = 256
    Top = 139
  end
end
