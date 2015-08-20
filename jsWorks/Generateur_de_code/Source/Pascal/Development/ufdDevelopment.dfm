inherited fdDevelopment: TfdDevelopment
  Left = 104
  Top = 184
  Width = 1124
  Height = 371
  Caption = 'fdDevelopment'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited sLog: TSplitter
    Top = 309
    Width = 1116
  end
  inherited pSociete: TPanel
    Width = 1116
    inherited lSociete: TLabel
      Width = 1044
    end
    inherited lHeure: TLabel
      Left = 1060
    end
    inherited animation: TAnimate
      Left = 1044
    end
  end
  inherited pBas: TPanel
    Top = 268
    Width = 1116
    inherited pFermer: TPanel
      Left = 883
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 318
    Width = 1116
  end
  inherited pLog: TPanel
    Top = 315
    Width = 1116
    Height = 3
    inherited lLog: TLabel
      Width = 1114
    end
    inherited mLog: TMemo
      Width = 1114
      Height = 0
    end
  end
  object Panel1: TPanel [5]
    Left = 0
    Top = 18
    Width = 1116
    Height = 250
    Align = alClient
    ParentBackground = False
    TabOrder = 4
    object lNPROJECT: TLabel
      Caption = 'nProject'    
      Left = 16           
      Top = 26                          
      Height = 13                               
    end                                         
    object lNSTATE: TLabel
      Caption = 'nState'    
      Left = 16           
      Top = 48                          
      Height = 13                               
    end                                         
    object lNCREATIONWORK: TLabel
      Caption = 'nCreationWork'    
      Left = 16           
      Top = 70                          
      Height = 13                               
    end                                         
    object lNSOLUTIONWORK: TLabel
      Caption = 'nSolutionWork'    
      Left = 16           
      Top = 92                          
      Height = 13                               
    end                                         
    object lDESCRIPTION: TLabel
      Caption = 'Description'    
      Left = 16           
      Top = 114                          
      Height = 13                               
    end                                         
    object lSTEPS: TLabel
      Caption = 'Steps'    
      Left = 16           
      Top = 136                          
      Height = 13                               
    end                                         
    object lORIGIN: TLabel
      Caption = 'Origin'    
      Left = 16           
      Top = 158                          
      Height = 13                               
    end                                         
    object lSOLUTION: TLabel
      Caption = 'Solution'    
      Left = 274           
      Top = 48                          
      Height = 13                               
    end                                         
    object lNCATEGORIE: TLabel
      Caption = 'nCategorie'    
      Left = 274           
      Top = 70                          
      Height = 13                               
    end                                         
    object lISBUG: TLabel
      Caption = 'isBug'    
      Left = 274           
      Top = 92                          
      Height = 13                               
    end                                         
    object lNDEMANDER: TLabel
      Caption = 'nDemander'    
      Left = 274           
      Top = 114                          
      Height = 13                               
    end                                         
    object lNSHEETREF: TLabel
      Caption = 'nSheetRef'    
      Left = 274           
      Top = 136                          
      Height = 13                               
    end                                         
    object lNomChamp: TLabel
      Left = 16
      Top = 8
      Width = 57
      Height = 13
      Caption = 'lNomChamp'
    end
    object ceNPROJECT: TChamp_Edit
      Field = 'nProject'                   
      Left = 81            
      Top = 26                           
      Height = 21                                
      Width  = 179                               
    end                                          
    object ceNSTATE: TChamp_Edit
      Field = 'nState'                   
      Left = 81            
      Top = 48                           
      Height = 21                                
      Width  = 179                               
    end                                          
    object ceNCREATIONWORK: TChamp_Edit
      Field = 'nCreationWork'                   
      Left = 81            
      Top = 70                           
      Height = 21                                
      Width  = 179                               
    end                                          
    object ceNSOLUTIONWORK: TChamp_Edit
      Field = 'nSolutionWork'                   
      Left = 81            
      Top = 92                           
      Height = 21                                
      Width  = 179                               
    end                                          
    object ceDESCRIPTION: TChamp_Edit
      Field = 'Description'                   
      Left = 81            
      Top = 114                           
      Height = 21                                
      Width  = 179                               
    end                                          
    object ceSTEPS: TChamp_Edit
      Field = 'Steps'                   
      Left = 81            
      Top = 136                           
      Height = 21                                
      Width  = 179                               
    end                                          
    object ceORIGIN: TChamp_Edit
      Field = 'Origin'                   
      Left = 81            
      Top = 158                           
      Height = 21                                
      Width  = 179                               
    end                                          
    object ceSOLUTION: TChamp_Edit
      Field = 'Solution'                   
      Left = 339            
      Top = 48                           
      Height = 21                                
      Width  = 179                               
    end                                          
    object ceNCATEGORIE: TChamp_Edit
      Field = 'nCategorie'                   
      Left = 339            
      Top = 70                           
      Height = 21                                
      Width  = 179                               
    end                                          
    object ceISBUG: TChamp_Edit
      Field = 'isBug'                   
      Left = 339            
      Top = 92                           
      Height = 21                                
      Width  = 179                               
    end                                          
    object ceNDEMANDER: TChamp_Edit
      Field = 'nDemander'                   
      Left = 339            
      Top = 114                           
      Height = 21                                
      Width  = 179                               
    end                                          
    object ceNSHEETREF: TChamp_Edit
      Field = 'nSheetRef'                   
      Left = 339            
      Top = 136                           
      Height = 21                                
      Width  = 179                               
    end                                          
    object ceNomChamp: TChamp_Edit
      Left = 81
      Top = 4
      Width = 121
      Height = 21
      TabOrder = 0
      Text = 'ceNomChamp'
    end
  end
end
