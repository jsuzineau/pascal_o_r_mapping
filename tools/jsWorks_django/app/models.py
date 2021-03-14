# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class Categorie(models.Model):
#  id         =models.AutoField(                                      blank=True,null=True)
  Symbol     =models.CharField(db_column='Symbol'     ,max_length= 5,blank=True,null=True)
  Description=models.CharField(db_column='Description',max_length=42,blank=True,null=True)
  def __str__(self): return self.Symbol
  class Meta:
    managed =False
    db_table='Categorie'

class Contact(models.Model):
#  id       =models.   AutoField(                                    blank=True,null=True)
  nProject =models.IntegerField(db_column='nProject'               ,blank=True,null=True)
  nTContact=models.IntegerField(db_column='nTContact'              ,blank=True,null=True)
  Value    =models.   CharField(db_column='Value'    ,max_length=42,blank=True,null=True)
  class Meta:
    managed = False
    db_table= 'Contact'

class Demander(models.Model):
#  id      =models.   AutoField(                                   blank=True, null=True)
  nProject=models.IntegerField(db_column='nProject',              blank=True, null=True)
  Name    =models.   CharField(db_column='Name'    ,max_length=42,blank=True, null=True)
  Tel     =models.   CharField(db_column='Tel'     ,max_length=42,blank=True, null=True)
  class Meta:
    managed = False
    db_table= 'Demander'


class Development(models.Model):
#  id           =models.   AutoField(blank=True, null=True)
  nProject     =models.IntegerField(db_column='nProject'     ,blank=True,null=True)
  nState       =models.IntegerField(db_column='nState'       ,blank=True,null=True)
  nCreationWork=models.IntegerField(db_column='nCreationWork',blank=True,null=True)
  nSolutionWork=models.IntegerField(db_column='nSolutionWork',blank=True,null=True)
  Description  =models.   TextField(db_column='Description'  ,blank=True,null=True)# This field type is a guess.
  Steps        =models.   TextField(db_column='Steps'        ,blank=True,null=True)# This field type is a guess.
  Origin       =models.   TextField(db_column='Origin'       ,blank=True,null=True)# This field type is a guess.
  Solution     =models.   TextField(db_column='Solution'     ,blank=True,null=True)# This field type is a guess.
  nCategorie   =models.IntegerField(db_column='nCategorie'   ,blank=True,null=True)
  isBug        =models.BooleanField(db_column='isBug'        ,blank=True,null=True)# This field type is a guess.
  nDemander    =models.IntegerField(db_column='nDemander'    ,blank=True,null=True)
  nSheetRef    =models.IntegerField(db_column='nSheetRef'    ,blank=True,null=True)
  def __str__(self): return self.Description
  class Meta:
    managed  = False
    db_table = 'Development'


class JourFerie(models.Model):
#  id  = models.AutoField(                 blank=True, null=True)
  Jour= models.DateField(db_column='Jour',blank=True, null=True)
  class Meta:
    managed = False
    db_table= 'Jour_ferie'


class Project(models.Model):
#  id  = models.AutoField(                                 blank=True, null=True)
  Name= models.CharField(db_column='Name', max_length=42, blank=True, null=True)
  def __str__(self): return self.Name
  class Meta:
    managed = False
    db_table= 'Project'


class Sheet(models.Model):
#  id   = models.AutoField(                   blank=True, null=True)
  Image= models.TextField(db_column='Image', blank=True, null=True)#This field type is a guess.
  class Meta:
    managed = False
    db_table= 'Sheet'


class Sheetref(models.Model):
#  id    = models.AutoField(blank=True, null=True)
  nSheet= models.IntegerField(db_column='nSheet' , blank=True, null=True)
  Left  = models.IntegerField(db_column='_Left'  , blank=True, null=True)
  Top   = models.IntegerField(db_column='_Top'   , blank=True, null=True)
  Width = models.IntegerField(db_column='_Width' , blank=True, null=True)
  Height= models.IntegerField(db_column='_Height', blank=True, null=True)
  class Meta:
    managed = False
    db_table= 'Sheetref'


