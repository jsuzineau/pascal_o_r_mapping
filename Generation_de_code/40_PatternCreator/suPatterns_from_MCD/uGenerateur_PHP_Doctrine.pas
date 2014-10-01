unit uGenerateur_PHP_Doctrine;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
    Copyright 2014 Cabinet Gilles DOUTRE - BATPRO                               |
                                                                                |
    This program is free software: you can redistribute it and/or modify        |
    it under the terms of the GNU Lesser General Public License as published by |
    the Free Software Foundation, either version 3 of the License, or           |
    (at your option) any later version.                                         |
                                                                                |
    This program is distributed in the hope that it will be useful,             |
    but WITHOUT ANY WARRANTY; without even the implied warranty of              |
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               |
    GNU Lesser General Public License for more details.                         |
                                                                                |
    You should have received a copy of the GNU Lesser General Public License    |
    along with this program.  If not, see <http://www.gnu.org/licenses/>.       |
                                                                                |
|                                                                               }

interface

uses
    StarUML_TLB,
    uPatternHandler,
    ucsMenuHandler,
    uGlobal,
    uContexteClasse,
    uContexteMembre,
    uJoinPoint,
    ujpNomTable,
    ujpNomTableMinuscule,
    ujpPHP_Doctrine_Has_Column,
    ujpPHP_Doctrine_HasMany,
    ujpPHP_Doctrine_HasOne,
    Windows, SysUtils, Classes, ComObj, ActiveX, StdVcl, Dialogs, Forms,Inifiles;

type
 TGenerateur_PHP_Doctrine
 =
  class
  private
    a: array of TJoinPoint;
    procedure Initialise( _a: array of TJoinPoint);
  public
    StarUMLApp: IStarUMLApplication;
    procedure CreateFiles_PHP;
  end;

var
   Generateur_PHP_Doctrine: TGenerateur_PHP_Doctrine= nil;

implementation

{ TGenerateur_PHP_Doctrine }

procedure TGenerateur_PHP_Doctrine.CreateFiles_PHP;
const
     sys_Vide                 = '';

     s_Order_By_Key           = '      Order_By_Key';

     s_Traite_Index_key       ='{Traite_Index_key}';
