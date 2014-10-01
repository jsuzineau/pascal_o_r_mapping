inherited fNomTable: TfNomTable
  Caption = 'NomTable'
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel1: TPanel
    inherited Panel2: TPanel
      inherited dbn: TDBNavigator
        DataSource = dmNomTable.ds
        Hints.Strings = ()
      end
      inherited bImprimer: TBitBtn
        OnClick = bImprimerClick
      end
    end
    inherited dbg: TDBGrid
      Top = 31
      Height = 293
      DataSource = dmNomTable.ds
      OnCellClick = dbgCellClick
      OnKeyPress = dbgKeyPress
    end
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 860
      Height = 30
      Align = alTop
      TabOrder = 2
      object Label2: TLabel
        Left = 8
        Top = 8
        Width = 52
        Height = 13
        Caption = 'Ordre de tri'
      end
      object cbIndexName: TComboBox
        Left = 69
        Top = 3
        Width = 220
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        OnChange = cbIndexNameChange
      end
    end
  end
end
