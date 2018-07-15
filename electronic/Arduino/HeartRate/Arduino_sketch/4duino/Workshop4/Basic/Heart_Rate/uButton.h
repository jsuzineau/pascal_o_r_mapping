#ifndef uButton_h
#define uButton_h
class TButton
  {
  public:
  word state, x, y, buttonColour, txtColour, font, txtWidth, txtHeight;
  char *text;
  word width, height;
  TButton( word _state, word _x, word _y, word _buttonColour, word _txtColour,
           word _font, word _txtWidth, word _txtHeight, char *_text, word _width, word _height)
    : state(_state), x(_x), y(_y),
      buttonColour(_buttonColour), txtColour(_txtColour), font(_font),
      txtWidth(_txtWidth), txtHeight(_txtHeight), text(_text), width(_width), height(_height)
    {
    }
  void Draw()
     {
     Display.gfx_Button(state, x, y, buttonColour, txtColour, font, txtWidth, txtHeight, text) ;
     }
  boolean Touch( word _x, word _y)
     {
     boolean Result=((x <= _x)&&(_x <= x+width) && (y <= _y)&&(_y <= y+height));
     return Result;
     }
  };
#endif
