import { Injectable } from '@angular/core';
import { CHANTIER_ADRESSEService} from '../chantier_adresse.service';

@Injectable()
export class CHANTIER_ADRESSE
  {
      chantieradr_id: number;
    chantier_id: number;
    adr_libelle: string;
    adresse1: string;
    adresse2: string;
    adresse3: string;
    codepostal: string;
    ville: string;
  // champs calculés (supprimés dans to_ServerValue() )
  SID: string= '';
  modifie: Boolean= false;
  service: CHANTIER_ADRESSEService= null;

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
  public to_ServerValue(): CHANTIER_ADRESSE
    {
    const Result: CHANTIER_ADRESSE= new CHANTIER_ADRESSE( this);

    delete Result.SID;
    delete Result.service;
    delete Result.modifie;

    return Result;
    }
  }
