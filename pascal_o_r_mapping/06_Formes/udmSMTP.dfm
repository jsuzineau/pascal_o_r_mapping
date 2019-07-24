object dmSMTP: TdmSMTP
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 638
  Top = 310
  Height = 155
  Width = 138
  object Message: TIdMessage
    AttachmentEncoding = 'UUE'
    BccList = <>
    CCList = <>
    Encoding = meDefault
    FromList = <
      item
      end>
    Recipients = <>
    ReplyTo = <>
    ConvertPreamble = True
    Left = 48
    Top = 16
  end
  object smtp: TIdSMTP
    MailAgent = 'Batpro Sauvegarde'
    AuthType = atNone
    Host = 'smtp.free.net'
    SASLMechanisms = <>
    Left = 48
    Top = 64
  end
end
