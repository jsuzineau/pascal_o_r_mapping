unit uEvaluation_Formule;
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

interface

uses
    uClean,
    uReels,
    u_sys_,
    uuStrings,

    ufAccueil_Erreur,

  SysUtils, Classes;

function Evaluation_Formule( Formule: String; var Resultat: double): String;

var
   FormuleEvaluee: String;

implementation

type
 TFormule_Noeud
 =
  class
  public
    function Calcule: double; virtual; abstract;
    function Formule: String; virtual; abstract;
    function FormuleEvaluee: String; virtual; abstract;
  end;
 TFormule_Noeud_Constante
 =
  class( TFormule_Noeud)
  public
    Valeur: Double;
    constructor Create( _Valeur: Double);
    function Calcule: double; override;
    function Formule: String; override;
    function FormuleEvaluee: String; override;
  end;
 TFormule_Noeud_Operateur_binaire
 =
  class( TFormule_Noeud)
  public
    Priorite: Integer;
    Operande1, Operande2: TFormule_Noeud;
    constructor Create;
    function FormuleEvaluee: String; override;
  end;

 TFormule_Noeud_Plus_Moins
 =
  class( TFormule_Noeud_Operateur_binaire)
  public
    constructor Create;
  end;
 TFormule_Noeud_Plus
 =
  class( TFormule_Noeud_Plus_Moins)
  public
    function Calcule: Double; override;
    function Formule: String; override;
  end;
 TFormule_Noeud_Moins
 =
  class( TFormule_Noeud_Plus_Moins)
  public
    function Calcule: Double; override;
    function Formule: String; override;
  end;
 TFormule_Noeud_Multiplier
 =
  class( TFormule_Noeud_Operateur_binaire)
  public
    constructor Create;
    function Calcule: Double; override;
    function Formule: String; override;
  end;
 TFormule_Noeud_Diviser
 =
  class( TFormule_Noeud_Operateur_binaire)
  public
    constructor Create;
    function Calcule: Double; override;
    function Formule: String; override;
  end;
var
   ElementNeutre_Addition      ,
   ElementNeutre_Multiplication,
   Unite                       : TFormule_Noeud_Constante;


{ TFormule_Noeud_Operateur_binaire }

constructor TFormule_Noeud_Operateur_binaire.Create;
begin
     inherited Create;
     Operande1:= nil;
     Operande2:= nil;
     Priorite:= 0;
end;

function TFormule_Noeud_Operateur_binaire.FormuleEvaluee: String;
begin
          if Operande1 = nil then Result:= Operande2.FormuleEvaluee
     else if Operande2 = nil then Result:= Operande1.FormuleEvaluee
     else
         Result
         :=   Operande1.FormuleEvaluee
            + Operande2.FormuleEvaluee;

         Result
         :=   Result
            + Formule+ '='+Format( '%f', [Calcule])+#13#10;
end;

{ TFormule_Noeud_Plus_Moins }

constructor TFormule_Noeud_Plus_Moins.Create;
begin
     inherited Create;
     Priorite:= 1;
     //Operande1:= ElementNeutre_Addition;
     //Operande2:= ElementNeutre_Addition;
end;

{ TFormule_Noeud_Constante }

constructor TFormule_Noeud_Constante.Create(_Valeur: Double);
begin
     Valeur:= _Valeur;
end;

function TFormule_Noeud_Constante.Calcule: double;
begin
     Result:= Valeur;
end;

function TFormule_Noeud_Constante.Formule: String;
begin
     Result:= Format( '%f', [Valeur]);
end;

function TFormule_Noeud_Constante.FormuleEvaluee: String;
begin
     Result:= '';
end;

{ TFormule_Noeud_Plus }

function TFormule_Noeud_Plus.Calcule: Double;
begin
          if Operande1 = nil then Result:= Operande2.Calcule
     else if Operande2 = nil then Result:= Operande1.Calcule
     else
         Result
         :=
             Operande1.Calcule
           + Operande2.Calcule;
end;

function TFormule_Noeud_Plus.Formule: String;
begin
          if Operande1 = nil then Result:= Operande2.Formule
     else if Operande2 = nil then Result:= Operande1.Formule
     else
         Result:= '('+Operande1.Formule+'+'+Operande2.Formule+')';
