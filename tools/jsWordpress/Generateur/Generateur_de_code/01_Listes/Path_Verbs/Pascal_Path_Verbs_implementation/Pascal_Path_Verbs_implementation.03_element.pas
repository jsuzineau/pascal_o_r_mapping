{ TVerb.Nom_de_la_classe }

constructor TVerb.Nom_de_la_classe.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-jsonPath.name';
     Verb:= 'Verb.name';
end;

destructor TVerb.Nom_de_la_classe.Destroy;
begin
     inherited Destroy;
end;

// TVerb.Nom_de_la_classe Parameters

Verb.Parameters_Implementation

// TVerb.Nom_de_la_classe Properties

Verb.Properties_Implementation

// TVerb.Nom_de_la_classe Responses

Verb.Responses_Implementation

