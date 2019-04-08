import { Component, Input, OnInit  } from '@angular/core';
import { Router                    } from '@angular/router';
import { HttpClient, HttpHeaders   } from '@angular/common/http';
import { Observable                } from 'rxjs/Observable';

import { SessionService            } from './01_service/session.service';
import { Utilisateur               } from './01_service/element/utilisateur';

import { environment    } from '../../environments/environment';

@Component({
  selector: 'app-session',
  templateUrl: './03_html/app-session.component.html',
  styleUrls: ['./03_html/app-session.component.css'],
  providers: [SessionService]
})
export class AppSessionComponent implements OnInit
  {
  title = 'app';
  @Input() login: Utilisateur= new Utilisateur( {nom: environment.login_nom, mot_de_passe: environment.mot_de_passe});
  public get session(): Utilisateur
    {
    return SessionService.static_session;
    }
  constructor ( private router: Router,
                private http: HttpClient,
                private sus: SessionService)
    {
    }
  private Reset_Login()
    {
    this.login.id= 0;
    this.login.nom= '';
    this.login.mot_de_passe= '';
    }
  public Do_Login()
    {
    this.sus
      .Session_from_Login( this.login)
      .then(  _u =>
        {
        this.sus.session= _u;
        this.router.navigate( [ this.session.is_admin ? '/utilisateur' : '/repertoire' ] );
        } );
    }
  public Deconnecter()
    {
    this.sus.session= null;
    // this.Reset_Login();
    // this.Do_Login();
    }
  public gotoRepertoire(): void
    {
    this.router.navigate(['/repertoire']);
    }
  public Session(): void
      {
      this.sus
        .Session()
        .then(  _u => { this.sus.session= _u; } );
      }
  ngOnInit(): void
    {
    this.Session();
    }
  }