end;

{ TFormule_Noeud_Moins }

function TFormule_Noeud_Moins.Calcule: Double;
begin
          if Operande1 = nil then Result:= - Operande2.Calcule
     else if Operande2 = nil then Result:= + Operande1.Calcule
     else
         Result
         :=
             Operande1.Calcule
           - Operande2.Calcule;
end;

function TFormule_Noeud_Moins.Formule: String;
begin
          if Operande1 = nil then Result:= '(-'+Operande2.Formule+')'
     else if Operande2 = nil then Result:= Operande1.Formule
     else
         Result:= '('+Operande1.Formule+'-'+Operande2.Formule+')';
end;

{ TFormule_Noeud_Multiplier }

constructor TFormule_Noeud_Multiplier.Create;
begin
     inherited Create;
     Priorite:= 2;
     //Operande1:= ElementNeutre_Multiplication;
     //Operande2:= ElementNeutre_Multiplication;
end;

function TFormule_Noeud_Multiplier.Calcule: Double;
begin
          if Operande1 = nil then Result:= Operande2.Calcule
     else if Operande2 = nil then Result:= Operande1.Calcule
     else
         Result
         :=
             Operande1.Calcule
           * Operande2.Calcule;
end;

function TFormule_Noeud_Multiplier.Formule: String;
begin
          if Operande1 = nil then Result:= Operande2.Formule
     else if Operande2 = nil then Result:= Operande1.Formule
     else
         Result:= '('+Operande1.Formule+'*'+Operande2.Formule+')';
end;

{ TFormule_Noeud_Diviser }

constructor TFormule_Noeud_Diviser.Create;
begin
     inherited Create;
     Priorite:= 3;
     //Operande1:= Unite;
     //Operande2:= Unite;
end;

function TFormule_Noeud_Diviser.Calcule: Double;
     procedure Cas_normal;
     var
        R1, R2: Double;
     begin
          R1:= Operande1.Calcule;
          R2:= Operande2.Calcule;
          if EgalReel( R2, 0, precision_Millionnieme)
          then
              Result:= 0
          else
              Result:= R1 / R2;
     end;
begin
          if Operande1 = nil then Result:= Operande2.Calcule
     else if Operande2 = nil then Result:= Operande1.Calcule
     else
         Cas_normal;
end;
function TFormule_Noeud_Diviser.Formule: String;
begin
          if Operande1 = nil then Result:= Operande2.Formule
     else if Operande2 = nil then Result:= Operande1.Formule
     else
         Result:= '('+Operande1.Formule+'/'+Operande2.Formule+')';
end;

