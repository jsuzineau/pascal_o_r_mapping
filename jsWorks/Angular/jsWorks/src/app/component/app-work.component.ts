import {  Component,
          OnInit,
          Input,
                                 } from '@angular/core';
import { Router                  } from '@angular/router';

import { SessionService          } from './01_service/session.service';
import { WorkService } from './01_service/work.service';
import { Work        } from './01_service/element/work';

@Component({
  selector: 'app-work',
  templateUrl: './03_html/app-work.component.html',
  styleUrls: ['./03_html/app-work.component.css'],
  providers: [WorkService, SessionService],
  })

export class AppWorkComponent implements OnInit
  {
  public get session(): Work
    {
    return SessionService.static_session;
    }
  public u: Work|null= null;
  public works: Array<Work>;
  constructor(private router: Router, private service: WorkService, private ses: SessionService)
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
      .then( _works =>
        {
        this.works= _works;
        this.works.forEach( _u =>
          {
          _u.service= this.service;
          });
        });
    }
  onClick( _u: Work)
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
  LogTo( _u: Work)
    {
    this.ses.Session_from_Login( _u)
      .then(  _u =>
        {
        this.ses.session= _u;
        this.router.navigate(['/repertoire']);
        } );
    }
  works_Nouveau()
    {
    this.service.Insert( new Work)
      .then( _u =>
        {
        this.works.push( _u);
        }
        );
    }
  }

