import { Injectable } from '@angular/core';

@Injectable()
export class Result_List<T>
  {
    Nom       : string='';
    JSON_Debut: number=-1;
    JSON_Fin  : number=-1;
    Count     : number=0;
    Elements  : Array<T>=[];    
  constructor(values: Object = {})
    {
    Object.assign(this, values);
    }
  }
