inherited dmxcreg_becpctx: Tdmxcreg_becpctx

  Left = 382

  Top = 222

  Height = 242

  Width = 355

  object sqlq: TSQLQuery

    MaxBlobSize = -1

    Params = <>

    SQL.Strings = (

      'CREATE TABLE g_becpctx'
      '  ('
      '  Numero          INTEGER AUTO_INCREMENT PRIMARY KEY,'
      '  `nomclasse`     CHAR( 42) ,'
      '  `contexte`      INTEGER   ,'
      '  `logfont`       CHAR( 42) ,'
      '  `stringlist`    CHAR( 42)   )'
      '')

    SQLConnection = dmDatabase.sqlc

    Left = 16

    Top = 16

  end

end

