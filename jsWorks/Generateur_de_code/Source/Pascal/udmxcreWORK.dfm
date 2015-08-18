inherited dmxcreWork: TdmxcreWork

  Left = 382

  Top = 222

  Height = 242

  Width = 355

  object sqlq: TSQLQuery

    MaxBlobSize = -1

    Params = <>

    SQL.Strings = (

      'CREATE TABLE Work'
      '  ('
      '  Numero          INTEGER AUTO_INCREMENT PRIMARY KEY,'
      '  `id`            INTEGER   ,'
      '  `nProject`      INTEGER   ,'
      '  `Beginning`     DATETIME  ,'
      '  `End`           DATETIME  ,'
      '  `Description`   CHAR( 42) ,'
      '  `nUser`         INTEGER     )'
      '')

    SQLConnection = dmDatabase.sqlc

    Left = 16

    Top = 16

  end

end

