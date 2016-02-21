{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit OD_DelphiReportEngine_Controls;

interface

uses
 ucBatpro_Button, ucBatproComboBox, ucBatpro_Contrainte, ucBatproDateRange, 
 ucBatproDateTimePicker, ucBatproMaskElement, ucBatproMasque, 
 ucBatpro_OptionButton, ucBatpro_RadioGroup, ucBatproSelector, ucBatpro_Shape, 
 ucBatpro_SpeedButton, ucBatproSQLMask, ucBitBtn_antirebond, ucChamp_CheckBox, 
 ucChamp_Edit, ucChamp_Label, ucChamp_Lookup_ComboBox, ucChamp_Memo, 
 uDBEdit_WANTTAB, udmf, uDockable, uEdit_WANTTAB, ufcb, ufChamp_Date, 
 ufChamp_Lookup, ufChampsGrid_Colonnes, ucAnimate, ucChamp_Integer_SpinEdit, 
 ucChamp_DateTimePicker, ucChamp_Float_SpinEdit, ucChampsGrid, 
 ucDockableScrollbox, uWinUtils, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('ucBatpro_Button', @ucBatpro_Button.Register);
  RegisterUnit('ucBatproComboBox', @ucBatproComboBox.Register);
  RegisterUnit('ucBatpro_Contrainte', @ucBatpro_Contrainte.Register);
  RegisterUnit('ucBatproDateRange', @ucBatproDateRange.Register);
  RegisterUnit('ucBatproDateTimePicker', @ucBatproDateTimePicker.Register);
  RegisterUnit('ucBatproMaskElement', @ucBatproMaskElement.Register);
  RegisterUnit('ucBatpro_OptionButton', @ucBatpro_OptionButton.Register);
  RegisterUnit('ucBatpro_RadioGroup', @ucBatpro_RadioGroup.Register);
  RegisterUnit('ucBatproSelector', @ucBatproSelector.Register);
  RegisterUnit('ucBatpro_Shape', @ucBatpro_Shape.Register);
  RegisterUnit('ucBatpro_SpeedButton', @ucBatpro_SpeedButton.Register);
  RegisterUnit('ucBatproSQLMask', @ucBatproSQLMask.Register);
  RegisterUnit('ucBitBtn_antirebond', @ucBitBtn_antirebond.Register);
  RegisterUnit('ucChamp_CheckBox', @ucChamp_CheckBox.Register);
  RegisterUnit('ucChamp_Edit', @ucChamp_Edit.Register);
  RegisterUnit('ucChamp_Label', @ucChamp_Label.Register);
  RegisterUnit('ucChamp_Lookup_ComboBox', @ucChamp_Lookup_ComboBox.Register);
  RegisterUnit('ucChamp_Memo', @ucChamp_Memo.Register);
  RegisterUnit('ucAnimate', @ucAnimate.Register);
  RegisterUnit('ucChamp_Integer_SpinEdit', @ucChamp_Integer_SpinEdit.Register);
  RegisterUnit('ucChamp_DateTimePicker', @ucChamp_DateTimePicker.Register);
  RegisterUnit('ucChamp_Float_SpinEdit', @ucChamp_Float_SpinEdit.Register);
  RegisterUnit('ucChampsGrid', @ucChampsGrid.Register);
  RegisterUnit('ucDockableScrollbox', @ucDockableScrollbox.Register);
end;

initialization
  RegisterPackage('OD_DelphiReportEngine_Controls', @Register);
end.
