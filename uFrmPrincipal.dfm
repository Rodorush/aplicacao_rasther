object FrmPrincipal: TFrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Aplica'#231#227'o Rasther'
  ClientHeight = 595
  ClientWidth = 1086
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object ListBoxMontadoras: TListBox
    Left = 8
    Top = 8
    Width = 200
    Height = 579
    ItemHeight = 13
    TabOrder = 0
    Visible = False
    OnClick = ListBoxMontadorasClick
  end
  object ListBoxVeiculos: TListBox
    Left = 214
    Top = 8
    Width = 200
    Height = 579
    ItemHeight = 13
    TabOrder = 1
    Visible = False
  end
  object MainMenu1: TMainMenu
    Left = 968
    Top = 8
    object Arquivo1: TMenuItem
      Caption = '&Arquivo'
      object Novaescolha1: TMenuItem
        Caption = '&Nova escolha'
        OnClick = Novaescolha1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Sair1: TMenuItem
        Caption = '&Sair'
        OnClick = Sair1Click
      end
    end
    object Sobre1: TMenuItem
      Caption = '&Sobre'
    end
  end
  object RESTClientPrincipal: TRESTClient
    Params = <>
    Left = 968
    Top = 64
  end
  object RESTRequestPrincipal: TRESTRequest
    Client = RESTClientPrincipal
    Params = <>
    Response = RESTResponsePrincipal
    Left = 968
    Top = 120
  end
  object RESTResponsePrincipal: TRESTResponse
    Left = 968
    Top = 176
  end
end
