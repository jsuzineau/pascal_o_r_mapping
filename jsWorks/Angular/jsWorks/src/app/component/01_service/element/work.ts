import { Injectable } from '@angular/core';
import { WORKService} from '../work.service';

@Injectable()
export class WORK
  {
  
  // champs calculés (supprimés dans to_ServerValue() )
  SID: string= '';
  modifie: Boolean= false;
  service: WORKService= null;

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
  public to_ServerValue(): WORK
    {
    const Result: WORK= new WORK( this);

    delete Result.SID;
    delete Result.service;
    delete Result.modifie;

    return Result;
    }
  }
