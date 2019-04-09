import { Injectable } from '@angular/core';
import { ProjectService} from '../project.service';

@Injectable()
export class Project
  {
  id: number;
      Name: string;
  // champs calculés (supprimés dans to_ServerValue() )
  SID: string= '';
  modifie: Boolean= false;
  service: ProjectService= null;

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
  public to_ServerValue(): Project
    {
    const Result: Project= new Project( this);

    delete Result.SID;
    delete Result.service;
    delete Result.modifie;

    return Result;
    }
  }
