import {  Component,
          OnInit,
          Input,
                                 } from '@angular/core';
import { Router                  } from '@angular/router';

import { TResult_List} from '../uResult_List';
import { TsNom_de_la_classe} from './usNom_de_la_classe';
import { TeNom_de_la_classe} from './ueNom_de_la_classe';

@Component({
  selector: 'cNom_de_la_classe',
  templateUrl: './ucNom_de_la_classe.html',
  styleUrls: ['./ucNom_de_la_classe.css'],
  providers: [TsNom_de_la_classe],
  })

export class TcNom_de_la_classe implements OnInit
  {
  @Input() id: number=-1;  
  public e: TeNom_de_la_classe|null= null;
  public Nom_de_la_classes: TResult_List<TeNom_de_la_classe>;
  constructor(private router: Router, private service: TsNom_de_la_classe)
    {
    }
  ngOnInit(): void
    {
    this.service.All()
      .then( _Nom_de_la_classes =>
        {
        this.Nom_de_la_classes= new TResult_List<TeNom_de_la_classe>(_Nom_de_la_classes);
        this.Nom_de_la_classes.Elements.forEach( _e =>
          {
          _e.service= this.service;
          });
        });
    }
  onClick( _e: TeNom_de_la_classe)
    {
    this.e= _e;
    this.e.modifie= true;
    }
  onKeyDown( event): void
    {
    if (13 === event.keyCode)
      {
      if (this.e)
        {
        this.e.Valide();
        }
      }
    }
  Nom_de_la_classes_Nouveau()
    {
    this.service.Insert( new TeNom_de_la_classe)
      .then( _e =>
        {
        this.Nom_de_la_classes.Elements.push( _e);
        }
        );
    }
  }

