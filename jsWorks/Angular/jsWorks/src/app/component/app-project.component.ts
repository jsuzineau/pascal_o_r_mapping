import {  Component,
          OnInit,
          Input,
                                 } from '@angular/core';
import { Router                  } from '@angular/router';

import { Result_List} from './01_service/result_list';
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
  public e: Project|null= null;
  public projects: Result_List<Project>;
  constructor(private router: Router, private service: ProjectService)
    {
    }
  ngOnInit(): void
    {
    this.service.All()
      .then( _projects =>
        {
        this.projects= new Result_List<Project>(_projects);
        this.projects.Elements.forEach( _e =>
          {
          _e.service= this.service;
          });
        });
    }
  onClick( _e: Project)
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
  projects_Nouveau()
    {
    this.service.Insert( new Project)
      .then( _e =>
        {
        this.projects.Elements.push( _e);
        }
        );
    }
  }

