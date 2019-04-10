import { Injectable } from '@angular/core';
import { TsProject} from './usProject';

@Injectable()
export class TeProject
  {
  id: number;
      Name: string;
  // champs calculés (supprimés dans to_ServerValue() )
  SID: string= '';
  modifie: Boolean= false;
  service: TsProject= null;

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
  public to_ServerValue(): TeProject
    {
    const Result: TeProject= new TeProject( this);

    delete Result.SID;
    delete Result.service;
    delete Result.modifie;

    return Result;
    }
  }
