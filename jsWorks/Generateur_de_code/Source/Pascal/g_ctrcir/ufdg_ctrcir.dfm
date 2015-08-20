inherited fdg_ctrcir: Tfdg_ctrcir
  Left = 104
  Top = 184
  Width = 1124
  Height = 371
  Caption = 'fdg_ctrcir'
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
    object lSOC: TLabel
      Caption = 'soc'    
      Left = 16           
      Top = 26                          
      Height = 13                               
    end                                         
    object lETS: TLabel
      Caption = 'ets'    
      Left = 16           
      Top = 48                          
      Height = 13                               
    end                                         
    object lTYPE: TLabel
      Caption = 'type'    
      Left = 16           
      Top = 70                          
      Height = 13                               
    end                                         
    object lCIRCUIT: TLabel
      Caption = 'circuit'    
      Left = 16           
      Top = 92                          
      Height = 13                               
    end                                         
    object lNO_REFERENCE: TLabel
      Caption = 'no_reference'    
      Left = 16           
      Top = 114                          
      Height = 13                               
    end                                         
    object lD1: TLabel
      Caption = 'd1'    
      Left = 16           
      Top = 136                          
      Height = 13                               
    end                                         
    object lD2: TLabel
      Caption = 'd2'    
      Left = 16           
      Top = 158                          
      Height = 13                               
    end                                         
    object lD3: TLabel
      Caption = 'd3'    
      Left = 16           
      Top = 180                          
      Height = 13                               
    end                                         
    object lOK_D1: TLabel
      Caption = 'ok_d1'    
      Left = 274           
      Top = 48                          
      Height = 13                               
    end                                         
    object lOK_D2: TLabel
      Caption = 'ok_d2'    
      Left = 274           
      Top = 70                          
      Height = 13                               
    end                                         
    object lOK_D3: TLabel
      Caption = 'ok_d3'    
      Left = 274           
      Top = 92                          
      Height = 13                               
    end                                         
    object lDATE_OK1: TLabel
      Caption = 'date_ok1'    
      Left = 274           
      Top = 114                          
      Height = 13                               
    end                                         
    object lDATE_OK2: TLabel
      Caption = 'date_ok2'    
      Left = 274           
      Top = 136                          
      Height = 13                               
    end                                         
    object lDATE_OK3: TLabel
      Caption = 'date_ok3'    
      Left = 274           
      Top = 158                          
      Height = 13                               
    end                                         
    object lNomChamp: TLabel
      Left = 16
      Top = 8
      Width = 57
      Height = 13
      Caption = 'lNomChamp'
    end
    object ceSOC: TChamp_Edit
      Field = 'soc'                   
      Left = 81            
      Top = 26                           
      Height = 21                                
      Width  = 179                               
    end                                          
    object ceETS: TChamp_Edit
      Field = 'ets'                   
      Left = 81            
      Top = 48                           
      Height = 21                                
      Width  = 179                               
    end                                          
    object ceTYPE: TChamp_Edit
      Field = 'type'                   
      Left = 81            
      Top = 70                           
      Height = 21                                
      Width  = 179                               
    end                                          
    object ceCIRCUIT: TChamp_Edit
      Field = 'circuit'                   
      Left = 81            
      Top = 92                           
      Height = 21                                
      Width  = 179                               
    end                                          
    object ceNO_REFERENCE: TChamp_Edit
      Field = 'no_reference'                   
      Left = 81            
      Top = 114                           
      Height = 21                                
      Width  = 179                               
    end                                          
    object ceD1: TChamp_Edit
      Field = 'd1'                   
      Left = 81            
      Top = 136                           
      Height = 21                                
      Width  = 179                               
    end                                          
    object ceD2: TChamp_Edit
      Field = 'd2'                   
      Left = 81            
      Top = 158                           
      Height = 21                                
      Width  = 179                               
    end                                          
    object ceD3: TChamp_Edit
      Field = 'd3'                   
      Left = 81            
      Top = 180                           
      Height = 21                                
      Width  = 179                               
    end                                          
    object ceOK_D1: TChamp_Edit
      Field = 'ok_d1'                   
      Left = 339            
      Top = 48                           
      Height = 21                                
      Width  = 179                               
    end                                          
    object ceOK_D2: TChamp_Edit
      Field = 'ok_d2'                   
      Left = 339            
      Top = 70                           
      Height = 21                                
      Width  = 179                               
    end                                          
    object ceOK_D3: TChamp_Edit
      Field = 'ok_d3'                   
      Left = 339            
      Top = 92                           
      Height = 21                                
      Width  = 179                               
    end                                          
    object ceDATE_OK1: TChamp_Edit
      Field = 'date_ok1'                   
      Left = 339            
      Top = 114                           
      Height = 21                                
      Width  = 179                               
    end                                          
    object ceDATE_OK2: TChamp_Edit
      Field = 'date_ok2'                   
      Left = 339            
      Top = 136                           
      Height = 21                                
      Width  = 179                               
    end                                          
    object ceDATE_OK3: TChamp_Edit
      Field = 'date_ok3'                   
      Left = 339            
      Top = 158                           
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
