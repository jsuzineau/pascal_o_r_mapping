import {  Component,
          OnInit,
          Input,
                                 } from '@angular/core';
import { Router                  } from '@angular/router';

import { SessionService          } from './01_service/session.service';
import { ProjectService } from './01_service/project.service';
import { Project        } from './01_service/element/project';

@Component({
  selector: 'app-project',
  templateUrl: './03_html/app-project.component.html',
  styleUrls: ['./03_html/app-project.component.css'],
  providers: [ProjectService, SessionService],
  })

export class AppProjectComponent implements OnInit
  {
  public get session(): Project
    {
    return SessionService.static_session;
    }
  public u: Project|null= null;
  public projects: Array<Project>;
  constructor(private router: Router, private service: ProjectService, private ses: SessionService)
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
  onClick( _u: Project)
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
  LogTo( _u: Project)
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
    this.service.Insert( new Project)
      .then( _u =>
        {
        this.projects.push( _u);
        }
        );
    }
  }

