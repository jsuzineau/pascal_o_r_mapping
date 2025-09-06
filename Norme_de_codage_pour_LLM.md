# Norme de codage pour langage Pascal objet

## 1.Indentation des blocs
### 1.1 Règle générale:
- Les lignes du corps du bloc "begin end" et la ligne du "end" 
  ont la même indentation que la ligne du "begin".
- Exemple:
```pascal
begin
xxxxx;
yyyyy;
end;
```
### 1.2 Cas particulier du bloc principal "begin end" d'un "program", d'une "function" ou d'une "procedure": 
- Le "end" a la même indentation que le "begin".
- Les lignes du corps du bloc "begin end" sont indentées de 5 caractères par rapport au "begin"
- Exemple pour le bloc principal "begin end" d'un "program":
```pascal
begin
     xxxxx;
     yyyyy;
end.
```
- Exemple pour le bloc principal "begin end" d'une "function" ou d'une "procedure":
```pascal
begin
     xxxxx;
     yyyyy;
end;
```

## 2. Indentation sur une instruction "if then else"
- le "then" vient sur une nouvelle ligne avec la même indentation que le "if"
- le "else" vient sur une nouvelle ligne avec la même indentation que le "if"
- l'instruction (ou le "begin" du bloc) du "then" vient sur une nouvelle ligne, indenté de 4 caractères par rapport au "then"
- l'instruction (ou le "begin" du bloc) du "else" vient sur une nouvelle ligne, indenté de 4 caractères par rapport au "else"
- Exemple pour une instruction "if then else" avec instructions simples:
```pascal
if truc > 0
then
    xxxxxx
else
    yyyyyy;
```
- Exemple pour une instruction "if then else" avec des blocs d'instructions:
```pascal
if truc > 0
then
    begin
    xxxxxx;
    yyyyyy;
    end
else
    begin
    zzzzzzz;
    aaaaaaa;
    end;
```
## 3. Indentation sur une instruction "while do"
- le "do" vient sur une nouvelle ligne avec la même indentation que le "while"
- l'instruction (ou le "begin" du bloc) du "while do" vient sur une nouvelle ligneaprés le "do", indenté de 2 caractères par rapport au "do"
- Exemple pour une instruction "while do" avec instruction simple:
```pascal
while truc > 0
do
  xxxxxx;
```
- Exemple pour une instruction "while do" avec des blocs d'instructions:
```pascal
while truc > 0
do
  begin
  xxxxxx;
  yyyyyy;
  end;
```
## 4. Indentation d'une section "var"
- On ajoute un saut de ligne aprés le mot "var"
- la déclaration des variables est indentée de 3 caractères par rapport au "var"
- Exemple:
```pascal
var
   a: Integer;
   b: String; 
```

## 5. Indentation pour la déclaration d'une class
- Le nom de la classe est placé sur une nouvelle ligne. 
- Le nom de la classe est indenté de 1 caractère par rapport au mot "type"
- Aprés le nom de la classe le "=" est placé sur une nouvelle ligne.
- Le "=" a la même indentation que le nom de la classe
- Le mot "class" est placé sur une nouvelle ligne.
- Le mot "class" est indenté de 1 caractère par rapport au "="
- les directives "private", "public","protected", "published" sont placées sur une nouvelle ligne.
- les directives "private", "public","protected", "published" ont la même indentation que le mot "class".
- les déclarations d'attributs sont indentées de 2 caractères par rapport au mot "class".
- les déclarations de méthodes sont indentées de 2 caractères par rapport au mot "class".
- Le mot "end;" a la même indentation que le mot "class"
- Exemple:
```pascal
type
 { TMaClasse }

 TMaClasse
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Host
  public
    Host_id  : cint;
    Host_sock: cint;
  end;  
```
## 5. Particularités pour la déclaration des attributs et méthodes d'une class
- les attributs et méthode d'une class sont regroupés par aspect dans des sections "private", "public","protected", "published".
- Chaque aspect est précédé d'un commentaire aligné sur le mot "class"
- Exemple:
```pascal
type
 { TMaClasse }

 TMaClasse
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Items
  private
    FItems: TBluetoothDevice_array;
    procedure Libere;
  public
    property Items: TBluetoothDevice_array read FItems;
  //code d'erreur
  private
    sError: String;
  //Initialisation
  private
    initialized: Boolean;
    function Initialize: Boolean;
  end;  
```
## 6. Particularités pour la déclaration du constructeur et du destructeur d'une class
- Le constructeur et le destructeur sont regroupés dans une section "public".
- Cette section est précédée d'un commentaire "//Gestion du cycle de vie" aligné sur le mot "class"
- le tout est placé en premier aprés le mot class
- Exemple:
```pascal
type
 { TMaClasse }

 TMaClasse
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Items
  private
    FItems: TBluetoothDevice_array;
    procedure Libere;
  public
    property Items: TBluetoothDevice_array read FItems;
  end;  
```
## 7 Déclarations de variables
- Ne pas déclarer de variables à l'intérieur d'un bloc "begin end"
- Toujours ramener la déclaration de variable dans une section "var"
  précédent le bloc "begin end;" de la "function", "procedure" 
  ou le le bloc "begin end." du programme
## 8 Nommage des paramètres de "procedure" et de "function":
- Le nom des paramètres doit commencer par un caractère _ .
## 9 Présentation des affectations:
- Ne pas mettre d'espace entre l'identificateur et le ":=".
- Exemple:
```pascal
Result:= xxx;
```
## 10 Formatage des listes de paramètres de l'entête d'une "function" ou d'une "procedure":
### 10.1 Si la liste des paramètres de l'entête d'une "function" ou d'une "procedure"
est trop longue pour tenir sur une ligne:
- faire un saut de ligne aprés chaque paramètre.
- à partir du deuxième paramètre, aligner le début du paramètre
  sur le début du premier paramètre.
- aligner la parenthèse fermante sur le début du premier paramètre.
- Exemple:
```pascal
procedure Truc( _a: Integer;
                _b: String;
                _c: Double
                );
```
### 10.2 En dehors de l'entête d'une "function" ou d'une "procedure",
les variables déclarées dans une section "var" ne doivent pas commencer par "_".
