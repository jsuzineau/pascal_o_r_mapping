inherited dmxcreg_becp: Tdmxcreg_becp

  Left = 382

  Top = 222

  Height = 242

  Width = 355

  object sqlq: TSQLQuery

    MaxBlobSize = -1

    Params = <>

    SQL.Strings = (

      'CREATE TABLE g_becp'
      '  ('
      '  Numero          INTEGER AUTO_INCREMENT PRIMARY KEY,'
      '  `nomclasse`     CHAR( 42) ,'
      '  `libelle`       CHAR( 42)   )'
      '')

    SQLConnection = dmDatabase.sqlc

    Left = 16

    Top = 16

  end

end

