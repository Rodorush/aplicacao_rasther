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
      end
    end
    object Sobre1: TMenuItem
      Caption = '&Sobre'
    end
  end
end
