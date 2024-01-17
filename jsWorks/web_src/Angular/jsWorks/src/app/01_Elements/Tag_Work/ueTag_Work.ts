import { Injectable } from '@angular/core';
import { TsTag_Work} from './usTag_Work';

@Injectable()
export class TeTag_Work
  {
  id: number;
      idTag: number;
    idWork: number;
  // champs calculés (supprimés dans to_ServerValue() )
  SID: string= '';
  modifie: Boolean= false;
  service: TsTag_Work= null;

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
  public to_ServerValue(): TeTag_Work
    {
    const Result: TeTag_Work= new TeTag_Work( this);

    delete Result.SID;
    delete Result.service;
    delete Result.modifie;

    return Result;
    }
  }
