unit uchChamp_Button;

{$mode objfpc}{$H+}

interface

uses
    uChamps,
    uChamp,
  Classes, SysUtils,Laz_And_Controls;

type
    ThChamp_Button
    =
     class( TComponent, IChampsComponent)
     //Cycle de vie
     public
       constructor Create(AOwner: TComponent); override;
       destructor Destroy; override;
     //Propriété Champs
     private
       FChamps: TChamps;
       function GetChamps: TChamps;
       procedure SetChamps( Value: TChamps);
     public
       property Champs: TChamps read GetChamps write SetChamps;
     // Propriété Field
     private
       FField: String;
     published
       property Field: String read FField write FField;
     //Champ
     private
       Champ: TChamp;
       function Champ_OK: Boolean;
       procedure Champ_Destroyed;
     //Gestion des mises à jours avec TChamps
     private
       Champs_Changing: Boolean;
       procedure _from_Champs;
     //accesseur à partir de l'interface
     private
       function GetComponent: TComponent;
     //Button
     private
       Fb: jButton;
       procedure Setet( _Value: jButton);
     published
       property b: jButton read Fb write Setet;
     end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Android Bridges Extra',[ThChamp_Button]);
end;

{ ThChamp_Button }

constructor ThChamp_Button.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     Fb:= nil;
     FChamps:= nil;
     Champs_Changing:= False;
end;

destructor ThChamp_Button.Destroy;
begin
     inherited Destroy;
end;

function ThChamp_Button.GetChamps: TChamps;
begin
     Result:= FChamps;
end;

procedure ThChamp_Button.Champ_Destroyed;
begin
     SetChamps( nil);
end;

procedure ThChamp_Button.SetChamps(Value: TChamps);
begin
     if Assigned( Champ)
     then
         begin
         Champ.OnChange .Desabonne( Self, @_from_Champs   );
         Champ.OnDestroy.Desabonne( Self, @Champ_Destroyed);
         end;

     FChamps:= nil;
     if Assigned( Fb) then Fb.Text:= '';
     FChamps:= Value;
     if not Champ_OK then exit;

     Champ.OnChange .Abonne( Self, @_from_Champs   );
     Champ.OnDestroy.Abonne( Self, @Champ_Destroyed);
     _from_Champs;
end;

function ThChamp_Button.Champ_OK: Boolean;
begin
     Champ:= nil;

     Result:= Assigned( FChamps);
     //if not (csDesigning in ComponentState) then if not Result then WriteLn( ClassName+'.Champ_OK = False');
     if not Result then exit;

     Champ:= Champs.Champ_from_Field( Field);
     Result:= Assigned( Champ);
     //if not (csDesigning in ComponentState) then WriteLn( ClassName+'.Champ_OK = ', Result);
end;

procedure ThChamp_Button._from_Champs;
begin
     //if not (csDesigning in ComponentState) then if Champs_Changing then WriteLn( ClassName+'._from_Champs: Champs_Changing= True');
     if Champs_Changing then exit;
     try
        Champs_Changing:= True;

        //if not (csDesigning in ComponentState) then WriteLn( ClassName+'._from_Champs: Champ.Chaine = ',Champ.Chaine);
        if Assigned( Fb) then Fb.Text:= Champ.Chaine;
        //if not (csDesigning in ComponentState) then WriteLn( ClassName+'._from_Champs: FInitialized= ',FInitialized);

        //jEditText_setText(FjEnv, FjObject , Champ.Chaine);
        if Champ.Chaine <> ''
        then
            begin
            if Assigned( Fb)
            then
                Fb.Text:= Champ.Chaine
            else
                Fb.Text:= '';
            end;
     finally
            Champs_Changing:= False;
            end;
end;

function ThChamp_Button.GetComponent: TComponent;
begin
     Result:= b;
end;

procedure ThChamp_Button.Setet( _Value: jButton);
begin
     Fb:= _Value;
end;

end.
