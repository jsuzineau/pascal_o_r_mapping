inherited dmxcreDevelopment: TdmxcreDevelopment

  Left = 382

  Top = 222

  Height = 242

  Width = 355

  object sqlq: TSQLQuery

    MaxBlobSize = -1

    Params = <>

    SQL.Strings = (

      'CREATE TABLE Development'
      '  ('
      '  Numero          INTEGER AUTO_INCREMENT PRIMARY KEY,'
      '  `nProject`      INTEGER   ,'
      '  `nState`        INTEGER   ,'
      '  `nCreationWork` INTEGER   ,'
      '  `nSolutionWork` INTEGER   ,'
      '  `Description`   CHAR( 42) ,'
      '  `Steps`         CHAR( 42) ,'
      '  `Origin`        CHAR( 42) ,'
      '  `Solution`      CHAR( 42) ,'
      '  `nCategorie`    INTEGER   ,'
      '  `isBug`         INTEGER   ,'
      '  `nDemander`     INTEGER   ,'
      '  `nSheetRef`     INTEGER     )'
      '')

    SQLConnection = dmDatabase.sqlc

    Left = 16

    Top = 16

  end

end

