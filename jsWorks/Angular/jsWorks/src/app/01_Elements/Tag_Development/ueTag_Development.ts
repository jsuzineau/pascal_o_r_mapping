import { Injectable } from '@angular/core';
import { TsTag_Development} from './usTag_Development';

@Injectable()
export class TeTag_Development
  {
  id: number;
      idTag: number;
    idDevelopment: number;
  // champs calculés (supprimés dans to_ServerValue() )
  SID: string= '';
  modifie: Boolean= false;
  service: TsTag_Development= null;

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
  public to_ServerValue(): TeTag_Development
    {
    const Result: TeTag_Development= new TeTag_Development( this);

    delete Result.SID;
    delete Result.service;
    delete Result.modifie;

    return Result;
    }
  }
