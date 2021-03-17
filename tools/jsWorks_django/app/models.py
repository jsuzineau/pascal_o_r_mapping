from django.db import models
from django.utils import timezone


class Categorie(models.Model):
  Symbol     =models.CharField(db_column='Symbol'     ,max_length= 5,blank=True,null=True)
  Description=models.CharField(db_column='Description',max_length=42,blank=True,null=True)
  def __str__(self): return self.Symbol
  class Meta:
    managed =False
    db_table='Categorie'

class Contact(models.Model):
  Project =models.ForeignKey('Project' ,on_delete=models.SET_NULL,db_column='nProject' ,              blank=True,null=True)
  TContact=models.ForeignKey('TContact',on_delete=models.SET_NULL,db_column='nTContact',              blank=True,null=True)
  Value   =models. CharField(                                     db_column='Value'    ,max_length=42,blank=True,null=True)
  class Meta:
    managed = False
    db_table= 'Contact'

class Demander(models.Model):
  Project=models.ForeignKey('Project',on_delete=models.SET_NULL,db_column='nProject',              blank=True,null=True)
  Name   =models. CharField(                                    db_column='Name'    ,max_length=42,blank=True,null=True)
  Tel    =models. CharField(                                    db_column='Tel'     ,max_length=42,blank=True,null=True)
  class Meta:
    managed = False
    db_table= 'Demander'


class Development(models.Model):
  Project     =models.  ForeignKey('Project'  ,on_delete=models.SET_NULL,db_column='nProject'     ,blank=True,null=True)
  State       =models.  ForeignKey('State'    ,on_delete=models.SET_NULL,db_column='nState'       ,blank=True,null=True)
  CreationWork=models.  ForeignKey('Work'     ,on_delete=models.SET_NULL,db_column='nCreationWork',blank=True,null=True)
  SolutionWork=models.  ForeignKey('Work'     ,on_delete=models.SET_NULL,db_column='nSolutionWork',blank=True,null=True)
  Description =models.   TextField(                                      db_column='Description'  ,blank=True,null=True)
  Steps       =models.   TextField(                                      db_column='Steps'        ,blank=True,null=True)
  Origin      =models.   TextField(                                      db_column='Origin'       ,blank=True,null=True)
  Solution    =models.   TextField(                                      db_column='Solution'     ,blank=True,null=True)
  Categorie   =models.  ForeignKey('Categorie',on_delete=models.SET_NULL,db_column='nCategorie'   ,blank=True,null=True)
  isBug       =models.BooleanField(                                      db_column='isBug'        ,blank=True,null=True)
  Demander    =models.  ForeignKey('Demander' ,on_delete=models.SET_NULL,db_column='nDemander'    ,blank=True,null=True)
  SheetRef    =models.  ForeignKey('SheetRef' ,on_delete=models.SET_NULL,db_column='nSheetRef'    ,blank=True,null=True)
  def __str__(self): return self.Description
  class Meta:
    managed  = False
    db_table = 'Development'


class JourFerie(models.Model):
  Jour=models.DateField(db_column='Jour',blank=True, null=True)
  class Meta:
    managed = False
    db_table= 'Jour_ferie'


class Project(models.Model):
  Name=models.CharField(db_column='Name', max_length=42, blank=True, null=True)
  def __str__(self): return self.Name
  def Start(self):
    print("Project.Start")
    return Work.Start( self)

  class Meta:
    managed = False
    db_table= 'Project'


class Sheet(models.Model):
  Image=models.TextField(db_column='Image',blank=True,null=True)
  class Meta:
    managed = False
    db_table= 'Sheet'


class Sheetref(models.Model):
  Sheet =models.ForeignKey  ('Sheet', on_delete=models.SET_NULL, db_column='nSheet' ,blank=True,null=True)
  Left  =models.IntegerField(                                    db_column='_Left'  ,blank=True,null=True)
  Top   =models.IntegerField(                                    db_column='_Top'   ,blank=True,null=True)
  Width =models.IntegerField(                                    db_column='_Width' ,blank=True,null=True)
  Height=models.IntegerField(                                    db_column='_Height',blank=True,null=True)
  class Meta:
    managed = False
    db_table= 'Sheetref'


