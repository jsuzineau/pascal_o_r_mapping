// Réponse Response.name Response.description
Response.Has_content_comment_start
function TVerb.Nom_de_la_classe.R_Response.name( _i: Integer=0): TResponse.Class_Name_Result;
var
   i: Integer;
   ja: TJSONArray;
   r: TResponse.Class_Name;
begin
     if Response.content_is_array
     then
         begin
         ja:= jdResult as TJSONArray;
         SetLength( Result, ja.Count);
         for i:= 0 to ja.Count-1
         do
           begin
           r:= TResponse.Class_Name.Create(nil,nil,nil);
           r.JSON:= ja.Items[i].AsString;
           Result[ i]:= r;
           end;
         end
     else
         begin
         Result:= TResponse.Class_Name.Create(nil,nil,nil);
         Result.JSON:= sResult;
         end;
end; 
Response.Has_content_comment_stop
