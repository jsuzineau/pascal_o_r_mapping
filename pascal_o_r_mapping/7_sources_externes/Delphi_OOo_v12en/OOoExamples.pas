unit OOoExamples;

  { cette unité est seulement une collection d'exemples
    this unit is only a collection of examples }

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Variants;

{ information sur la configuration OpenOffice
  information on OpenOffice configuration                 }
procedure  showWorkDirectory;

{ Pour un document Writer
  for a Writer document                                   }
procedure HelloWorldExample;
procedure defineTabulations;

{ pour un document Calc
  for a Calc document                                    }
procedure setCellBorders;
procedure CalcSortingExample;

{ pour un document Draw, Impress
  for a  Draw, Impress document                   }
procedure drawPolygon;

{ séquences de test (cas normaux)
  test sequences (normal cases)   }
procedure TestSequences;



implementation

Uses ComObj, OOoMessages, OOoTools, OOoConstants, OOoXray;




{ cette procédure est indépendante de tout document
  elle affiche l'adresse du répertoire de travail indiqué dans la configuration d'OpenOffice

  this procedure is independent from any document
  it displays the work directory indicated in the configuration of OpenOffice         }
procedure  showWorkDirectory;
var
  sv, w: Variant;
begin
  sv:= CreateUnoService('com.sun.star.util.PathSettings');
  w:= sv.Work;
  showmessage(convertFromURL(w));
end;





procedure HelloWorldExample;
var
  myDoc, myText, myCursor : Variant;
begin
  myDoc:= StarDesktop.loadComponentFromURL('private:factory/swriter', '_blank', 0, dummyArray);
  myText:= myDoc.Text;
  myCursor:= myText.createTextCursor;
  myText.insertString(myCursor, OOoMess111, false);
  { insérer une marque de paragraphe en utilisant une constante API
    inserting a paragraph break, using an API constant    }
  myText.insertControlCharacter(myCursor, _textControlCharacterPARAGRAPH_BREAK, False);
  myCursor.CharColor:= RGB(0, 200, 0);
  myText.insertString(myCursor, OOoMess112, false);
  myCursor.CharWeight:= _awtFontWeightBOLD; // an API constant
  myText.insertString(myCursor, OOoMess113, false);
  myCursor.CharColor:= -1;
  myCursor.CharWeight:= _awtFontWeightNORMAL; // an API constant
  myText.insertControlCharacter(myCursor, _textControlCharacterPARAGRAPH_BREAK, False);
  showMessage(OOoMess105);
  myDoc.close(True);
end;



procedure defineTabulations;
var
  myDoc, myText, myCursor, tabStopsList: Variant;  Texte1: String;
const
  Tab = #9;
begin
  myDoc:= StarDesktop.loadComponentFromURL('private:factory/swriter', '_blank', 0, dummyArray);
  myText:= myDoc.Text;
  myCursor:= myText.createTextCursor;
  { création et remplissage d'un tableau de structures Uno
    create and fill an array of Uno structures             }
  tabStopsList:= CreateUnoStruct('com.sun.star.style.TabStop', 2);
  { mettre 3 taquets sur le paragraphe en cours
    put 3 tab stops on the current paragraph          }
  tabStopsList[0].DecimalChar:= ',';
  tabStopsList[0].FillChar:= ' ';
  tabStopsList[0].Position:= 2500; // 25 mm ( 2,5 cm )
  tabStopsList[0].Alignment:= _styleTabAlignLEFT;
  tabStopsList[1].DecimalChar:= ',';
  tabStopsList[1].FillChar:= ' ';
  tabStopsList[1].Position:= 4700; // 47 mm
  tabStopsList[1].Alignment:= _styleTabAlignCENTER;
  tabStopsList[2].DecimalChar:= ',';
  tabStopsList[2].FillChar:= ' ';
  tabStopsList[2].Position:= 7010; // 70,1 mm
  tabStopsList[2].Alignment:= _styleTabAlignRIGHT;
  myCursor.ParaTabStops:= tabStopsList;
  { utiliser ces tabulations
    use these tabulation stops   }
  Texte1:= 'Début' + Tab + 'Tab0' + Tab + 'Tab1' + Tab + 'Tab2' +Tab;
  myText.insertString( myCursor, Texte1, false);
  myText.insertControlCharacter(myCursor, _textControlCharacterPARAGRAPH_BREAK, False);
  ShowMessage(OOoMess105);
  myDoc.close(True);
