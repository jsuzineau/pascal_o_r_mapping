unit ufGenerateur_XMI;

{$mode objfpc}{$H+}

interface

uses
    uOD_JCL,
    uXMI,
    ublAutomatic,
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, DOM;

type
 { TfGenerateur_XMI }
 TfGenerateur_XMI
 =
  class(TForm)
   m: TMemo;
    miFichier_Ouvrir: TMenuItem;
    miFichier: TMenuItem;
    mm: TMainMenu;
    od: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of string);
    procedure miFichier_OuvrirClick(Sender: TObject);
  private
    NomFichier: String;
    xmi: TXMI;
    procedure Ouvrir( _NomFichier: String);
    procedure _from_xmi;
  end;

var
 fGenerateur_XMI: TfGenerateur_XMI;

implementation

{$R *.lfm}

{ TfGenerateur_XMI }

procedure TfGenerateur_XMI.FormCreate(Sender: TObject);
begin
     xmi:= nil;
     _from_xmi;
end;

procedure TfGenerateur_XMI.FormDropFiles( Sender: TObject;
                                          const FileNames: array of string);
begin
     if Length( FileNames) < 1 then exit;

     Ouvrir(FileNames[0]);
end;

procedure TfGenerateur_XMI.miFichier_OuvrirClick(Sender: TObject);
begin
     FreeAndNil( xmi);
     if not od.Execute then exit;

     Ouvrir(od.FileName);
end;

procedure TfGenerateur_XMI.Ouvrir( _NomFichier: String);
begin
     NomFichier:= _NomFichier;
     xmi:= TXMI.Create( NomFichier);
     _from_xmi;
end;

procedure TfGenerateur_XMI._from_xmi;
   procedure Traite_Classe( _eClasse: TDOMNode);
      procedure Traite_Properties;
      var
         cirClass_Properties: TCherche_Items_Recursif;
         eProperty: TDOMNode;
         Property_Name: String;
         type_id: String;
         eType: TDOMNode;
         sType: String;
         procedure Type_not_found;
         begin
              sType:= '(non trouvé)';
         end;
      begin
           cirClass_Properties:= xmi.Get_Class_Properties( _eClasse);
           try
              for eProperty in cirClass_Properties.l
              do
                begin
                if not_Get_Property( eProperty, 'name', Property_Name) then continue;
                if not_Get_Property( eProperty, 'type', type_id      ) then continue;
                eType:= xmi.Get_type( type_id);
                     if nil = eType                            then Type_not_found
                else if not_Get_Property( eType, 'name', sType)then Type_not_found;

                m.Lines.Add( '     '+Property_Name+': '+sType);
                end;
           finally
                  FreeAndNil( cirClass_Properties);
                  end;
      end;
      procedure Traite_Operations;
      var
         cirClass_Operations: TCherche_Items_Recursif;
         eOperation: TDOMNode;
         Operation_name: String;
      begin
           cirClass_Operations:= xmi.Get_Class_Operations( _eClasse);
           try
              for eOperation in cirClass_Operations.l
              do
                begin
                if not_Get_Property( eOperation, 'name', Operation_name) then continue;

                m.Lines.Add( '     '+Operation_name+'()');
                end;
           finally
                  FreeAndNil( cirClass_Operations);
                  end;
      end;
   begin
        Traite_Properties;
        Traite_Operations;
   end;
   procedure Traite_Classes;
   var
      cirClasses: TCherche_Items_Recursif;
      eClasse: TDOMNode;
      NomClasse: String;
   begin
        cirClasses:= xmi.Get_Classes;
        try
           for eClasse in cirClasses.l
           do
             begin
             if not_Get_Property( eClasse, 'name', NomClasse) then continue;
             m.Lines.Add( '  '+NomClasse);

             Traite_Classe( eClasse);
             end;
        finally
               FreeAndNil( cirClasses);
               end;
   end;
   function Traite_Association( _eAssociation: TDOMNode): String;
   var
      cirAssociation_Ends: TCherche_Items_Recursif;
      eAssociation_End: TDOMNode;
      sAggregation: String;
      type_id: String;
      eType: TDOMNode;
      sType: String;
      procedure Type_not_found;
      begin
           sType:= '('+type_id+'non trouvé)';
      end;
   begin
        Result:= '';
        cirAssociation_Ends:= xmi.Get_Association_ends( _eAssociation);
        try
           for eAssociation_End in cirAssociation_Ends.l
           do
             begin
             type_id:= '';
             if not_Get_Property( eAssociation_End, 'aggregation', sAggregation) then continue;
             if not_Get_Property( eAssociation_End, 'type'       , type_id     ) then continue;
             if Result <> '' then Result:=  Result+ ' -> ';
             eType:= xmi.Get_type( type_id);
                  if nil = eType                            then Type_not_found
             else if not_Get_Property( eType, 'name', sType)then Type_not_found;

             Result:=  Result+sAggregation+', '+sType;
             end;
        finally
               FreeAndNil( cirAssociation_Ends);
               end;
   end;
   procedure Traite_Associations;
   var
      cirAssociations: TCherche_Items_Recursif;
      eAssociation: TDOMNode;
   begin
        cirAssociations:= xmi.Get_Associations;
        try
           for eAssociation in cirAssociations.l
           do
             m.Lines.Add( '  '+Traite_Association( eAssociation));
        finally
               FreeAndNil( cirAssociations);
               end;
   end;
begin
     m.Clear;
     if nil = xmi then exit;

     m.Lines.Add( NomFichier);
     Traite_Classes;

     m.Lines.Add( '');
     m.Lines.Add( 'Associations');
     Traite_Associations;

     m.Lines.Add( 'Début de la génération ...');
     Generateur_de_code.Execute_XMI( xmi);
     m.Lines.Add( 'Génération terminée.');
end;

end.

