unit uPublieur_sans_btree;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.adinfo.com                          |
                                 http://www.adi-bat.com                         |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
    Copyright 2017 GROUPE ADINFO SOFTWARE                                       |
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
{ uPublieur
Implémentation générique du design pattern Observer ( Publication/Abonnement )
}

interface

uses
    SysUtils, Classes,
    uBatpro_StringList;

type
 TAbonnement
 =
  class
  public
    procedure DoProc; virtual;
    function Description: String; virtual;
  end;

 TAbonnement_Procedure_Proc= procedure;
 TAbonnement_Procedure
 =
  class(TAbonnement)
  public
    Proc: TAbonnement_Procedure_Proc;
    constructor Create( uneProc: TAbonnement_Procedure_Proc);
    function Egal( uneProc: TAbonnement_Procedure_Proc): Boolean;
    procedure DoProc; override;
    function Description: String; override;
  end;

 TAbonnement_Objet_Proc= procedure of object;
 TAbonnement_Objet
 =
  class(TAbonnement)
  public
    Objet: TObject;
    Proc: TAbonnement_Objet_Proc;
    constructor Create( unObjet: TObject; uneProc: TAbonnement_Objet_Proc);
    function Egal( unObjet: TObject; uneProc: TAbonnement_Objet_Proc): Boolean;
    procedure DoProc; override;
    function Description: String; override;
  end;

 TPublieur
 =
  class( TBatpro_StringList)
  private
    function GetAbonnement          (I: Integer): TAbonnement          ;
    function GetAbonnement_Objet    (I: Integer): TAbonnement_Objet    ;
    function GetAbonnement_Procedure(I: Integer): TAbonnement_Procedure;
  public
    Name: String;
    Log_Publications: Boolean;
    procedure Abonne   ( unObjet: TObject; Proc: TAbonnement_Objet_Proc    ); overload;
    procedure Abonne   (                   Proc: TAbonnement_Procedure_Proc); overload;

    procedure Desabonne( unObjet: TObject; Proc: TAbonnement_Objet_Proc    ); overload;
    procedure Desabonne(                   Proc: TAbonnement_Procedure_Proc); overload;

    property Abonnement          [ I: Integer]: TAbonnement           read GetAbonnement          ;
    property Abonnement_Procedure[ I: Integer]: TAbonnement_Procedure read GetAbonnement_Procedure;
    property Abonnement_Objet    [ I: Integer]: TAbonnement_Objet     read GetAbonnement_Objet    ;

    function IndexOfProc( unObjet: TObject; Proc: TAbonnement_Objet_Proc    ): Integer; overload;
    function IndexOfProc(                   Proc: TAbonnement_Procedure_Proc): Integer; overload;

    procedure Publie;

    constructor Create( _Name: String);
    destructor Destroy; override;
    function Description: String;
  //Activation
  public
    Actif: Boolean;
  end;

var
   uPublieur_Indentation: String= '';
   uPublieur_Log_Publications: Boolean = False;
   uPublieur_Actif: Boolean = True;

implementation

uses
    uClean,
    ufAccueil_Erreur;

function TAbonnement.Description: String;
begin
     Result:= '';
end;

procedure TAbonnement.DoProc;
begin
end;

constructor TAbonnement_Procedure.Create( uneProc: TAbonnement_Procedure_Proc);
begin
     inherited Create;
     Proc:= uneProc;
end;

function TAbonnement_Procedure.Description: String;
begin
     Result:= uPublieur_Indentation+
              'procedure à l''adresse $'+IntToHex( Integer( @Proc), 8);
end;

procedure TAbonnement_Procedure.DoProc;
begin
     if Assigned( Proc)
     then
         Proc;
end;

function TAbonnement_Procedure.Egal( uneProc: TAbonnement_Procedure_Proc):Boolean;
begin
     Result:= @Proc = @uneProc;
end;

constructor TAbonnement_Objet.Create( unObjet: TObject;
                                      uneProc: TAbonnement_Objet_Proc);
begin
     inherited Create;
     Objet:= unObjet;
     Proc:= uneProc;
end;

function TAbonnement_Objet.Description: String;
begin
     Result:= uPublieur_Indentation+'Objet ';

     if Objet is TComponent
     then
         Result:= Result+TComponent(Objet).Name
     else
         Result:= Result+'$'+IntToHex( Integer( Objet), 8);

     Result:= Result+': '+Objet.ClassName;
end;

procedure TAbonnement_Objet.DoProc;
begin
     if Assigned( Proc)
     then
         Proc;
end;

function TAbonnement_Objet.Egal( unObjet: TObject;
                                 uneProc: TAbonnement_Objet_Proc):Boolean;
begin
     Result:= (@Proc = @uneProc) and (Objet = unObjet);
end;

constructor TPublieur.Create(_Name: String);
begin
     inherited Create;
     Name:= _Name;
     Log_Publications:= False;
     Actif:= True;
end;

destructor TPublieur.Destroy;
var
   I: Integer;
   A: TAbonnement;
begin
     for I:= 0 to Count-1
     do
       begin
       A:= Abonnement[ I];
       if Assigned( A)
       then
           begin
           Objects[I]:= nil;// équivaut sémantiquement à Abonnement[ I]:= nil
           Free_nil( A);
           end;
       end;

     inherited;
