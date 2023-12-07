# Very minimalist documentation:

Programs:
-Generateur: source code generator working on database defined in etc/_Configuration.ini
-Generateur_Modeles: template editor for Generator for key values produced from other key values, can be modified  in directory Generateur_de_code/01_Listes

Subdirectories:
-Generateur_de_code/05_ApplicationTemplate: 
--templates at the level of the whole application (for example to generate one menu item for each table)
--keys are replaced by something build with several table names

-Generateur_de_code/03_Template:
--template at the level of one table.
--each template is duplicated for each table

-Generateur_de_code/01_Listes
--key value produced from other key values, can be modified with Generateur_Modeles
   a key value is defined in a specific subdirectory by 5 files:
---the key with 01_key in the file name
---the prefix of the value 02_begin for example "(" for list enclosed by parenthesis
---the definition of the element 03_element . Keywords in this element will be expanded upon production of the value
---the separator between elements 04_separateur for example "," for list where each elements are separed by a coma.
---the suffix 05_end for example ")" for list enclosed by parenthesis
--Generateur_de_code/01_Listes/Tables works at the application to produce a key value based on the different table names.
--The others subdirectories of Generateur_de_code/01_Listes work at the table level to produce a key value based on field names:
---Generateur_de_code/01_Listes/Aggregations for "one to many" relation (current table line relate to many lines in another table)
---Generateur_de_code/01_Listes/Details current table line relate to one line in another table
---Generateur_de_code/01_Listes/Symetric . Related to pascal "uses" units hierarchy, you need the code for the two tables in the same unit. Current table line relate to one line in another table and you need the same access from both sides of the relation.
---Generateur_de_code/01_Listes/Membres the simple case, to produce a key value based on field names of the table 
