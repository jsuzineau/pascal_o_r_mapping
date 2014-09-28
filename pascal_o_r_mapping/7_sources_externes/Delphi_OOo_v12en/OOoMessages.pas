unit OOoMessages;

interface

const   { these messages may be translated to another idiom }

  { OOoTools unit }
  OOo_serviceKO= 'Impossible to create service : %s';
  OOo_connectKO= 'OpenOffice connection is impossible';
  OOo_structureKO= 'Unknown structure name : %s';
  OOo_inspectionKO= 'Object cannot be inspected';
  OOo_nbrArgsKO= 'Incorrect number of arguments';
  OOo_notString= 'The argument in position %d (starting from 0) should be a String';
  OOo_convertToURLKO= 'ConvertToURL impossible';
  OOo_convertFromURLKO= 'ConvertFromURL impossible';


  { OOoXray units }
  XrayMess10= '- Properties -';
  XrayMess10T= '- Sorted properties -';
  XrayMess13= '- Notes -';
  XrayMess20= '- Methods -';
  XrayMess20T= '- Sorted methods -';
  XrayMess21= '- Arguments -';
  XrayMess22= '- Return type -';
  XrayMess23= '- Interface -';
  XrayMess30= '- Sorted supported services -';
  XrayMess31= '- Sorted available services -';
  XrayMess32= '- Sorted supported interfaces -';
  XrayMess40= '*** un-named object ***';
  XrayMess61= '???';
  XrayMess62= 'Structure :  ';
  XrayMess70= 'Xray impossible because method needs arguments';
  XrayMess71= 'This method returns nothing';
  XrayMess72= 'COM bridge limitation : %s is inaccessible through Xray';
  XrayMess74= 'This property can''t be read, you can only write to it !';
  XrayMess80= 'Sorry, there is no page in the SDK for this';
  XrayMess81= 'Sorry, this pseudo-property is not documented';
  XrayMess82= 'Pseudo-property, displaying : %s';
  XrayMess83= 'There are several pages on : %s';
  XrayMess84= 'SDK address is incorrect.'#13'Please modify constant SDKaddr in OOoXray.pas';
  XrayMess85= 'Browser address is incorrect.'#13'Please modify constant myBrowser in OOoXray.pas';
  XrayMess86= 'This property is not documented in the supported services';
  XrayMess87= 'Displayed documentation is found in other services';
  XrayMess88= 'The content of this Xray window is saved';
  XrayMvalue = 'Value = ';
  XrayMzeroString= 'Zero length string';
  XrayMcolType = '- Type -';
  XrayMcolValue = '- Value -';


  { Unit1 unit }
  OOoMess001= 'Connected to OpenOffice';
  OOoMess002= 'Disconnected from OpenOffice';

  { OOoExamples unit }
  OOoMess105= 'Document will close';
  OOoMess107= 'Table not yet sorted';
  OOoMess108= 'Table is sorted now !';
  OOoMess111= 'Hello World';
  OOoMess112= 'written with ';
  OOoMess113= 'OpenOffice.org ';



implementation

end.
