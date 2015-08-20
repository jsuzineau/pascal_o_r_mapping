inherited dmxcreg_ctr: Tdmxcreg_ctr

  Left = 382

  Top = 222

  Height = 242

  Width = 355

  object sqlq: TSQLQuery

    MaxBlobSize = -1

    Params = <>

    SQL.Strings = (

      'CREATE TABLE g_ctr'
      '  ('
      '  Numero          INTEGER AUTO_INCREMENT PRIMARY KEY,'
      '  `soc`           CHAR( 42) ,'
      '  `ets`           CHAR( 42) ,'
      '  `code`          CHAR( 42) ,'
      '  `libelle`       CHAR( 42)   )'
      '')

    SQLConnection = dmDatabase.sqlc

    Left = 16

    Top = 16

  end

end

