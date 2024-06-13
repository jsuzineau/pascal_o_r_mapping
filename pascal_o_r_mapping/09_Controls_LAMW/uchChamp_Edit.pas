unit uchChamp_Edit;

{$mode objfpc}{$H+}

interface

uses
    uChamps,
    uChamp,
  Classes, SysUtils,Laz_And_Controls;

type

 { ThChamp_Edit }

 ThChamp_Edit
 =
  class( TComponent, IChampsComponent)
  //Cycle de vie
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  //OnChange
  private
    procedure Changed( _Sender: TObject; _txt: string; _count: integer);
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
    procedure _to_Champs;
  //accesseur à partir de l'interface
  private
    function GetComponent: TComponent;
  //EditText
  private
    Fet: jEditText;
    procedure Setet( _Value: jEditText);
  published
    property et: jEditText read Fet write Setet;
  end;

procedure Register;

implementation

procedure Register;
begin
     RegisterComponents('Android Bridges Extra',[ThChamp_Edit]);
end;

{ ThChamp_Edit }

constructor ThChamp_Edit.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     Fet:= nil;
     FChamps:= nil;
     Champs_Changing:= False;
end;

destructor ThChamp_Edit.Destroy;
begin
     inherited Destroy;
end;

procedure ThChamp_Edit.Changed(_Sender: TObject; _txt: string; _count: integer);
begin
     if not Champ_OK then exit;

     _to_Champs;
end;

function ThChamp_Edit.GetChamps: TChamps;
begin
     Result:= FChamps;
end;

procedure ThChamp_Edit.Champ_Destroyed;
begin
     SetChamps( nil);
end;

procedure ThChamp_Edit.SetChamps(Value: TChamps);
begin
     if Assigned( Champ)
     then
         begin
         Champ.OnChange .Desabonne( Self, @_from_Champs   );
         Champ.OnDestroy.Desabonne( Self, @Champ_Destroyed);
         end;

     FChamps:= nil;
     if Assigned( Fet) then Fet.Text:= '';
     FChamps:= Value;
     if not Champ_OK then exit;

     Champ.OnChange .Abonne( Self, @_from_Champs   );
     Champ.OnDestroy.Abonne( Self, @Champ_Destroyed);
     _from_Champs;
end;

function ThChamp_Edit.Champ_OK: Boolean;
begin
     Champ:= nil;

     Result:= Assigned( FChamps);
     //if not (csDesigning in ComponentState) then if not Result then WriteLn( ClassName+'.Champ_OK = False');
     if not Result then exit;

     Champ:= Champs.Champ_from_Field( Field);
     Result:= Assigned( Champ);
     //if not (csDesigning in ComponentState) then WriteLn( ClassName+'.Champ_OK = ', Result);
end;

procedure ThChamp_Edit._from_Champs;
begin
     //if not (csDesigning in ComponentState) then if Champs_Changing then WriteLn( ClassName+'._from_Champs: Champs_Changing= True');
     if Champs_Changing then exit;
     try
        Champs_Changing:= True;

        //if not (csDesigning in ComponentState) then WriteLn( ClassName+'._from_Champs: Champ.Chaine = ',Champ.Chaine);
        if Assigned( Fet) then Fet.Text:= Champ.Chaine;
        //if not (csDesigning in ComponentState) then WriteLn( ClassName+'._from_Champs: FInitialized= ',FInitialized);

        //jEditText_setText(FjEnv, FjObject , Champ.Chaine);
        if Champ.Chaine <> ''
        then
            begin
            if Assigned( Fet)
            then
                Fet.Text:= Champ.Chaine
            else
                Fet.Clear;
            end;
     finally
            Champs_Changing:= False;
            end;
end;

procedure ThChamp_Edit._to_Champs;
begin
     //if not (csDesigning in ComponentState) then if Champs_Changing then WriteLn( ClassName+'._to_Champs: Champs_Changing= True');
     if Champs_Changing then exit;
     try
        Champs_Changing:= True;

        if Assigned( Fet)
        then
            if Fet.Editable
            then
                Champ.Chaine:= Fet.Text;
        //if not (csDesigning in ComponentState) then WriteLn( ClassName+'._from_Champs: Champ.Chaine = ',Champ.Chaine);
     finally
            Champs_Changing:= False;
            end;
     if Champ.Bounce then _from_Champs;
end;

function ThChamp_Edit.GetComponent: TComponent;
begin
     Result:= et;
end;

procedure ThChamp_Edit.Setet( _Value: jEditText);
begin
     if Assigned( Fet) then Fet.OnChanged:= nil;

     Fet:= _Value;

     if Assigned( Fet) then Fet.OnChanged:= @Changed;
end;

end.
