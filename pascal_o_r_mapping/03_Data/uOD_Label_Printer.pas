unit uOD_Label_Printer;

interface

uses
    uuStrings,
    uBatpro_StringList,
    uChamp,
    uBatpro_Ligne,
    uOD_Temporaire,
    uOD_JCL,
    uOpenDocument,
 Classes, SysUtils, FileUtil, LCLIntf, DOM,fgl;

type
    { TOD_Label_Printer_Page }

    TOD_Label_Printer_Page
    =
     class
     //Gestion du cycle de vie
     public
       constructor Create( _NomPage, _TemplateName: String; _sl: TBatpro_StringList; _sl_index_start: Integer=0);
       destructor Destroy; override;
     //Champs
     public
       Name, TemplateName: String;
       sl: TBatpro_StringList;
       sl_index_start: Integer;
       sl_index_stop : Integer;
       NomPage: String;
       NomODT: String;
       od: TOpenDocument;
     //Méthodes
     private
       procedure Execute;
       procedure Rename( _fin_nom_ODT: String);
     public
       procedure Open_ODT;
       procedure Open_Content;
       procedure Open_Styles;
       procedure Explorer_on_folder;
     end;
type
    TOD_Label_Printer_Page_List= TFPGObjectList<TOD_Label_Printer_Page>;

    { TOD_Label_Printer }

    TOD_Label_Printer
    =
     class
     //Gestion du cycle de vie
     public
       constructor Create( _Name, _TemplateName: String; _sl: TBatpro_StringList);
       destructor Destroy; override;
     //Champs
     public
       Name, TemplateName: String;
       sl: TBatpro_StringList;
       l: TOD_Label_Printer_Page_List;
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

constructor TOD_Label_Printer.Create( _Name, _TemplateName: String; _sl: TBatpro_StringList);
begin
     Name        := _Name        ;
     TemplateName:= _TemplateName;
     sl          := _sl          ;

     l:= TOD_Label_Printer_Page_List.Create;
     Execute;
end;

destructor TOD_Label_Printer.Destroy;
begin
     FreeAndNil( l);
     inherited Destroy;
end;

procedure TOD_Label_Printer.Execute;
var
   sl_index_start: Integer;
   olpp: TOD_Label_Printer_Page;
   NomPage: String;
begin
     sl_index_start:=0;
     while sl_index_start < sl.Count
     do
       begin
       if '' = Name
       then
           NomPage:= ''
       else
           NomPage:= Name+'_'+IntToStr(l.Count+1);
       olpp:= TOD_Label_Printer_Page.Create( NomPage, TemplateName, sl, sl_index_start);
       l.Add( olpp);
       sl_index_start:= olpp.sl_index_stop+1;
       end;

     for olpp in l
     do
       olpp.Rename('_sur_'+IntToStr(l.Count)+'.odt');
end;

procedure TOD_Label_Printer.Open_ODT;
var
   olpp: TOD_Label_Printer_Page;
begin
     for olpp in l
     do
       olpp.Open_ODT;
end;

procedure TOD_Label_Printer.Open_Content;
var
   olpp: TOD_Label_Printer_Page;
begin
     for olpp in l
     do
       olpp.Open_Content;
end;

procedure TOD_Label_Printer.Open_Styles;
var
   olpp: TOD_Label_Printer_Page;
begin
     for olpp in l
     do
       olpp.Open_Styles;
end;

procedure TOD_Label_Printer.Explorer_on_folder;
var
   olpp: TOD_Label_Printer_Page;
begin
     if l.Count = 0 then exit;
     olpp:= l.Items[0];
     olpp.Explorer_on_folder;
end;

{ TOD_Label_Printer_Page }

constructor TOD_Label_Printer_Page.Create( _NomPage,
                                           _TemplateName: String;
                                           _sl: TBatpro_StringList;
                                           _sl_index_start: Integer);
begin
     NomPage:= _NomPage;
     TemplateName  := _TemplateName  ;
     sl            := _sl            ;
     sl_index_start:= _sl_index_start;

     NomODT:= OD_Temporaire.Nouveau_ODT( 'LABEL');
     CopyFile( TemplateName, NomODT);

     od:= TOpenDocument.Create( NomODT);
     Execute;
end;

destructor TOD_Label_Printer_Page.Destroy;
begin
     FreeAndNil( od);
     inherited Destroy;
end;

procedure TOD_Label_Printer_Page.Execute;
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
      sl_index: Integer;
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
          frame:= frames[i];

          sl_index:= sl_index_start + i;
          sl_index_stop:= sl_index;//réaffecté, pas top
          bl:= Batpro_Ligne_from_sl( sl, sl_index);
          if bl = nil
          then
              begin
              RemoveChilds( frame);
              continue;
              end;

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

procedure TOD_Label_Printer_Page.Rename( _fin_nom_ODT: String);
var
   NewName: String;
begin
     if '' = NomPage then exit;

     NewName:= NomPage+_fin_nom_ODT;
     RenameFile( NomODT, NewName);
     NomODT:= NewName;
end;

procedure TOD_Label_Printer_Page.Open_ODT;
begin
     OpenDocument( NomODT);
end;

procedure TOD_Label_Printer_Page.Open_Content;
begin
     OpenDocument( IncludeTrailingPathDelimiter( od.Repertoire_Extraction)+'content.xml');
end;

procedure TOD_Label_Printer_Page.Open_Styles;
begin
     OpenDocument( IncludeTrailingPathDelimiter( od.Repertoire_Extraction)+'styles.xml');
end;

procedure TOD_Label_Printer_Page.Explorer_on_folder;
begin
     ExecuteProcess( 'C:\Windows\explorer.exe', ['/root,'+ExtractFilePath( NomODT)]);
end;

end.

