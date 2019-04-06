import { Injectable } from '@angular/core';
import { PROJECTService} from '../project.service';

@Injectable()
export class PROJECT
  {
  
  // champs calculés (supprimés dans to_ServerValue() )
  SID: string= '';
  modifie: Boolean= false;
  service: PROJECTService= null;

  public static id_parameter( _id: number) { return '&id=' + _id; }

  constructor(values: Object = {})
    {
    Object.assign(this, values);
    }
  public Valide(): void
    {
    if (!this.service) { return; }
    this.service.Set( this)
    .then( _u => { Object.assign(this, _u); });
    }
  public to_ServerValue(): PROJECT
    {
    const Result: PROJECT= new PROJECT( this);

    delete Result.SID;
    delete Result.service;
    delete Result.modifie;

    return Result;
    }
  }
