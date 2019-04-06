import {  Component,
          OnInit,
          Input,
                                 } from '@angular/core';
import { Router                  } from '@angular/router';

import { SessionService          } from './01_service/session.service';
import { PROJECTService } from './01_service/project.service';
import { PROJECT        } from './01_service/element/project';

@Component({
  selector: 'app-project',
  templateUrl: './03_html/app-project.component.html',
  styleUrls: ['./03_html/app-project.component.css'],
  providers: [PROJECTService, SessionService],
  })

export class AppPROJECTComponent implements OnInit
  {
  public get session(): PROJECT
    {
    return SessionService.static_session;
    }
  public u: PROJECT|null= null;
  public projects: Array<PROJECT>;
  constructor(private router: Router, private service: PROJECTService, private ses: SessionService)
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
      .then( _projects =>
        {
        this.projects= _projects;
        this.projects.forEach( _u =>
          {
          _u.service= this.service;
          });
        });
    }
  onClick( _u: PROJECT)
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
  LogTo( _u: PROJECT)
    {
    this.ses.Session_from_Login( _u)
      .then(  _u =>
        {
        this.ses.session= _u;
        this.router.navigate(['/repertoire']);
        } );
    }
  projects_Nouveau()
    {
    this.service.Insert( new PROJECT)
      .then( _u =>
        {
        this.projects.push( _u);
        }
        );
    }
  }