end;

procedure TPublieur.Abonne( unObjet: TObject; Proc: TAbonnement_Objet_Proc);
var
   I: Integer;
   A: TAbonnement_Objet;
begin
     I:= IndexOfProc( unObjet, Proc);
     if I = -1
     then
         begin
         A:= TAbonnement_Objet.Create( unObjet, Proc);
         AddObject( '', A);
         end;
end;

procedure TPublieur.Abonne( Proc: TAbonnement_Procedure_Proc);
var
   I: Integer;
   A: TAbonnement_Procedure;
begin
     I:= IndexOfProc( Proc);
     if I = -1
     then
         begin
         A:= TAbonnement_Procedure.Create( Proc);
         AddObject( '', A);
         end;
end;

function TPublieur.GetAbonnement(I: Integer): TAbonnement;
var
   O: TObject;
begin
     Result:= nil;
     if (I < 0)or(Count<= I) then exit;
     O:= Objects[ I];
     if O = nil then exit;
     if not (O is TAbonnement) then exit;
     Result:= O as TAbonnement;
end;

function TPublieur.GetAbonnement_Objet(I: Integer): TAbonnement_Objet;
var
   O: TObject;
begin
     Result:= nil;
     if (I < 0)or(Count<= I) then exit;
     O:= Objects[ I];
     if O = nil then exit;
     if not (O is TAbonnement_Objet) then exit;
     Result:= O as TAbonnement_Objet;
end;

function TPublieur.GetAbonnement_Procedure(I: Integer): TAbonnement_Procedure;
var
   O: TObject;
begin
     Result:= nil;
     if (I < 0)or(Count<= I) then exit;
     O:= Objects[ I];
     if O = nil then exit;
     if not (O is TAbonnement_Procedure) then exit;
     Result:= O as TAbonnement_Procedure;
end;

function TPublieur.IndexOfProc(unObjet: TObject; Proc: TAbonnement_Objet_Proc): Integer;
var
   I: Integer;
   A: TAbonnement_Objet;
begin
     Result:= -1;
     for I:= 0 to Count - 1
     do
       begin
       A:= Abonnement_Objet[ I];
       if Assigned( A)
       then
           begin
           if A.Egal( unObjet, Proc)
           then
               begin
               Result:= I;
               break;
               end;
           end;
       end;
end;

function TPublieur.IndexOfProc( Proc: TAbonnement_Procedure_Proc): Integer;
var
   I: Integer;
   A: TAbonnement_Procedure;
begin
     Result:= -1;
     for I:= 0 to Count - 1
     do
       begin
       A:= Abonnement_Procedure[ I];
       if Assigned( A)
       then
           begin
           if A.Egal( Proc)
           then
               begin
               Result:= I;
               break;
               end;
           end;
       end;
end;

procedure TPublieur.Desabonne( unObjet: TObject; Proc: TAbonnement_Objet_Proc);
var
   I: Integer;
   A: TAbonnement;
begin
     I:= IndexOfProc( unObjet, Proc);
     if I = -1 then exit;

     A:= Abonnement[ I];
     Delete( I);
     FreeAndNil( A);
end;

procedure TPublieur.Desabonne( Proc: TAbonnement_Procedure_Proc);
var
   I: Integer;
   A: TAbonnement_Procedure;
begin
     I:= IndexOfProc( Proc);
     if I = -1 then exit;

     A:= Abonnement_Procedure[ I];
     Delete( I);
     Free_nil( A);
end;

procedure TPublieur.Publie;
const
     sDelta_Indentation= '   ';
var
   Old_uPublieur_Log_Publications: Boolean;
   I: Integer;
   A: TAbonnement;
begin
     if not uPublieur_Actif then exit;
     if not Actif then exit;
     Old_uPublieur_Log_Publications:= uPublieur_Log_Publications;
     uPublieur_Indentation:= uPublieur_Indentation + sDelta_Indentation;
     try
        uPublieur_Log_Publications:= uPublieur_Log_Publications or Log_Publications;

        if uPublieur_Log_Publications
        then
            //fAccueil_Log( 'Publieur $'+IntToHex( Integer( Self), 8)+'.Publie: ');
            fAccueil_Log( uPublieur_Indentation+Name+'.Publie : ');
        uPublieur_Indentation:= uPublieur_Indentation + sDelta_Indentation;
        try
           for I:= 0 to Count - 1
           do
             begin
             A:= Abonnement[ I];
             if Assigned( A)
             then
                 begin
                 if uPublieur_Log_Publications
                 then
                     fAccueil_Log( A.Description);
                 A.DoProc;
                 end;
             end;
        finally
               System.Delete( uPublieur_Indentation, 1, Length(sDelta_Indentation));
               end;
     finally
            uPublieur_Log_Publications:= Old_uPublieur_Log_Publications;
            System.Delete( uPublieur_Indentation, 1, Length(sDelta_Indentation));
            end;
end;

function TPublieur.Description: String;
var
   I: Integer;
   A: TAbonnement;
begin
     Result:= '';
     for I:= 0 to Count - 1
     do
       begin
       A:= Abonnement[ I];
       if Assigned( A)
       then
           Result:= Result + A.Description+#13#10;
       end;
end;

end.
