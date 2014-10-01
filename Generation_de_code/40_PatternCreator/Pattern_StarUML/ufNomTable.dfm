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
      DataSource = dmNomTable.ds
      OnCellClick = dbgCellClick
      OnKeyPress = dbgKeyPress
    end
    inherited Panel3: TPanel
      object Label2: TLabel [0]
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
        TabOrder = 1
        OnChange = cbIndexNameChange
      end
    end
  end
end
