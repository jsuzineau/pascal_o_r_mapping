object dmxtReal_Field_Formatter: TdmxtReal_Field_Formatter
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 283
  Top = 129
  Height = 202
  Width = 265
  object cd: TClientDataSet
    Aggregates = <>
    AggregatesActive = True
    FieldDefs = <
      item
        Name = 'Float'
        DataType = ftFloat
      end
      item
        Name = 'BCD'
        DataType = ftBCD
        Precision = 32
        Size = 4
      end
      item
        Name = 'FMTBCD'
        DataType = ftFMTBcd
        Precision = 32
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 24
    Top = 16
    object cdFloat: TFloatField
      FieldName = 'Float'
    end
    object cdBCD: TBCDField
      FieldName = 'BCD'
      Precision = 32
    end
    object cdFMTBCD: TFMTBCDField
      FieldName = 'FMTBCD'
      Precision = 32
      Size = 0
    end
    object cdAggregate: TAggregateField
      FieldName = 'Aggregate'
      Active = True
      Expression = 'sum(Float)'
    end
  end
end
