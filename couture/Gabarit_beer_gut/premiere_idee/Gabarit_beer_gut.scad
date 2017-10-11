module tx( _x) translate([_x,0,0]) children();
module ty( _y) translate([0,_y,0]) children();
module tz( _z) translate([0,0,_z]) children();

module rx( _angle) rotate([_angle,0,0]) children();
module ry( _angle) rotate([0,_angle,0]) children();
module rz( _angle) rotate([0,0,_angle]) children();

circonference_visee=850;
cerclage_d=190;
cerclage_h=30;
cerclage_epaisseur=1;
Spirale_pas= 1;//en degrés
Hauteur=70;

cerclage_r=cerclage_d/2;
circonference=PI*cerclage_d;
Spirale_angle=(circonference_visee/circonference)*360;
Spirale_ecart= 2*cerclage_epaisseur;
Spirale_b=-Spirale_ecart/360;

function Theta_from_a( _a=0)
=
 (
 _a <= Spirale_angle
 ?
  _a
 :
  2*Spirale_angle-_a
 );
function Spirale_exterieur_from_Theta( _Theta=0)=cerclage_r                   +Spirale_b*_Theta;
function Spirale_interieur_from_Theta( _Theta=0)=cerclage_r-cerclage_epaisseur+Spirale_b*_Theta;
function Spirale_r_from_a( _a=0)
=
 (
 _a <= Spirale_angle
 ?
  Spirale_exterieur_from_Theta( Theta_from_a( _a))
 :
  Spirale_interieur_from_Theta( Theta_from_a( _a))
 );

// generate ellipse points
function x(a) = Spirale_r_from_a( a) * sin(Theta_from_a( a));
function y(a) = Spirale_r_from_a( a) * cos(Theta_from_a( a));
function z(a) = Hauteur*(0.5+0.5*cos(360*(a-Spirale_angle/2)/Spirale_angle));

module original()
  {
  points = [ for (a = [0:Spirale_pas:2*Spirale_angle]) [ x(a), y(a) ] ];

  linear_extrude( height= cerclage_h)
    polygon(points);
  }

module Element( _a=0)
  {
    tx(x(_a))
      ty(y(_a))
        cylinder( r=cerclage_epaisseur/2, h=z(_a), $fn=50);
  }

module version_cylindre()
  {
  for (a = [0:Spirale_pas:Spirale_angle])
    hull()
      {
      Element( a);
      Element( a+Spirale_pas);
      }
  }

module T()
  {
  points_bas   = [ for (a = [0:Spirale_pas:2*Spirale_angle]) [ x(a), y(a), 0   ] ];
  points_hauts = [ for (a = [0:Spirale_pas:2*Spirale_angle]) [ x(a), y(a), z(a)] ];
  points= concat(points_bas,points_hauts);

  face_bas       =[for (i = [0:len(points_bas)]) i];
  face_haut      =[for (i = [len(points_bas)+len(points_hauts):-1:len(points_bas)]) i];
  Ligne_exterieur_bas = [for (i = [0:len(points_bas)/2]) i];
  Ligne_exterieur_haut= [for (i = [len(points_bas):len(points_bas)+len(points_hauts)/2]) i];
  faces_exterieures=[for (i = [0:len(points_bas)/2]) [len(points_bas)+i,len(points_bas)+i+1,i+1,i]];
  faces_interieures=[for (i = [len(points_bas)/2+1:len(points_bas)]) [len(points_bas)+i,len(points_bas)+i+1,i+1,i]];

  faces=concat([ face_bas, face_haut], faces_exterieures, faces_interieures);
  polyhedron( points, faces);
  }

T();
