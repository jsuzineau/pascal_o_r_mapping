include <M_global.scad>

Hauteur= 70;
Epaisseur=2;

Fil_d=2.6+Reduction_diametre; Fil_r=Fil_d/2;

Disque_epaisseur= 5;
Disque_debord=5;//entre 5 et 8
Disque_debord_max=8;

Patte_dx= 5; Patte_dx2=Patte_dx/2;
//de l'extérieur vers l'intérieur
Patte_dy=Epaisseur+Disque_debord_max+Disque_epaisseur;Patte_dy2=Patte_dy/2;
Patte_dz_constant
=
  Epaisseur
 +Disque_epaisseur+Reduction_diametre
 ;
//de bas en haut
function Patte_dz( _Hauteur= Hauteur)
=
  Patte_dz_constant
 +_Hauteur;

module Patte( _Hauteur= Hauteur)
  {
  tx(-Patte_dx2)cube([Patte_dx, Patte_dy, Patte_dz( _Hauteur)]);
  }

Disque1_dx=Patte_dx+0.02;Disque1_dx2=Disque1_dx/2;
Disque1_dy=Patte_dy-Epaisseur+0.02;
Disque1_dz=Disque_epaisseur;
Disque1_y=Epaisseur;
Disque1_z=Epaisseur;

module Disque1()
  {
  tx(-Disque1_dx2)
    ty(Disque1_y)
      tz(Disque1_z)
        cube([Disque1_dx, Disque1_dy, Disque1_dz]);
  }

Disque2_dx=Patte_dx+0.02;Disque2_dx2=Disque2_dx/2;
Disque2_dy=Patte_dy-Epaisseur-Disque_debord+0.02;
Disque2_dz=Disque_epaisseur;
Disque2_y=Epaisseur+Disque_debord;
Disque2_z=Disque1_z+Disque1_dz;

module Disque2()
  {
  tx(-Disque2_dx2)
    ty(Disque2_y)
      tz(Disque2_z)
        cube([Disque2_dx, Disque2_dy, Disque2_dz]);
  }

Decoupe_dx=Patte_dx+0.02;Decoupe_dx2=Decoupe_dx/2;
Decoupe_dy=Patte_dy-Epaisseur+0.02;
function Decoupe_dz( _Hauteur= Hauteur)
=
  _Hauteur
 -Disque2_dz
 -Epaisseur //au dessus des disques
 +0.01
 ;

Decoupe_y=Epaisseur;
Decoupe_z
=
  //de bas en haut
  Patte_dz_constant
 +Disque2_dz
 +Epaisseur //au dessus des disques
 ;

module Decoupe( _Hauteur= Hauteur)
  {
  tx(-Decoupe_dx2)
    ty(Decoupe_y)
      tz(Decoupe_z)
        cube([Decoupe_dx, Decoupe_dy, Decoupe_dz( _Hauteur)]);
  }

Fil_h= Patte_dx+0.02;
Fil_x=-Fil_h/2;
Fil_y=Epaisseur/2;
function Fil_z( _Hauteur= Hauteur)= Patte_dz(_Hauteur) - Fil_r;

module Fil( _Hauteur= Hauteur)
  {
  tx(Fil_x)ty(Fil_y)tz(Fil_z(_Hauteur))
    ry(90)cylinder( r= Fil_r, h= Fil_h, $fn=50);
  }

module Fil_hull( _Hauteur= Hauteur)
  {
  tx(Fil_x)ty(Fil_y)tz(Fil_z(_Hauteur))
    hull()
      {
               ry(90)cylinder( r= Fil_r, h= Fil_h, $fn=50);
      tz(Fil_r)ry(90)cylinder( r= Fil_r, h= Fil_h, $fn=50);
      }
  }

Logement_Fil_r= Fil_r+Epaisseur;
Logement_Fil_h= Patte_dx;
Logement_Fil_x=-Logement_Fil_h/2;
Logement_Fil_y=Fil_y;
function Logement_Fil_z( _Hauteur= Hauteur)= Patte_dz(_Hauteur) - Logement_Fil_r;

module Logement_Fil( _Hauteur= Hauteur)
  {
  tx(Logement_Fil_x          )
  ty(Logement_Fil_y          )
  tz(Logement_Fil_z(_Hauteur))
    ry(90)
      cylinder( r= Logement_Fil_r, h= Logement_Fil_h, $fn=50);
  }
Extremite_Patte_r= Epaisseur/2;
Extremite_Patte_h= Patte_dx;
Extremite_Patte_x=-Extremite_Patte_h/2;
Extremite_Patte_y=Patte_dy;

module Extremite_Patte( _z=0, _delta_r=0)
  {
  tx(Extremite_Patte_x   )
  ty(Extremite_Patte_y   )
  tz(Extremite_Patte_r+_delta_r+_z)
    ry(90)
      cylinder( r= Extremite_Patte_r+_delta_r, h= Extremite_Patte_h, $fn=50);
  }
module Gabarit_beer_gut( _Hauteur= Hauteur)
  {
  difference()
    {
    union()
      {
      difference()
        {
        Patte(_Hauteur);
        Disque1();%Disque1();
        Disque2();%Disque2();
        Decoupe( _Hauteur);
        %Decoupe( _Hauteur);
        }
      Logement_Fil( _Hauteur);
      Extremite_Patte();
      Extremite_Patte(Epaisseur+Disque1_dz+Disque2_dz,Reduction_diametre/2);
      }
    Fil_hull( _Hauteur);%Fil( _Hauteur);
    }
  }

module Conception()
  {
  Gabarit_beer_gut();
  }
module Impression()
  {
  Gabarit_beer_gut();
  }
module Impression_Patte()
  {
  rz(90)ry(90)tx(-Patte_dx2)ty(-Patte_dy2)Gabarit_beer_gut();
  }
module Impression_Patte2()
  {
  rz(90)ry(90)tx(-Patte_dx2)ty(-Patte_dy2)Gabarit_beer_gut(Hauteur/2);
  }

