unit utcOpenDocument_Etiquettes;

{$mode objfpc}{$H+}

interface

uses
    uuStrings,
    uOD_Temporaire,
    uOpenDocument,
    uOD_JCL,
 Classes, SysUtils, fpcunit, testutils, testregistry, FileUtil,LCLIntf, DOM,dialogs;

type

 { TtcOpenDocument_Etiquettes }

 TtcOpenDocument_Etiquettes
 =
  class(TTestCase)
  private
    NomODT: String;
    od: TOpenDocument;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure test_Etiquettes;
  end;

implementation

procedure TtcOpenDocument_Etiquettes.SetUp;
begin
     NomODT:= OD_Temporaire.Nouveau_ODT( 'TEST');
     CopyFile( 'tcOpenDocument_Etiquettes.odt', NomODT);
     //CopyFile( '/home/jean/temp/BCR05XXXXXXVIR.ott', NomODT);
     od:= TOpenDocument.Create( NomODT);
end;

procedure TtcOpenDocument_Etiquettes.TearDown;
begin
     FreeAndNil( od);
     //DeleteFile( NomODT);
end;

procedure TtcOpenDocument_Etiquettes.test_Etiquettes;
const
     s_draw_frame='draw:frame';
     s_draw_frame_name_prefix='Cadre';
     s_draw_name='draw:name';
var
   office_text: TDOMNode;
   cir: TCherche_Items_Recursif;
   frame1: TDOMNode;
   frames: array of TDOMNode;
   procedure frames_from_cir;
   var
      frame: TDOMNode;
      name: String;
      sNumber: String;
      Number: Integer;
      Index: Integer;
   begin
        SetLength( frames, cir.l.Count);
        for frame in cir.l
        do
          begin
          if not_Get_Property( frame, s_draw_name, name) then continue;

          StrTok(s_draw_frame_name_prefix, name);
          sNumber:= name;
          if not TryStrToInt( sNumber, Number) then continue;

          if 1 = Number then frame1:= frame;

          Index:= Number-1;
          frames[Index]:= frame;
          end;
   end;
   procedure Copy_frame1;
   var
      frame: TDOMNode;
      tb1, tb: TDOMNode;
      function textbox_from_frame( _f: TDOMNode): TDOMNode;
      begin
           Result:= Elem_from_path(_f, 'draw:text-box');
      end;
   begin
        tb1:= textbox_from_frame( frame1);
        for frame in cir.l
        do
          begin
          if frame1 = frame then continue;
          tb:= textbox_from_frame( frame);
          RemoveChilds( tb);
          Copie_Item( tb1, tb);
          end;
   end;
   procedure Fill_cells;
   var
      I: Integer;
      frame: TDOMNode;
      cirTEXT_DATABASE_DISPLAY: TCherche_Items_Recursif;
      text_database_display: TDOMNode;
      text: TDOMNode;
      FieldName: String;
      Value: String;
   begin
        for i:= Low(frames) to High(frames)
        do
          begin
          frame:= frames[i];
          cirTEXT_DATABASE_DISPLAY
          :=
            TCherche_Items_Recursif.Create( frame, 'text:database-display', [], []);
          try
             for text_database_display in cirTEXT_DATABASE_DISPLAY.l
             do
               begin
               RemoveChilds( text_database_display);

               if not_Get_Property( text_database_display, 'text:column-name', FieldName)
               then
                   if not_Get_Property( text_database_display, 'column-name', FieldName)
                   then
                       Value:= '(no text:column-name, no column-name)/'+IntToStr(I)
                   else
                       Value:= '(column-name):'+FieldName+'/'+IntToStr(I)
               else
                   Value:= FieldName+'/'+IntToStr(I);
               text_database_display.TextContent:= Value;
               //od.AddHtml( text_database_display, Value);
               end;
          finally
                 FreeAndNil( cirTEXT_DATABASE_DISPLAY);
                 end;
          end;
   end;
   {
   <draw:frame svg:x="0cm" svg:y="0.413cm" draw:name="Cadre1" svg:width="6.999cm" svg:height="4.126cm" draw:z-index="0" draw:style-name="fr1" text:anchor-type="page" text:anchor-page-number="1">
     <draw:text-box>
       <text:p text:style-name="P1">
         <text:database-display text:table-name="Resultat" text:table-type="table" text:column-name="Client" text:database-name="Etiquettes">Client 1</text:database-display>
       </text:p>
   }
   procedure Copy_page2;
   var
      I: Integer;
      frames_page2: array of TDOMNode;

      frame, newframe2, frame2: TDOMNode;
      frame2_name: String;
      frame2_number: String;
      procedure Ajout_saut_page;
      var
         saut_page: TDOMNode;
      begin
           saut_page:= Cree_path( office_text, 'text:p');
           set_Property( saut_page, 'text:style-name', 'SautPage');
      end;
   begin
        Ajout_saut_page;

        SetLength(frames_page2, length(frames));
        for i:= Low(frames) to High(frames)
        do
          begin
          frame:= frames[i];

          newframe2:= office_text.OwnerDocument.CreateElement( s_draw_frame);
          frame2:=office_text.AppendChild( newframe2);
          frames_page2[i]:= frame2;

          Copie_Item( frame, frame2);
          frame2_number:= IntToStr(Length(frames)+i+1);
          frame2_name:= s_draw_frame_name_prefix+frame2_number;
          set_Property( frame2, s_draw_name, frame2_name);
          Set_Property( frame2, 'text:anchor-page-number', '2');
          Set_Property( frame2, 'draw:z-index', frame2_number);
          end;
   end;
begin
     office_text:= od.Get_xmlContent_TEXT;
     cir:= TCherche_Items_Recursif.Create( office_text, s_draw_frame, [], []);
     try
        frames_from_cir;
        Copy_frame1;
        Fill_cells;
        Copy_page2;
     finally
            FreeAndNil( cir);
            end;

     //OpenDocument( IncludeTrailingPathDelimiter( od.Repertoire_Extraction)+'content.xml');
     //OpenDocument( IncludeTrailingPathDelimiter( od.Repertoire_Extraction)+'styles.xml');
     od.Save;
     //OpenDocument( IncludeTrailingPathDelimiter( od.Repertoire_Extraction)+'content.xml');
     //OpenDocument( IncludeTrailingPathDelimiter( od.Repertoire_Extraction)+'styles.xml');
     OpenDocument( NomODT);
     ExecuteProcess( 'C:\Windows\explorer.exe', ['/root,'+ExtractFilePath( NomODT)]);


//     Fail('Écrivez votre propre test');
end;


initialization
              RegisterTest(TtcOpenDocument_Etiquettes);
end.
