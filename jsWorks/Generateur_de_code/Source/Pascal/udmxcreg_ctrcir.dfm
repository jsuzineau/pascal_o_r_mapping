inherited dmxcreg_ctrcir: Tdmxcreg_ctrcir

  Left = 382

  Top = 222

  Height = 242

  Width = 355

  object sqlq: TSQLQuery

    MaxBlobSize = -1

    Params = <>

    SQL.Strings = (

      'CREATE TABLE g_ctrcir'
      '  ('
      '  Numero          INTEGER AUTO_INCREMENT PRIMARY KEY,'
      '  `soc`           CHAR( 42) ,'
      '  `ets`           CHAR( 42) ,'
      '  `type`          CHAR( 42) ,'
      '  `circuit`       CHAR( 42) ,'
      '  `no_reference`  CHAR( 42) ,'
      '  `d1`            CHAR( 42) ,'
      '  `d2`            CHAR( 42) ,'
      '  `d3`            CHAR( 42) ,'
      '  `ok_d1`         CHAR( 42) ,'
      '  `ok_d2`         CHAR( 42) ,'
      '  `ok_d3`         CHAR( 42) ,'
      '  `date_ok1`      DATETIME  ,'
      '  `date_ok2`      DATETIME  ,'
      '  `date_ok3`      DATETIME    )'
      '')

    SQLConnection = dmDatabase.sqlc

    Left = 16

    Top = 16

  end

end

