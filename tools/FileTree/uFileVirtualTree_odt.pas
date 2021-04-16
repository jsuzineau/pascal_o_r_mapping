unit uFileVirtualTree_odt;

{$mode objfpc}{$H+}

interface

uses
    uOpenDocument,
    uOD_JCL,
    uOD_Temporaire,
    uFileVirtualTree,
 Classes, SysUtils, VirtualTrees, DOM;

function FileVirtualTree_odt( _Template_Filename: String; _hvst: ThVirtualStringTree): String;

implementation

function FileVirtualTree_odt( _Template_Filename: String; _hvst: ThVirtualStringTree): String;
var
   od: TOpenDocument;
   eLIST: TDOMNode;
   procedure Clear_List;
   var
      e: TDOMNode;
      function Get_list_item: TDOMNode;
      begin
           e:= Elem_from_path( eLIST,'text:list-item');
           Result:= e;
      end;
   begin
        while nil <> Get_list_item
        do
          FreeAndNil( e);
   end;
   procedure Add_node( _vn: PVirtualNode; _eRoot: TDOMNode);
   var
      list_item: TOD_LIST_ITEM;
      td: TTreeData;
      procedure Process_node_text( _node_text: String);
      var
         paragraph: TOD_PARAGRAPH;
      begin
           paragraph:= TOD_PARAGRAPH.Create( od, list_item.e);
           try
              paragraph.AddText( _node_text);
           finally
                  FreeAndNil( paragraph);
                  end;
      end;
      procedure Process_node_childs;
      var
         child_list: TOD_LIST;
         child: PVirtualNode;
      begin
           if 0 = _vn^.ChildCount then exit;

           child_list:= TOD_LIST.Create( od, list_item.e);
           try
              child:= _hvst.vst.GetFirstChild( _vn);
              while nil <> child
              do
                begin
                Add_node( child, child_list.e);
                child:= _hvst.vst.GetNextSibling(child);
                end;
           finally
                  FreeAndNil( child_list);
                  end;
      end;
   begin
        list_item:= TOD_LIST_ITEM.Create( od, _eRoot);
        try
           td:= _hvst.TreeData_from_Node( _vn);
           if nil = td
           then
               Process_node_text( ' ')
           else
               Process_node_text( td.Text+#9+td.Value);
           Process_node_childs;
        finally
               FreeAndNil( list_item);
               end;
   end;
begin
     od:= TOpenDocument.Create_from_template( _Template_Filename);
     eLIST:= Elem_from_path( od.Get_xmlContent_TEXT,'text:list');
     try
        Clear_List;
        Add_node( _hvst.vst.RootNode, eLIST);
        od.Save;
        Result:= od.Nom;
     finally
            FreeAndNil( od);
            end;
end;

end.

