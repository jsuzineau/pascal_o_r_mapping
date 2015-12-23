inherited dmxcreTULEAP_Project: TdmxcreTULEAP_Project

  Left = 382

  Top = 222

  Height = 242

  Width = 355

  object sqlq: TSQLQuery

    MaxBlobSize = -1

    Params = <>

    SQL.Strings = (

      'CREATE TABLE TULEAP_Project'
      '  ('
      '  Numero          INTEGER AUTO_INCREMENT PRIMARY KEY,'
      '  `uri`           CHAR( 42) ,'
      '  `label`         CHAR( 42) ,'
      '  `shortname`     CHAR( 42) ,'
      '  `resources`     CHAR( 42) ,'
      '  `additional_informations` CHAR( 42)   )'
      '')

    SQLConnection = dmDatabase.sqlc

    Left = 16

    Top = 16

  end

end

