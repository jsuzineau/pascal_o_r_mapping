unit uOD_DelphiReportEngine_Controls_LAMW_Designer;

{$mode objfpc}{$H+}

interface

uses
    ucjChamp_Edit,
 Classes, SysUtils, LamwDesigner;

// nécessité de modifier LamwDesigner
// pour publier RegisterAndroidWidgetDraftClass dans la partie interface
implementation

initialization
              RegisterAndroidWidgetDraftClass(TjChamp_Edit, TDraftEditText);
finalization
end.

