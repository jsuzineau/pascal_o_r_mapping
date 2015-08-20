inherited dmxcreTag_Work: TdmxcreTag_Work

  Left = 382

  Top = 222

  Height = 242

  Width = 355

  object sqlq: TSQLQuery

    MaxBlobSize = -1

    Params = <>

    SQL.Strings = (

      'CREATE TABLE Tag_Work'
      '  ('
      '  Numero          INTEGER AUTO_INCREMENT PRIMARY KEY,'
      '  `idTag`         INTEGER   ,'
      '  `idWork`        INTEGER     )'
      '')

    SQLConnection = dmDatabase.sqlc

    Left = 16

    Top = 16

  end

end

