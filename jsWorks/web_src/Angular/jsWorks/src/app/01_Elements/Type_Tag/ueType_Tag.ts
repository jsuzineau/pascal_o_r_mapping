import { Injectable } from '@angular/core';
import { TsType_Tag} from './usType_Tag';

@Injectable()
export class TeType_Tag
  {
  id: number;
      Name: string;
  // champs calculés (supprimés dans to_ServerValue() )
  SID: string= '';
  modifie: Boolean= false;
  service: TsType_Tag= null;

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
  public to_ServerValue(): TeType_Tag
    {
    const Result: TeType_Tag= new TeType_Tag( this);

    delete Result.SID;
    delete Result.service;
    delete Result.modifie;

    return Result;
    }
  }