end;







procedure CalcSortingExample;
var
  myDoc, firstSheet, aRange, fields, unoWrap, sortDx : Variant; n : Integer;
begin
  myDoc:= StarDesktop.loadComponentFromURL('private:factory/scalc', '_blank', 0, dummyArray);
  firstSheet:= myDoc.Sheets.getByIndex(0);
  firstSheet.getCellRangeByName('A1').String:= 'Texts';
  firstSheet.getCellRangeByName('B1').String:= 'Values';
  Randomize;
  for n:= 1 to 15 do begin
    firstSheet.getCellByPosition(0, n).String:= 'Row' +IntToStr(n+1);
    firstSheet.getCellByPosition(1, n).Value:= Random * 1000.0;
  end;
  ShowMessage(OOoMess107);
  aRange:= firstSheet.getCellRangeByName('A1:B16');
  fields:= CreateUnoStruct('com.sun.star.table.TableSortField', 0);
  fields[0].Field:= 1;
  fields[0].IsAscending:= True;
  fields[0].IsCaseSensitive:= True;

  { il faut préciser quel type de séquence est transmis à la propriété SortFields
    you must specify which type of sequence is transmitted to SortFields property }
  unoWrap:= OpenOffice.Bridge_GetValueObject;
  unoWrap.set('[]com.sun.star.table.TableSortField', fields);
  { remplissage de SortDescriptor : propriétés ayant des valeurs autres que défaut
    filling of SortDescriptor : properties with non-default values       }
  sortDx:= CreateProperties(['ContainsHeader', True, 'SortFields', unoWrap]);

  aRange.sort(sortDx);
  ShowMessage(OOoMess108);
  myDoc.close(True);
end;


procedure setCellBorders;
var
  myDoc, allSheets, mySheet, myCell, oneBorder: Variant;
begin
  myDoc:= StarDesktop.loadComponentFromURL('private:factory/scalc', '_blank', 0, dummyArray);
  { un nouveau document Calc a toujours 3 feuilles
    a new Calc document always has 3 sheets           }
  allSheets:= myDoc.Sheets;
  mySheet:= allSheets.getByIndex(2);  // third sheet of the spreadsheet
  mySheet.Name:= 'test';  // change its name
  myCell:= mySheet.getCellRangeByName('C2');
  myCell.String:= OOoMess111;
  { il faut créer une nouvelle structure Uno pour chaque bord,
    sinon les quatre bordures vont pointer sur la même structure Uno

    you must create a new Uno structure for each border
    otherwise all 4 borders will point at the same Uno structure }
  oneBorder:= CreateUnoStruct('com.sun.star.table.BorderLine');
  oneBorder.Color:= RGB(200,0,0);
  oneBorder.OuterLineWidth:= 30;
  myCell.LeftBorder:= oneBorder; // single red line
  oneBorder:= CreateUnoStruct('com.sun.star.table.BorderLine');
  oneBorder.Color:= RGB(200,0,0);
  oneBorder.OuterLineWidth:= 100;
  myCell.RightBorder:= oneBorder; // single red line
  oneBorder:= CreateUnoStruct('com.sun.star.table.BorderLine');
  oneBorder.Color:= RGB(0,120,0);
  oneBorder.OuterLineWidth:= 100;
  oneBorder.InnerLineWidth:= 60;
  oneBorder.LineDistance:= 30;
  myCell.TopBorder:= oneBorder; // double green line
  oneBorder:= CreateUnoStruct('com.sun.star.table.BorderLine');
  oneBorder.Color:= RGB(0,0,120);
  oneBorder.OuterLineWidth:= 100;
  oneBorder.InnerLineWidth:= 60;
  oneBorder.LineDistance:= 30;
  myCell.BottomBorder:= oneBorder; // double blue line
  myDoc.CurrentController.ActiveSheet:= mySheet;  // show this sheet
  ShowMessage(OOoMess105);
  myDoc.close(True);
