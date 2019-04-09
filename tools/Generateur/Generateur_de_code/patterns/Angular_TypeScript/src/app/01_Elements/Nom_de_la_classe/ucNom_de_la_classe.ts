import {  Component,
          OnInit,
          Input,
                                 } from '@angular/core';
import { Router                  } from '@angular/router';

import { Result_List} from './01_service/result_list';
import { Nom_de_la_classeService } from './01_service/NomTableMinuscule.service';
import { Nom_de_la_classe        } from './01_service/element/NomTableMinuscule';

@Component({
  selector: 'app-NomTableMinuscule',
  templateUrl: './03_html/app-NomTableMinuscule.component.html',
  styleUrls: ['./03_html/app-NomTableMinuscule.component.css'],
  providers: [Nom_de_la_classeService],
  })

export class AppNom_de_la_classeComponent implements OnInit
  {
  public e: Nom_de_la_classe|null= null;
  public NomTableMinuscules: Result_List<Nom_de_la_classe>;
  constructor(private router: Router, private service: Nom_de_la_classeService)
    {
    }
  ngOnInit(): void
    {
    this.service.All()
      .then( _NomTableMinuscules =>
        {
        this.NomTableMinuscules= new Result_List<Nom_de_la_classe>(_NomTableMinuscules);
        this.NomTableMinuscules.Elements.forEach( _e =>
          {
          _e.service= this.service;
          });
        });
    }
  onClick( _e: Nom_de_la_classe)
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
  NomTableMinuscules_Nouveau()
    {
    this.service.Insert( new Nom_de_la_classe)
      .then( _e =>
        {
        this.NomTableMinuscules.Elements.push( _e);
        }
        );
    }
  }

