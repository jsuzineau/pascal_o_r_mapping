import { Injectable } from '@angular/core';
import { WorkService} from '../work.service';

@Injectable()
export class Work
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
  service: WorkService= null;

  public static id_parameter( _id: number) { return 'id=' + _id; }

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
  public to_ServerValue(): Work
    {
    const Result: Work= new Work( this);

    delete Result.SID;
    delete Result.service;
    delete Result.modifie;

    return Result;
    }
  }
