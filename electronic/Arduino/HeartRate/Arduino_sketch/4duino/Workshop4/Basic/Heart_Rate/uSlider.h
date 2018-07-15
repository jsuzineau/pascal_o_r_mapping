#ifndef uSlider_h
#define uSlider_h
class TSlider
  {
  public:
  word mode, x1, y1, x2, y2, colour, scale, value;
  TSlider ( word _mode, word _x1, word _y1, word _x2, word _y2, word _colour, word _scale, word _value)
    :
     mode( _mode),
     x1( _x1),
     y1( _y1),
     x2( _x2),
     y2( _y2),
     colour( _colour),
     scale( _scale),
     value( _value)
     {
     }
   void Draw()
     {
     Display.gfx_Slider( mode, x1, y1, x2, y2, colour, scale, value);
     }
   boolean is_Horizontal() { return (x2-x1) >  (y2-y1); }
   boolean is_Vertical  () { return (x2-x1) <= (y2-y1); }
   word xyValue( word _x, word _y)
     {
     if   (is_Horizontal()) return _x-x1;
     else                   return _y-y1;
     }
   word xyScale()
     {
     if   (is_Horizontal()) return x2-x1;
     else                   return y2-y1;
     }
   boolean Touch( word _x, word _y)
     {
     boolean Result=((x1 <= _x)&&(_x <= x2) && (y1 <= _y)&&(_y <= y2));
     if (Result)
       {
       value= (xyValue( _x, _y)*scale) / xyScale();
       Draw();
       }

     return Result;
     }
  };
#endif
