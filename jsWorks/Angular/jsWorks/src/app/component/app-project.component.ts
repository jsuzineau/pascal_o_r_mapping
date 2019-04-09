import {  Component,
          OnInit,
          Input,
                                 } from '@angular/core';
import { Router                  } from '@angular/router';

import { ProjectService } from './01_service/project.service';
import { Project        } from './01_service/element/project';

@Component({
  selector: 'app-project',
  templateUrl: './03_html/app-project.component.html',
  styleUrls: ['./03_html/app-project.component.css'],
  providers: [ProjectService],
  })

export class AppProjectComponent implements OnInit
  {
  public u: Project|null= null;
  public projects: Array<Project>;
  constructor(private router: Router, private service: ProjectService)
    {
    }
  ngOnInit(): void
    {
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