var
   NomFichierProjet: String;
   Project: IUMLProject;
   ModelElement: IUMLModelElement;
   TaggedValue: ITaggedValue;
   cc: TContexteClasse;
   sTaggedValues: String;

   sRepSource, sRepCible: String;

   Order_By_Key: String;

   Traite_Index_key
                             :String;

   phPHP_record: TPatternHandler;
   phPHP_table : TPatternHandler;
   slParametres: TStringList;

   INI: TIniFile;


   nfLibelle : String;
   nfOrder_By: String;
   nfIndex   : String;
   slLibelle :TStringList;
   slOrder_By:TStringList;
   slIndex   :TStringList;

   //Gestion des détails
   NbDetails: Integer;
   nfDetails: String;
   slDetails:TStringList;

   slChamps_non_order_by: TStringList;

   procedure CreePatternHandler( var phPAS, phDFM: TPatternHandler; Racine: String);
   var
      sRepRacine: String;
   begin
        sRepRacine:= sRepSource+'u'+Racine+s_NomTable;
        phPAS:= TPatternHandler.Create( sRepRacine+'.PAS',sRepCible,slParametres);
        phDFM:= TPatternHandler.Create( sRepRacine+'.DFM',sRepCible,slParametres);
   end;

   procedure CreePatternHandler_PHP( var phRecord, phTable: TPatternHandler);
   begin
        phRecord:= TPatternHandler.Create( sRepSource+s_NomTable+'.class.php',sRepCible,slParametres);
        phTable := TPatternHandler.Create( sRepSource+'t'+s_NomTable+'.class.php',sRepCible,slParametres);
   end;

   procedure AjouteIndex( sNomChamp: String);
   begin
        Traite_Index_key:=  Traite_Index_key
                           +'     Traite_Index( '''+sNomChamp+''');'#13#10;
   end;

   procedure Traite_Member( Member: IUMLAttribute);
   var
      cm: TContexteMembre;
      sParametre: String;
      sDeclarationParametre: String;
   begin
        cm:= TContexteMembre.Create( cc, Member);
        try
           uJoinPoint_VisiteMembre( cm, a);
           if cm.CleEtrangere
           then
               AjouteIndex( cm.sNomChamp);


           sParametre:= ' _'+cm.sNomChamp;
           sDeclarationParametre:= sParametre+': '+cm.sTyp;

           if cm.CleEtrangere
           then
               begin
               slChamps_non_order_by.Add( cm.Member_Name);

               //Ajout comme détail
               slDetails:= TStringList.Create;
               try
                  nfDetails:= sRepSource+cm.sNomTableMembre+'.Details.txt';
                  if FileExists( nfDetails)
                  then
                      slDetails.LoadFromFile( nfDetails);
                  slDetails.Values[ cm.sDetail]:= cc.NomTable;
               finally
                      slDetails.SaveToFile( nfDetails);
                      FreeAndNil( slDetails);
                      end;
               end;
           finally
                  FreeAndNil( cm);
                  end;
   end;
   procedure Produit;
   begin
        phPHP_record.Produit('');
        phPHP_table .Produit('');
   end;
   function Allowed_in_order_by( NomChamp: String): Boolean;
   begin
        Result:= -1 = slChamps_non_order_by.IndexOf( NomChamp);
   end;
   procedure Visite_NameSpace( NameSpace: IUMLNameSpace);
   var
      I, J: Integer;
   begin
        for I:= 0 to NameSpace.GetOwnedElementCount-1
        do
          begin
          ModelElement:= NameSpace.GetOwnedElementAt( I);
               if    ModelElement.IsKindOf( 'UMLNameSpace')
                  or ModelElement.IsKindOf( 'UMLModel')
          then
              Visite_NameSpace( ModelElement as IUMLNameSpace)
          else if ModelElement.IsKindOf( 'UMLClass')
          then
              begin
              cc:= TContexteClasse.Create( ModelElement as IUMLClass);
              try
                 slChamps_non_order_by.Clear;
                 slParametres.Clear;

                 if    ('TObject'   <>cc._Classe_Name)
                    and('IInterface'<>cc._Classe_Name)
                    and('IUnknown'  <>cc._Classe_Name)
                 then
                     begin
                     uJoinPoint_Initialise( cc, a);

                     Traite_Index_key         := '';

                     if cc.Classe.getTaggedValueCount > 0
                     then
                         begin
                         sTaggedValues:= '';
                         for J:= 0 to cc.Classe.GetTaggedValueCount-1
                         do
                           begin
                           TaggedValue:= cc.Classe.GetTaggedValueAt(J);
                           sTaggedValues
                           :=
                               sTaggedValues
                             + TaggedValue.Name
                             + '='
                             + TaggedValue.DataValue;
                           end;
                         ShowMessage( sTaggedValues);
                         end;

                     for J:= 0 to cc.Classe.GetAttributeCount-1
                     do
                       Traite_Member( cc.Classe.GetAttributeAt(J));

                     //Gestion du libellé
                     slLibelle:= TStringList.Create;
                     try
                        nfLibelle:= sRepSource+cc.NomTable+'.libelle.txt';
                        if FileExists( nfLibelle)
                        then
                            slLibelle.LoadFromFile( nfLibelle);
                        for J:= 0 to slLibelle.Count-1
                        do
                          begin
                          end;
                     finally
                            slLibelle.SaveToFile( nfLibelle);
                            FreeAndNil( slLibelle);
                            end;

                     //Gestion de l'order by
                     slOrder_by:= TStringList.Create;
                     try
                        nfOrder_By:= sRepSource+cc.NomTable+'.order_by.txt';
                             if FileExists( nfOrder_By)
                        then
                            slOrder_by.LoadFromFile( nfOrder_By)
                        else if FileExists( nfLibelle)
                        then
                            slOrder_by.LoadFromFile( nfLibelle);

                        Order_By_Key:= '';
                        for J:= 0 to slOrder_by.Count-1
                        do
                          begin
                          if Allowed_in_order_by( slOrder_by.Strings[J])
                          then
                              begin
                              if Order_By_Key = sys_Vide
                              then Order_By_Key:= Order_By_Key+ '      '
                              else Order_By_Key:= Order_By_Key+ ','+s_SQL_saut+'      ';
                              Order_By_Key:= Order_By_Key + slOrder_by.Strings[J];
                              end;
                          end;
                        if Order_By_Key = sys_Vide
                        then
                            Order_By_Key:= '      Numero';
                     finally
                            slOrder_by.SaveToFile( nfOrder_By);
                            FreeAndNil( slOrder_by);
                            end;

                     //Gestion des index suplémentaires
                     slIndex:= TStringList.Create;
                     try
                        nfIndex:= sRepSource+cc.NomTable+'.Index.txt';
                             if FileExists( nfIndex)
                        then
                            slIndex.LoadFromFile( nfIndex);
                        for J:= 0 to slIndex.Count-1
                        do
                          AjouteIndex( slIndex.Strings[J]);
                     finally
                            slIndex.SaveToFile( nfIndex);
                            FreeAndNil( slIndex);
                            end;

                     //Gestion des détails
                     slDetails:= TStringList.Create;
                     try
                        nfDetails:= sRepSource+cc.NomTable+'.Details.txt';
                        if FileExists( nfDetails)
                        then
                            slDetails.LoadFromFile( nfDetails);
                        NbDetails:= slDetails.Count;
                        for J:= 0 to NbDetails-1
                        do
                          uJoinPoint_VisiteDetail( slDetails.Names[J],
                                                   slDetails.ValueFromIndex[J],
                                                   a);
                     finally
                            slDetails.SaveToFile( nfDetails);
                            FreeAndNil( slDetails);
                            end;

                     //Fermeture des chaines
                     uJoinPoint_Finalise( a);

                     slParametres.Values[s_Order_By_Key  ]:= Order_By_Key  ;
                     slParametres.Values[s_Traite_Index_key       ]:= Traite_Index_key;
                     uJoinPoint_To_Parametres( slParametres, a);

                     Produit;
                     //slLog.Add( 'aprés Produit');
                     end;
                 Premiere_Classe:= False;
              finally
                     FreeAndNil( cc)
                     end;
              end;
          end;
   end;
begin
     NomFichierProjet:= StarUMLApp.ProjectManager.FileName;
     INI
     :=
       TIniFile.Create( ChangeFileExt(NomFichierProjet,'_StarUML_PHP_Doctrine.ini'));
     try
        sRepSource:= INI.ReadString( 'Options', 'sRepSource', ExtractFilePath(NomFichierProjet)+'Source\patterns\');
        sRepCible := INI.ReadString( 'Options', 'sRepCible' , ExtractFilePath(NomFichierProjet)+'Source\');
        INI.WriteString( 'Options', 'sRepSource', sRepSource);
        INI.WriteString( 'Options', 'sRepCible' , sRepCible );

        slParametres:= TStringList.Create;
        slLog.Clear;
        try
           CreePatternHandler_PHP( phPHP_record, phPHP_table);
           slChamps_non_order_by:= TStringList.Create;
           try
              S:= '';
              Premiere_Classe:= True;
              Project:= StarUMLApp.ProjectManager.Project;

              Visite_NameSpace( Project);

              slLog.Add( S);
           finally
                  FreeAndNil( slChamps_non_order_by);
                  FreeAndNil( phPHP_record);
                  FreeAndNil( phPHP_table );
                  end;
        finally
               slLog.SaveToFile( sRepCible+'suPatterns_from_MCD.log');
               FreeAndNil( slParametres);
               end;

        ShowMessage( 'suPatterns_from_MCD exécuté avec succés');
     finally
            FreeAndNil( INI);
            end;
end;

procedure TGenerateur_PHP_Doctrine.Initialise(_a: array of TJoinPoint);
var
   I: Integer;
begin
     SetLength( a, Length(_a));
     for I:= Low( _a) to High( _a)
     do
       a[I]:= _a[I];
end;

initialization
              Generateur_PHP_Doctrine:= TGenerateur_PHP_Doctrine.Create;
              Generateur_PHP_Doctrine.Initialise(
                                           [
                                           jpPHP_Doctrine_Has_Column,
                                           jpPHP_Doctrine_HasMany,
                                           jpPHP_Doctrine_HasOne,
                                           jpNomTableMinuscule      ,
                                           jpNomTable
                                           ]
                                           );
finalization
              FreeAndNil( Generateur_PHP_Doctrine);
end.
