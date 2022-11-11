unit uOD_Label_Printer;

{$mode objfpc}{$H+}

interface

uses
    uuStrings,
    uBatpro_StringList,
    uChamp,
    uBatpro_Ligne,
    uOD_Temporaire,
    uOD_JCL,
    uOpenDocument,
 Classes, SysUtils, FileUtil, LCLIntf, DOM;

type

    { TOD_Label_Printer }

    TOD_Label_Printer
    =
     class
     //Gestion du cycle de vie
     public
       constructor Create( _TemplateName: String; _sl: TBatpro_StringList);
       destructor Destroy; override;
     //Champs
     public
       NomODT: String;
       od: TOpenDocument;
       sl: TBatpro_StringList;
     //Méthodes
     private
       procedure Execute;
     public
       procedure Open_ODT;
       procedure Open_Content;
       procedure Open_Styles;
       procedure Explorer_on_folder;
     end;

implementation

{ TOD_Label_Printer }

constructor TOD_Label_Printer.Create( _TemplateName: String;
                                      _sl: TBatpro_StringList);
begin
     sl:= _sl;
     NomODT:= OD_Temporaire.Nouveau_ODT( 'LABEL');
     CopyFile( _TemplateName, NomODT);
     od:= TOpenDocument.Create( NomODT);
     Execute;
end;

destructor TOD_Label_Printer.Destroy;
begin
     FreeAndNil( od);
     inherited Destroy;
end;

procedure TOD_Label_Printer.Execute;
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
      bl: TBatpro_Ligne;
      c: TChamp;
      Value: String;
   begin
        for i:= Low(frames) to High(frames)
        do
          begin
          bl:= Batpro_Ligne_from_sl( sl, i);
          if bl = nil then continue;

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
                   continue;
               c:= bl.Champs.Champ_from_Field( FieldName);
               if nil = c then continue;

               Value:= c.asString;
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
          frame2_name:= s_draw_frame_name_prefix+IntToStr(Length(frames)+i+1);
          set_Property( frame2, s_draw_name, frame2_name);
          Set_Property( frame2, 'text:anchor-page-number', '2')
          end;
   end;
begin
     office_text:= od.Get_xmlContent_TEXT;
     cir:= TCherche_Items_Recursif.Create( office_text, s_draw_frame, [], []);
     try
        frames_from_cir;
        Copy_frame1;
        Fill_cells;
        //Copy_page2;
     finally
            FreeAndNil( cir);
            end;

     od.Save;
end;

procedure TOD_Label_Printer.Open_ODT;
begin
     OpenDocument( NomODT);
end;

procedure TOD_Label_Printer.Open_Content;
begin
     OpenDocument( IncludeTrailingPathDelimiter( od.Repertoire_Extraction)+'content.xml');
end;

procedure TOD_Label_Printer.Open_Styles;
begin
     OpenDocument( IncludeTrailingPathDelimiter( od.Repertoire_Extraction)+'styles.xml');
end;

procedure TOD_Label_Printer.Explorer_on_folder;
begin
     ExecuteProcess( 'C:\Windows\explorer.exe', ['/root,'+ExtractFilePath( NomODT)]);
end;

end.