end;



procedure drawPolygon;
var
  myDoc, myPage, myDrawing, thePoints: Variant;
begin
  myDoc:= StarDesktop.loadComponentFromURL('private:factory/sdraw', '_blank', 0, dummyArray);
  myPage:= myDoc.DrawPages.getByIndex(0);
  { invoquer un service à  partir d'un objet Uno
    invoke a service from a Uno object               }
  myDrawing:= myDoc.createInstance('com.sun.star.drawing.PolyLineShape');
  myPage.add(myDrawing);
  myDrawing.LineWidth:= 100;    myDrawing.LineColor:= RGB(50, 200, 200);
  { créer et remplir un tableau de structures pour l'affecter à une propriété
    create and fill an array of structures to assign it to a property    }
  thePoints:=  CreateUnoStruct('com.sun.star.awt.Point', 3);
  thePoints[0].X:= 4000;   thePoints[0].Y:= 2000;
  thePoints[1].X:= 4500;   thePoints[1].Y:= 5000;
  thePoints[2].X:= 11500;  thePoints[2].Y:= 8000;
  thePoints[3].X:= 6000;   thePoints[3].Y:= 11000;
  { VarArrayOf sert à obtenir un tableau de polygones, ici avec un seul polygone
    VarArrayOf is used to create an array of polygons, here there is only one polygon }
  myDrawing.PolyPolygon:= VarArrayOf([thePoints]);
  ShowMessage(OOoMess105);
  myDoc.close(True);
end;


{ Ces séquences sont à usage interne, mais elles peuvent servir d'exemples
  These sequences are for internal use but may be useful as examples    }
procedure TestSequences;
const lf = #10;
var
  myDoc, v, insp, info2 : Variant;
  myTest, c, c2: Integer; m, p, p2: String;

