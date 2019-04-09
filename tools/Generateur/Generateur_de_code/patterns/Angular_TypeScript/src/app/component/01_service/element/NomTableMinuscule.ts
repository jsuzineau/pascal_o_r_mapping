import { Injectable } from '@angular/core';
import { Nom_de_la_classeService} from '../NomTableMinuscule.service';

@Injectable()
export class Nom_de_la_classe
  {
  id: number;
  //Angular_TypeScript_declaration_champs
  // champs calculés (supprimés dans to_ServerValue() )
  SID: string= '';
  modifie: Boolean= false;
  service: Nom_de_la_classeService= null;

  public static id_parameter( _id: number) { return 'id=' + _id; }

  constructor(values: Object = {})
    {
    Object.assign(this, values);
    }
  public Valide(): void
    {
    if (!this.service) { return; }
    this.service.Set( this)
    .then( _e => { Object.assign(this, _e); });
    }
  public to_ServerValue(): Nom_de_la_classe
    {
    const Result: Nom_de_la_classe= new Nom_de_la_classe( this);

    delete Result.SID;
    delete Result.service;
    delete Result.modifie;

    return Result;
    }
  }
