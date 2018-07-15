#ifndef uIntLabel_h
#define uIntLabel_h
#include "uButton.h"
class TIntLabel: public TButton
  {
  public:
  long *lValue;
  char cValue[80];
  TIntLabel( word _state, word _x, word _y, word _buttonColour, word _txtColour,
           word _font, word _txtWidth, word _txtHeight, long *_lValue, word _width, word _height)
   :TButton( _state, _x, _y, _buttonColour, _txtColour,
           _font, _txtWidth, _txtHeight, cValue, _width, _height),
    lValue( _lValue)
    {
    }
  void Draw()
     {
     sprintf( cValue, "%d", *lValue);
     TButton::Draw();
     }

  };
#endif