begin
  Repeat
    myTest:= StrToInt(InputBox('COM_OOo tests', 'Choose a test number', '0'));
    Case myTest of
    1 : begin  // get an array of String from a Uno object (more than 800 items)
        v:= OpenOffice.AvailableServiceNames;
        ShowMessage('Index max = ' +IntToStr(VarArrayHighBound(v, 1))
          +lf + 'v[10] =' + v[10]);
      end;
    2 : Repeat   // Convert to and from URL
        m:= InputBox('COM_OOo tests', 'MS-Windows address', '');
        if Length(m) = 0  then Break;
        p:= ConvertToURL(m);  p2:= ConvertFromURL(p);
        ShowMessage(m +lf +p +lf +p2 +lf +lf +'Identity ? ' +BoolToStr(m=p2, True));
      until False;
    3 : Repeat   // color conversions
        c:= StrToInt(InputBox('COM_OOo tests', 'Color value ', '0'));
        c2:= RGB(Red(c), Green(c), Blue(c));
        ShowMessage('Color : ' +IntToStr(c)
          +lf +'Red = ' +IntToStr(Red(c))
          +lf +'Green = ' +IntToStr(Green(c))
          +lf +'Blue = ' +IntToStr(Blue(c))
          +lf +'OOoRGB(R,G,B) : ' +IntToStr(c2)
          +lf +lf +'Identity ? ' +BoolToStr(c=c2, True));
      until c=0;
    20 : begin  // CreateUnoStruct, one structure
        v:= CreateUnoStruct('com.sun.star.table.BorderLine');
        v.Color:= 12345;
        ShowMessage('Color : '+IntToStr(v.Color));
      end;
    21 : begin  // CreateUnoStruct, array of structures
        v:= CreateUnoStruct('com.sun.star.table.BorderLine', 3);
        c:= VarArrayHighBound(v, 1);
        v[0].Color:= 54321;
        v[c].OuterLineWidth:= 147;
        ShowMessage('Index max : ' +IntToStr(c)
          +lf +'Color : ' +IntToStr(v[0].Color)
          +lf +'OuterLineWidth : ' +IntToStr(v[c].OuterLineWidth));
      end;
    30 : begin  // MakePropertyValue
        v:= MakePropertyValue('Height', 175);
        ShowMessage('Property name : '+v.Name);
      end;
    40 : begin // CreateProperties
        v:= CreateProperties(['Width', 369, 'PrintNotes', True, 'Title', 'Hello']);
        c:= VarArrayHighBound(v, 1);
        ShowMessage('Index max : ' +IntToStr(c)
            +lf +v[0].Name +' : ' +IntToStr(v[0].Value)
            +lf +v[1].Name +' : ' +BoolToStr(v[1].Value, True)
            +lf +v[c].Name +' : ' +v[c].Value);
      end;
    End; // Case
    if (myTest >= 100) and (myTest < 200) then begin  // Writer document is needed
      myDoc:= StarDesktop.LoadComponentFromURL('private:factory/swriter', '_blank', 0, dummyArray);
      ShowMessage('Document is displayed');
      Case myTest of
      101 : begin  // HasUnoInterfaces
          ShowMessage('All interfaces supported ? ' + BoolToStr(HasUnoInterfaces(myDoc,
            ['com.sun.star.frame.XStorable',
            'com.sun.star.style.XAutoStylesSupplier',
            'com.sun.star.text.XTextGraphicObjectsSupplier']), True) );
        end;
      110 : begin  // dispatcher
          v:= CreateProperties(['Text', 'Hello World !']);
          execDispatch('.uno:InsertText', v); execDispatch('.uno:InsertPara', dummyArray);
        end;
      111 : begin  // Clipboard
          ShowMessage('Select something'); copyToClipboard;
          ShowMessage('Put cursor elsewhere'); pasteFromClipboard;
        end;
      120 : begin  // runBasicMacro
          ShowMessage('Manually load the document testScript.odt with macros enabled');
          runBasicMacro('Standard.Module1.convertDevise', '73.5, 6.55957, Euros', '_testScript');
        end;
      130 : runScript('HelloWorld.helloworld.bsh', [], 'BeanShell', 'share');
      131 : begin  // get returned value from a script
          ShowMessage('Using resident macro : Standard.Testage.MultiplyByPi');
          v:= runScript('Standard.Testage.MultiplyByPi', [67]);
          ShowMessage('Result from macro : ' +IntToStr(v));
        end;
      140 : xray(myDoc); // Delphi Xray
      141 : BasicXray(myDoc); // Basic Xray must be installed !
      150 : // checks that print method is not intercepted by the compiler
        myDoc.print(dummyArray);
      151 : begin // check max index for an empty array
          v:= myDoc.TextTables.ElementNames;
          ShowMessage('Index max = ' +IntToStr(VarArrayHighBound(v, 1)));
        end;
      152 : begin // check that a Null object is recognized
          v:= myDoc.TextTables;
          ShowMessage('TextTables object is Null ? ' + BoolToStr(IsNullEmpty(v), True));
          v:= myDoc.XForms;
          ShowMessage('XForms object is Null ? ' + BoolToStr(IsNullEmpty(v), True));
        end;
      160 : begin  // (based on Xray code) this may not work if OpenOffice Registry is incorrect
        insp := OOoIntrospection.inspect(myDoc);
        info2 := insp.getProperty('ApplyFormDesignMode', -1);
        v := info2.Type;
        m:= v.Name;  // check that v is a com.sun.star.beans.Property
        ShowMessage('info2.Type.Name = boolean ? ' + BoolToStr(m = 'boolean', True));
      end;
      End; // Case
      ShowMessage(OOoMess105); myDoc.Close(True);
    end; // if
  Until myTest = 0;
end;






end.