class State(models.Model):
#  id         =models.AutoField(                                        blank=True, null=True)
  Symbol     =models.CharField(db_column='Symbol'     , max_length= 5, blank=True, null=True)
  Description=models.CharField(db_column='Description', max_length=42, blank=True, null=True)
  def __str__(self): return self.Symbol
  class Meta:
    managed = False
    db_table= 'State'


class TContact(models.Model):
#  id  = models.AutoField(                                 blank=True, null=True)
  Name= models.CharField(db_column='Name', max_length=42, blank=True, null=True)
  def __str__(self): return self.Name
  class Meta:
    managed = False
    db_table= 'TContact'


class Tag(models.Model):
#  id    =models.   AutoField(                                 blank=True,null=True)
  idType=models.IntegerField(db_column='idType',              blank=True,null=True)
  Name  =models.   CharField(db_column='Name'  ,max_length=42,blank=True,null=True)
  def __str__(self): return self.Name
  class Meta:
    managed = False
    db_table= 'Tag'


class TagDevelopment(models.Model):
#  id           =models.   AutoField(blank=True, null=True    )
  idTag        =models.IntegerField(db_column='idTag'        )
  idDevelopment=models.IntegerField(db_column='idDevelopment')
  class Meta:
    managed = False
    db_table= 'Tag_Development'


class TagWork(models.Model):
#  id    =models.   AutoField(                    blank=True, null=True)
  idTag =models.IntegerField(db_column='idTag' , blank=True, null=True)
  idWork=models.IntegerField(db_column='idWork', blank=True, null=True)
  class Meta:
    managed = False
    db_table= 'Tag_Work'


class TypeTag(models.Model):
#  id  = models.AutoField(                                 blank=True, null=True)
  Name= models.CharField(db_column='Name', max_length=42, blank=True, null=True)
  def __str__(self): return self.Name
  class Meta:
    managed = False
    db_table= 'Type_Tag'


class User(models.Model):
#  id      =models.   AutoField(                                   blank=True,null=True)
  name    =models.   CharField(db_column='Name'    ,max_length=42,blank=True,null=True)
  initials=models.   CharField(db_column='Initials',max_length= 5,blank=True,null=True)
  islogged=models.BooleanField(db_column='isLogged',              blank=True,null=True)
  def __str__(self): return self.Name
  class Meta:
    managed = False
    db_table= 'User'


class Work(models.Model):
#  id         = models.    AutoField(                        blank=True,null=True)
  nProject   = models. IntegerField(db_column='nProject'   ,blank=True,null=True)
  Beginning  = models.DateTimeField(db_column='Beginning'  ,blank=True,null=True)
  End        = models.DateTimeField(db_column='End'        ,blank=True,null=True)
  Description= models.    TextField(db_column='Description',blank=True,null=True)
  nUser      = models. IntegerField(db_column='nUser'      ,blank=True,null=True)
  def __str__(self): return self.Description
  class Meta:
    managed = False
    db_table= 'Work'


class g_becp(models.Model):
#  id       = models.AutoField(blank=True, null=True)
  nomclasse= models.CharField(max_length=50)
  libelle  = models.CharField(max_length=80, blank=True, null=True)

  class Meta:
    managed = False
    db_table= 'g_becp'


class g_becpctx(models.Model):
#  id        = models.   AutoField(blank=True, null=True)
  nomclasse = models.   CharField(max_length=50)
  contexte  = models.IntegerField()
  logfont   = models. BinaryField(blank=True, null=True)
  stringlist= models.   TextField(blank=True, null=True)

  class Meta:
    managed = False
    db_table= 'g_becpctx'

class g_ctx(models.Model):
#  id          = models.   AutoField(blank=True, null=True)
  contexte    = models.IntegerField()
  contextetype= models.   CharField(max_length=50, blank=True, null=True)
  libelle     = models.   CharField(max_length=80, blank=True, null=True)
  class Meta:
    managed = False
    db_table= 'g_ctx'


class g_ctxtype(models.Model):
#  id          = models.AutoField(blank=True, null=True)
  contextetype= models.CharField(max_length=50)
  hierarchie  = models.CharField(max_length=50, blank=True, null=True)
  libelle     = models.CharField(max_length=80, blank=True, null=True)

  class Meta:
    managed = False
    db_table= 'g_ctxtype'
