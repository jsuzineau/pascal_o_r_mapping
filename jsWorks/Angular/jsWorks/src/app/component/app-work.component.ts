import {  Component,
          OnInit,
          Input,
                                 } from '@angular/core';
import { Router                  } from '@angular/router';

import { SessionService          } from './01_service/session.service';
import { WORKService } from './01_service/work.service';
import { WORK        } from './01_service/element/work';

@Component({
  selector: 'app-work',
  templateUrl: './03_html/app-work.component.html',
  styleUrls: ['./03_html/app-work.component.css'],
  providers: [WORKService, SessionService],
  })

export class AppWORKComponent implements OnInit
  {
  public get session(): WORK
    {
    return SessionService.static_session;
    }
  public u: WORK|null= null;
  public works: Array<WORK>;
  constructor(private router: Router, private service: WORKService, private ses: SessionService)
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
  onClick( _u: WORK)
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
  LogTo( _u: WORK)
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
    this.service.Insert( new WORK)
      .then( _u =>
        {
        this.works.push( _u);
        }
        );
    }
  }

