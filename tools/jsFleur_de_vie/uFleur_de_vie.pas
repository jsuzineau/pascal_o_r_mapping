unit uFleur_de_vie;

{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils, math, StdCtrls,contnrs;
const
     r3_2=sqrt(3)/2;
     r23=sqrt(2/3);
     s60=r3_2;//sin 60 °
     c60=1/2;//cos 60 °
     s30=c60;//sin 30 °
     c30=s60;//cos 30 °
     r2_2=sqrt(2)/2;

var
   MaxThreads: Integer=1;

var
     at,at2,sat2,cat2: double;
var
   e: double =2;

type
  { TthCalcul }

  TthCalcul
  =
   class( TThread)
   //Gestion du cycle de vie
   public
     constructor Create( _I_Start: Integer; _m: TMemo);
     destructor Destroy; override;
   protected
     procedure T( _Rayon: Integer);
     procedure Execute; override;
   //m
   private
     m: TMemo;
   //Display
   private
     Display_S: String;
     procedure Do_Display;
     procedure Display( _Display_S: String);
   //Display_Clear
   private
     procedure Do_Display_Clear;
     procedure Display_Clear;
   //I_Start
   private
     I_Start: Integer;

   //csL
   private
     csL: TRTLCriticalSection;
     procedure csL_Enter;
     procedure csL_Leave;
   //csResultat_Global
   private
     csResultat_Global: TRTLCriticalSection;
     procedure csResultat_Global_Enter;
     procedure csResultat_Global_Leave;
   //Calcul
   private
     L: TObjectList;
     function Fleur_de_vie_NbSpheres( _Xmin: integer=-2;
                                      _Xmax: integer= 2;
                                      _Ymin: integer=-2;
                                      _Ymax: integer= 2;
                                      _Zmin: integer=-2;
                                      _Zmax: integer= 2;
                                      _Rayon: integer=2): Int64;

     function Fleur_de_vie_NbSpheres_from_Rayon( _Rayon: integer=2): Int64;
   end;

type
  { TthTrancheX }

  TthTrancheX
  =
   class( TThread)
   public
     constructor Create( _X: Integer;
                         _Ymin: integer;
                         _Ymax: integer;
                         _Zmin: integer;
                         _Zmax: integer;
                         _Rayon_carre: Int64;
                         _Resultat_Global: PInt64;
                         _th: TthCalcul);
   //Paramètres
   private
     X: Integer;
     Ymin: integer;
     Ymax: integer;
     Zmin: integer;
     Zmax: integer;
     Rayon_carre: Int64;
   //Exécution
   protected
     procedure Execute; override;
   //Résultat
   public
     Resultat: Int64;
   //Resultat_Global
   public
     Resultat_Global: PInt64;
     th: TthCalcul;
     procedure L_Ajoute;
     procedure Traite_Resultat_Global;
   end;

implementation

{ TthCalcul }

constructor TthCalcul.Create(_I_Start: Integer; _m: TMemo);
begin
     I_Start:= _I_Start;
     m:= _m;
     L:= TObjectList.Create(False);
     InitCriticalSection( csL);
     InitCriticalSection( csResultat_Global);
     FreeOnTerminate:= True;;
     inherited Create( True);
end;

destructor TthCalcul.Destroy;
begin
     FreeAndNil( L);
     DoneCriticalSection( csL);
     DoneCriticalSection( csResultat_Global);
     inherited Destroy;
end;

procedure TthCalcul.Do_Display;
begin
     m.Lines.Add( Display_S);
end;

procedure TthCalcul.Display(_Display_S: String);
begin
     Display_S:= _Display_S;
     Synchronize( @Do_Display);
end;

procedure TthCalcul.Do_Display_Clear;
begin
     m.Clear;
end;

procedure TthCalcul.Display_Clear;
begin
     Synchronize( @Do_Display_Clear);
end;

procedure TthCalcul.T(_Rayon: Integer);
var
   N: Int64;
   S: String;
   Dimension: double;
begin
     N:= Fleur_de_vie_NbSpheres_from_Rayon( _Rayon);
     if _Rayon = 1
     then
         Dimension:= 0
     else
         Dimension:= ln(N)/ln(_Rayon+1);
     S:= Format('%3d;%7d;%f',[_Rayon, N, Dimension]);
     Display( S);
end;

procedure TthCalcul.Execute;
var
   I: Integer;
begin
     Display_Clear;
     I:= I_Start;
     repeat
           T(I);
           Inc( I);
     until Terminated;
end;

function TthCalcul.Fleur_de_vie_NbSpheres_from_Rayon(_Rayon: integer): Int64;
begin
     Result
     :=
       Fleur_de_vie_NbSpheres( -_Rayon, //_Xmin: integer=-2;
                               +_Rayon, //_Xmax: integer= 2;
                               -_Rayon, //_Ymin: integer=-2;
                               +_Rayon, //_Ymax: integer= 2;
                               -_Rayon, //_Zmin: integer=-2;
                               +_Rayon, //_Zmax: integer= 2;
                               +_Rayon); //_Rayon: integer=2): Integer;
end;

procedure TthCalcul.csL_Enter;
begin
     EnterCriticalSection( csL);
end;

procedure TthCalcul.csL_Leave;
begin
     LeaveCriticalSection( csL);
end;

procedure TthCalcul.csResultat_Global_Enter;
begin
     EnterCriticalSection( csResultat_Global);
end;

procedure TthCalcul.csResultat_Global_Leave;
begin
     LeaveCriticalSection( csResultat_Global);
end;

function TthCalcul.Fleur_de_vie_NbSpheres( _Xmin: integer=-2;
                                           _Xmax: integer= 2;
                                           _Ymin: integer=-2;
                                           _Ymax: integer= 2;
                                           _Zmin: integer=-2;
                                           _Zmax: integer= 2;
                                           _Rayon: integer=2): Int64;
var
   ix: Integer;
   Rayon_carre: Int64;
   Resultat_Global: Int64;

   function First_thread: TthTrancheX;
   begin
        csL_Enter;
        try
           Result:= TthTrancheX( L.First);
        finally
               csL_Leave;
               end;
   end;
   function L_Count: Integer;
   begin
        csL_Enter;
        try
           Result:= L.Count;
        finally
               csL_Leave;
               end;
   end;
   procedure Wait_for_first_thread;
   var
      th: TthTrancheX;
   begin
        th:= First_thread;
        if nil = th then exit;
        th.WaitFor;
   end;
   procedure Wait_for_all_threads;
   var
      th: TthTrancheX;
   begin
        th:= First_thread;
        if nil = th then exit;
        repeat
              th.WaitFor;
              th:= First_thread;
        until nil = th;
   end;
begin
     Resultat_Global:= 0;
     Rayon_carre:= _Rayon*_Rayon;
     for ix:= _Xmin to _Xmax
     do
       begin
       if Terminated then break;

       while MaxThreads < L_Count
       do
         Wait_for_first_thread;
       TthTrancheX.Create( ix,
                           _Ymin, _Ymax,
                           _Zmin, _Zmax,
                           Rayon_carre,
                           @Resultat_Global,
                           Self);
       end;
     Wait_for_all_threads;
     Result:= Resultat_Global;
end;

{ TthTrancheX }

constructor TthTrancheX.Create( _X: Integer;
                                _Ymin: integer; _Ymax: integer;
                                _Zmin: integer; _Zmax: integer;
                                _Rayon_carre: Int64;
                                _Resultat_Global: PInt64;
                                _th: TthCalcul);
begin
     X   := _X   ;
     Ymin:= _Ymin;
     Ymax:= _Ymax;
     Zmin:= _Zmin;
     Zmax:= _Zmax;
     Rayon_carre:= _Rayon_carre;
     Resultat_Global:= _Resultat_Global;
     th:= _th;
     L_Ajoute;
     FreeOnTerminate:= True;
     inherited Create( False);
end;

procedure TthTrancheX.Execute;
var
   ix, iy, iz: Integer;
   cx, cy, cz: double;
   cr2: Extended;
begin
     Resultat:= 0;
     ix:= X;
     for iy:= Ymin to Ymax
     do
       for iz:= Zmin to Zmax
       do
         begin
         if th.Terminated then break;

         cx:= e*ix+e*iy*c60+e*iz*cat2*c30;
         cy:=      e*iy*s60+e*iz*cat2*s30;
         cz:=               e*iz*sat2;
         cr2:= cx*cx+cy*cy+cz*cz;
         //_m.Lines.Add( Format('ix:%d; iy:%d; iz:%d; cx:%f; cy:%f; cz: %f; cr: %f', [ix,iy,iz,cx,cy,cz,sqrt(cr2)]));
         if  Rayon_carre >= cr2
         then
             Inc(Resultat);
         end;
     Traite_Resultat_Global;
end;

procedure TthTrancheX.L_Ajoute;
begin
     th.csL_Enter;
     try
        th.L.Add( Self);
     finally
            th.csL_Leave;
            end;
end;

procedure TthTrancheX.Traite_Resultat_Global;
begin
     th.csResultat_Global_Enter;
     try
        Inc( Resultat_Global^, Resultat);
     finally
            th.csResultat_Global_Leave;
            end;

     th.csL_Enter;
     try
        th.L.Remove( Self);
     finally
            th.csL_Leave;
            end;
end;


initialization
              at:=arccos(-1/3);//angle central du tétraèdre
              at2:=at/2;//demi-angle central du tétraèdre
              sat2:= sin(at2);
              cat2:= cos(at2);
end.