class State(models.Model):
  Symbol     =models.CharField(db_column='Symbol'     , max_length= 5, blank=True, null=True)
  Description=models.CharField(db_column='Description', max_length=42, blank=True, null=True)
  def __str__(self): return self.Symbol
  class Meta:
    managed = False
    db_table= 'State'


class TContact(models.Model):
  Name= models.CharField(db_column='Name', max_length=42, blank=True, null=True)
  def __str__(self): return self.Name
  class Meta:
    managed = False
    db_table= 'TContact'


class Tag(models.Model):
  Type=models.ForeignKey('Type',on_delete=models.SET_NULL,db_column='idType',              blank=True,null=True)
  Name=models. CharField(                                 db_column='Name'  ,max_length=42,blank=True,null=True)
  def __str__(self): return self.Name
  class Meta:
    managed = False
    db_table= 'Tag'


class TagDevelopment(models.Model):
  Tag        =models.ForeignKey('Tag'        ,on_delete=models.SET_NULL,db_column='idTag'        , blank=True,null=True)
  Development=models.ForeignKey('Development',on_delete=models.SET_NULL,db_column='idDevelopment', blank=True,null=True)
  class Meta:
    managed = False
    db_table= 'Tag_Development'


class TagWork(models.Model):
  Tag =models.ForeignKey('Tag' ,on_delete=models.SET_NULL,db_column='idTag' ,blank=True,null=True)
  Work=models.ForeignKey('Work',on_delete=models.SET_NULL,db_column='idWork',blank=True,null=True)
  class Meta:
    managed = False
    db_table= 'Tag_Work'


class TypeTag(models.Model):
  Name=models.CharField(db_column='Name',max_length=42,blank=True,null=True)
  def __str__(self): return self.Name
  class Meta:
    managed = False
    db_table= 'Type_Tag'


class User(models.Model):
  name    =models.   CharField(db_column='Name'    ,max_length=42,blank=True,null=True)
  initials=models.   CharField(db_column='Initials',max_length= 5,blank=True,null=True)
  islogged=models.BooleanField(db_column='isLogged',              blank=True,null=True)
  def __str__(self): return self.Name
  class Meta:
    managed = False
    db_table= 'User'


class Work(models.Model):
  Project    =models.ForeignKey   ('Project',on_delete=models.SET_NULL,db_column='nProject'   ,blank=True,null=True)
  Beginning  =models.DateTimeField(                                    db_column='Beginning'  ,blank=True,null=True)
  End        =models.DateTimeField(                                    db_column='End'        ,blank=True,null=True)
  Description=models.    TextField(                                    db_column='Description',blank=True,null=True)
  User       =models.ForeignKey   ('User'   ,on_delete=models.SET_NULL,db_column='nUser'      ,blank=True,null=True)
  def __str__(self): return '' if self.Description is None else self.Description
  @property
  def Duree(self): return 0 if self.End < self.Beginning else self.End - self.Beginning
  @classmethod
  def Start(cls, _project):
    print("Work.Start")
    w= cls(Project=_project)
    w.Beginning=timezone.now()
    return w
  def Stop(self):self.End=timezone.now()
  class Meta:
    managed = False
    db_table= 'Work'


class g_becp(models.Model):
  nomclasse=models.CharField(max_length=50)
  libelle  =models.CharField(max_length=80, blank=True, null=True)

  class Meta:
    managed = False
    db_table= 'g_becp'


class g_becpctx(models.Model):
  nomclasse =models.   CharField(max_length=50)
  contexte  =models.IntegerField()
  logfont   =models. BinaryField(blank=True, null=True)
  stringlist=models.   TextField(blank=True, null=True)

  class Meta:
    managed = False
    db_table= 'g_becpctx'

class g_ctx(models.Model):
  contexte    =models.IntegerField()
  contextetype=models.   CharField(max_length=50, blank=True, null=True)
  libelle     =models.   CharField(max_length=80, blank=True, null=True)
  class Meta:
    managed = False
    db_table= 'g_ctx'


class g_ctxtype(models.Model):
  contextetype=models.CharField(max_length=50)
  hierarchie  =models.CharField(max_length=50, blank=True, null=True)
  libelle     =models.CharField(max_length=80, blank=True, null=True)

  class Meta:
    managed = False
    db_table= 'g_ctxtype'