function Evaluation_Formule( Formule: String; var Resultat: double): String;
var
   //Analyse lexicale
   I: Integer;
   C: Char;
   Racine, Insertion, Courant: TFormule_Noeud;
   sD: String;
   D: double;
   Ignore: Boolean;
   procedure TakeChar;
   begin
        Inc( I);
        C:= Formule[I];
   end;
   function NextChar: Char;
   var
      iNextChar: Integer;
   begin
        iNextChar:= I+1;
        if iNextChar > Length( Formule)
        then
            Result:= #0
        else
            Result:= Formule[ iNextChar];
   end;
   function isCharNumeric( C: Char): Boolean;
   begin
        Result:= C in ['0'..'9',','];
   end;
   function LireNombre: String;
   begin
        Result:= sys_Vide;
        while IsCharNumeric( NextChar)
        do
          begin
          TakeChar;
          Result:= Result + C;
          end;
   end;
   function EtatCourant:String;
       procedure AjouteNoeud( Nom: String; N: TFormule_Noeud);
       begin
            if Assigned( N) then Result:= Result + Nom+ ': '+ N.Formule+#13#10;
       end;
   begin
        Result:= sys_Vide;
        AjouteNoeud( 'Racine'   , Racine   );
        AjouteNoeud( 'Insertion', Insertion);
        AjouteNoeud( 'Courant'  , Courant  );
   end;
   procedure Traite_Courant;
   var
      oInsertion, oCourant: TFormule_Noeud_Operateur_binaire;
   begin
        if Racine = nil
        then
            begin
            Racine   := Courant;
            Insertion:= Courant;
            exit;
            end;

        if Insertion is TFormule_Noeud_Constante
        then
            begin
            if Courant is TFormule_Noeud_Operateur_binaire
            then
                //On ne passe ici que sur le premier noeud valeur quantité rencontré
                begin
                oCourant:= TFormule_Noeud_Operateur_binaire( Courant);

                oCourant.Operande1:= Racine;

                Insertion:= Courant;
                Racine   := Courant;
                end
            else
                fAccueil_LogBas( Format( 'Erreur de syntaxe dans la formule:'#13#10+
                                         '  >%s<'#13#10+
                                         'Deux valeurs sont combinées entre elles sans opérateur.'#13#10+
                                         'au caractère %d'#13#10,
                                         [Formule, I] )+EtatCourant);
            end
        else if Insertion is TFormule_Noeud_Operateur_binaire
        then
            begin
            oInsertion:= TFormule_Noeud_Operateur_binaire( Insertion);
            if oInsertion.Operande2 = nil
            then
                if Courant is TFormule_Noeud_Operateur_binaire
                then
                    fAccueil_LogBas( Format( 'Erreur de syntaxe dans la formule:'#13#10+
                                             '  >%s<'#13#10+
                                             'Deux opérateurs sont combinés entre eux sans valeurs.'#13#10+
                                             'au caractère %d'#13#10,
                                             [Formule, I])+EtatCourant)
                else
                    oInsertion.Operande2:= Courant
            else
                if Courant is TFormule_Noeud_Operateur_binaire
                then
                    begin
                    oCourant:= TFormule_Noeud_Operateur_binaire( Courant);
                    if oCourant.Priorite > oInsertion.Priorite
                    then
                        begin
                        oCourant  .Operande1:= oInsertion.Operande2;
                        oInsertion.Operande2:= Courant;
                        Insertion:= Courant;
                        end
                    else
                        begin
                        oCourant.Operande1:= Insertion;
                        Insertion:= Courant;
                        Racine   := Courant;
                        end;
                    end
                else
                    fAccueil_LogBas( Format( 'Erreur de syntaxe dans la formule:'#13#10+
                                             '  >%s<'#13#10+
                                             'Deux valeurs sont combinées entre elles sans opérateur.'#13#10+
                                             'au caractère %d'#13#10,
                                             [Formule, I])+EtatCourant);
            end
   end;
begin
     Enleve( Formule, ' ');
     if Formule = sys_Vide then exit;

     Racine:= nil;
     Insertion:= nil;
     for I:= 1 to Length( Formule)
     do
       if Formule[I] = '.'
       then
           Formule[I]:= FormatSettings.DecimalSeparator;

     I:= 0;
     while I< Length( Formule)
     do
       begin
       TakeChar;
       Ignore:= False;
       case C
       of
         '0'..'9':
           begin
           Dec( I);
           sD:= LireNombre;
           if not TryStrToFloat( sD, D)
           then
               fAccueil_LogBas( Format( 'Erreur de syntaxe dans la formule:'#13#10+
                                        '  >%s<'#13#10+
                                        'au caractère %d'#13#10,
                                        [Formule, I])+EtatCourant);
           Courant:= TFormule_Noeud_Constante.Create( D);
           end;
         '+': Courant:= TFormule_Noeud_Plus      .Create;
         '-': Courant:= TFormule_Noeud_Moins     .Create;
         '*': Courant:= TFormule_Noeud_Multiplier.Create;
         '/': Courant:= TFormule_Noeud_Diviser   .Create;
         else Ignore:= True;
         end;
       if Ignore then continue;
       Traite_Courant;
       end;

     Resultat:= Racine.Calcule;
     Result:= Racine.Formule;
     FormuleEvaluee:= Racine.FormuleEvaluee;
end;

initialization
              ElementNeutre_Addition      := TFormule_Noeud_Constante.Create( 0);
              ElementNeutre_Multiplication:= TFormule_Noeud_Constante.Create( 1);
              Unite                       := TFormule_Noeud_Constante.Create( 1);
finalization
              Free_nil( ElementNeutre_Addition      );
              Free_nil( ElementNeutre_Multiplication);
              Free_nil( Unite                       );
end.
