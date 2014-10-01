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
end
