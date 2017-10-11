module tx( _x) translate([_x,0,0]) children();
module ty( _y) translate([0,_y,0]) children();
module tz( _z) translate([0,0,_z]) children();

module rx( _angle) rotate([_angle,0,0]) children();
module ry( _angle) rotate([0,_angle,0]) children();
module rz( _angle) rotate([0,0,_angle]) children();

//réduction du diametre du trou à l'impression 0.5 mm
Reduction_diametre=0.5;

