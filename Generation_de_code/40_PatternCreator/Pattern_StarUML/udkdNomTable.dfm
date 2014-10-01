inherited dkdNomTable: TdkdNomTable
  Caption = 'dkdNomTable'
  PixelsPerInch = 96
  TextHeight = 13
  inherited dbg: TDBGrid
    OnCellClick = dbgCellClick
    OnKeyPress = dbgKeyPress
  end
  inherited pBas: TPanel
    inherited Panel2: TPanel
      inherited dbn: TDBNavigator
        Hints.Strings = ()
      end
    end
    inherited bImprimer: TBitBtn
      OnClick = bImprimerClick
    end
  end
  inherited pHaut: TPanel
    object Label2: TLabel [0]
      Left = 56
      Top = 9
      Width = 52
      Height = 13
      Caption = 'Ordre de tri'
    end
    inherited cbActif: TCheckBox
      Width = 44
    end
    inherited cbReadOnly: TCheckBox
      Left = 344
      OnClick = nil
    end
    object cbIndexName: TComboBox
      Left = 117
      Top = 4
      Width = 220
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      OnChange = cbIndexNameChange
    end
  end
end
