import { Injectable } from '@angular/core';
import { TsWork} from './usWork';

@Injectable()
export class TeWork
  {
  id: number;
      nProject: number;
    Beginning: string;
    End: string;
    Description: string;
    nUser: number;
  // champs calculés (supprimés dans to_ServerValue() )
  SID: string= '';
  modifie: Boolean= false;
  service: TsWork= null;

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
  public to_ServerValue(): TeWork
    {
    const Result: TeWork= new TeWork( this);

    delete Result.SID;
    delete Result.service;
    delete Result.modifie;

    return Result;
    }
  }
