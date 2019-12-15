Pascal O R Mapping
(french version follows)

With datasets you can not modelize your line of database table as an object.
Especially, it's problematic when you have a special behaviour, special methods for data in a given database table.

My first try (around 2002) to share behaviour (methods, calcfields) across datasets
was to "clip" a handler on the dataset, hooking all its events
( you'll find the base class for this in pascal_o_r_mapping/3_Data/uhRequete.pas: ThRequete).

But when you need a quick random access to several lines at the same time
(for example to display a planning), it's nearly impossible and very slow with a dataset.

So (around 2003), I began to map my datasets to lists of objects.
For each line of the dataset, a line object is created (base class TBatpro_Ligne),
and for each field of the line a field object (class TChamp) is "clipped" on the member of your class.

A "Save_to_dabase" method in the TBatpro_Ligne class ensures the direct return trip of modified objects to the database.

This has two advantages:
- You can manipulate directly the members of your class, implement behaviours and methods.
- field objects allow to implement the functionnality of datasets:
In a general code that doesn't particularly "know" your line class, for example display in a form
or reporting in an Open Office document, the fields can also be accessed by their names in you line object
 through the field objects.

Basically this library provides the mean to achieve this goal: create a list of objects from a TDataset.
Then around, you have all the bells and whistles to use these lists in the most common contexts 
where you usually use a TDataset. For example to edit a field value, instead of using 
a TDBEdit component you can use a TChamp_Edit.
In a dataset, you can have access to one line at a time. But with this mapping 
you can build complex relations between all the objects, directly reflecting 
the underlying UML class diagram. For example in our planning software, tasks are read 
from a single table and end up displayed in a tree. Each object-task can be connected 
to objects representing teams, employees, vehicles, tools, a bit like a piece of fabric. 
You can get several different views of this fabric, listing the planning of an employee,
or the affectations of a tool. May be it's not completely impossible to achieve with datasets,
but it's a lot more easier to do this way.
See wiki for more details soon.

======================================================================================

Avec des datasets vous ne pouvez pas représenter votre ligne de table de base de données comme un objet.

C'est surtout délicat quand les lignes d'une table donnée ont un comportement spécial, des méthodes spécifiques.

Ma première idée (vers 2002), pour partager des comportements (méthodes, champs calculés) entre des datasets,
fut de "clipser" un gestionnaire sur le dataset, en interceptant tous ses évènements.
( vous trouverez la classe de base pour cette fonctionnalité dans pascal_o_r_mapping/3_Data/uhRequete.pas: ThRequete).

Mais quand vous avez besoin d'un accés direct rapide à plusieurs lignes différentes en même temps
(par exemple pour afficher un planning), c'est pratiquement impossible à faire et trés lent avec un dataset.

C'est pourquoi vers 2003 j'ai commencé à projeter le contenu de mes datasets dans des listes d'objets.
Pour chaque ligne du dataset, un objet ligne est créé (classe de base TBatpro_Ligne),
et pour chaque champ de la ligne, un objet champ (classe TChamp) est "clipsé" sur le membre de votre classe.

Une méthode "Save_to_dabase" dans la classe TBatpro_Ligne assure le retour direct des objets modifiés dans la base de données.

Cela présente deux avantages :
- vous pouvez manipuler directement les membres de votre classe, implémenter des comportements et des méthodes.
- les objets champ permettent d'implémenter les fonctionnalités des datasets:
Danbs un code général qui ne "connait" pas particulièrement votre classe ligne, par exemple l'affichage dans une fenêtre
ou l'impression dans un document Open Office, l'accés aux champs peut se faire par leur nom dans votre objet ligne
par l'intermédiaire des objets champ.

Essentiellement cette bibliothèque vous permet d'atteindre ce but:  créer une liste d'objets à partir d'un TDataset.
Elle contient également toute la quincaillerie nécessaire pour utiliser ces listes dans les 
situations les plus courantes où l'on utilise un TDataset. Par exemple pour modifier la valeur d'un champ,
un composant TChamp_Edit rendra les mêmes services qu'un TDBEdit. 
Alors qu'un dataset vous permet d'accéder à une seule ligne à la fois, vous pouvez ici construire 
des relations complexes entre les objets, reflétant le diagramme de classes UML sous-jacent.
Par exemple dans notre logiciel de planning, les tâches sont lues dans une seule table avant 
d'être affichées sous forme d'arbre. Chaque objet-tâche peut être connecté à des objets 
représentant des équipes, des salariés, des véhicules, des outils, réalisant une sorte de tissu.
Vous pouvez obtenir plusieurs vues différentes de ce tissu, par exemple le planning d'un salarié 
ou les affectations d'un outil. Cela n'est peut-être pas complètement impossible à faire 
avec des datasets mais c'est beaucoup plus simple à coder de cette façon.
Plus de détails sur le wiki dans peu de temps.
