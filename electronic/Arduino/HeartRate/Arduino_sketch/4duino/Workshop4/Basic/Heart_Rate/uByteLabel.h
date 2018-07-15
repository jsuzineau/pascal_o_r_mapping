#ifndef uByteLabel_h
#define uByteLabel_h
#include "uButton.h"
class TByteLabel: public TButton
  {
  public:
  byte *bValue;
  char cValue[80];
  TByteLabel( word _state, word _x, word _y, word _buttonColour, word _txtColour,
           word _font, word _txtWidth, word _txtHeight, byte *_bValue, word _width, word _height)
   :TButton( _state, _x, _y, _buttonColour, _txtColour,
           _font, _txtWidth, _txtHeight, cValue, _width, _height),
    bValue( _bValue)
    {
    }
  void Draw()
     {
     sprintf( cValue, "%d", *bValue);
     TButton::Draw();
     }

  };
#endif
