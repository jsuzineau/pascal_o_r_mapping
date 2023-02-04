import {  Component,
          OnInit,
          Input,
                                 } from '@angular/core';
import { Router                  } from '@angular/router';

import { SessionService          } from './01_service/session.service';
import { Nom_de_la_classeService } from './01_service/NomTableMinuscule.service';
import { Nom_de_la_classe        } from './01_service/element/NomTableMinuscule';

@Component({
  selector: 'app-NomTableMinuscule',
  templateUrl: './03_html/app-NomTableMinuscule.component.html',
  styleUrls: ['./03_html/app-NomTableMinuscule.component.css'],
  providers: [Nom_de_la_classeService, SessionService],
  })

export class AppNom_de_la_classeComponent implements OnInit
  {
  public get session(): Nom_de_la_classe
    {
    return SessionService.static_session;
    }
  public u: Nom_de_la_classe|null= null;
  public NomTableMinuscules: Array<Nom_de_la_classe>;
  constructor(private router: Router, private service: Nom_de_la_classeService, private ses: SessionService)
    {
    }
  not_Session(): Boolean
    {
    if (this.session) { return false; }
    this.router.navigate(['/session']);
    return true;
    }
  ngOnInit(): void
    {
    if (this.not_Session()) {return ; }

    this.service.All()
      .then( _NomTableMinuscules =>
        {
        this.NomTableMinuscules= _NomTableMinuscules;
        this.NomTableMinuscules.forEach( _u =>
          {
          _u.service= this.service;
          });
        });
    }
  onClick( _u: Nom_de_la_classe)
    {
    this.u= _u;
    this.u.modifie= true;
    }
  onKeyDown( event): void
    {
    if (13 === event.keyCode)
      {
      if (this.u)
        {
        this.u.Valide();
        }
      }
    }
  LogTo( _u: Nom_de_la_classe)
    {
    this.ses.Session_from_Login( _u)
      .then(  _u =>
        {
        this.ses.session= _u;
        this.router.navigate(['/repertoire']);
        } );
    }
  NomTableMinuscules_Nouveau()
    {
    this.service.Insert( new Nom_de_la_classe)
      .then( _u =>
        {
        this.NomTableMinuscules.push( _u);
        }
        );
    }
  }

