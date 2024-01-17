import { Injectable } from '@angular/core';
import { TsState} from './usState';

@Injectable()
export class TeState
  {
  id: number;
      Symbol: string;
    Description: string;
  // champs calculés (supprimés dans to_ServerValue() )
  SID: string= '';
  modifie: Boolean= false;
  service: TsState= null;

  public static id_parameter( _id: number) { return /*'id=' +*/ _id; }

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
  public to_ServerValue(): TeState
    {
    const Result: TeState= new TeState( this);

    delete Result.SID;
    delete Result.service;
    delete Result.modifie;

    return Result;
    }
  }
