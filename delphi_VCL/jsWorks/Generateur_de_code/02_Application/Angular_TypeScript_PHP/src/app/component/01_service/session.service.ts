import { Injectable, OnInit} from '@angular/core';
import { Headers, Http, Response } from '@angular/http';
import { HttpClient, HttpHeaders     } from '@angular/common/http';
import { HttpResponse } from '@angular/common/http';
import { Observable     } from 'rxjs/Observable';
import 'rxjs/add/operator/toPromise';
import 'rxjs/add/operator/map';
import { environment    } from '../../../environments/environment';
import { Utilisateur    } from './element/utilisateur';

@Injectable()
export class SessionService implements OnInit
  {
  public static static_session: Utilisateur|null;
  public static get SID(): string {return '?SID='+(SessionService.static_session ? SessionService.static_session.SID : ''); }
  public static get niveau():number {return SessionService.static_session ? SessionService.static_session.niveau : 0; }

  public get session(): Utilisateur|null {return SessionService.static_session; }
  public set session( _session: Utilisateur|null) { SessionService.static_session= _session; }

  // private headers = new HttpHeaders({'Content-Type': 'application/json'});
  private headers = new HttpHeaders({ 'Content-Type' : 'application/x-www-form-urlencoded; charset=UTF-8'});

  constructor( private http: HttpClient)
    {
    }
  private handleError( error: any | any)
    {
    console.error( this.constructor.name + '::handleError', error);
    return Observable.throw(error);
    }
  public Session_url(): string
    {
    return environment.api_url + '/Session_get.php' + SessionService.SID;
    }
  public Session(): Promise<Utilisateur>
      {
      const url=  this.Session_url();
      return this.http
        .get<Utilisateur>( url)
        /*
        .map<Utilisateur,Utilisateur>( _u =>
          {
          const Result: Utilisateur= new Utilisateur( _u);
          return Result;
          })
        */
        .toPromise();
      }
  public Session_from_Login_url(): string
    {
    return environment.api_url + '/Session_set.php';
    }
  public Session_from_Login( _u: Utilisateur): Promise<Utilisateur>
    {
      const url= this.Session_from_Login_url();
      return this.http
        .post<Utilisateur>(  url, JSON.stringify(_u), {headers: this.headers})
        .map<Utilisateur, Utilisateur>( _u =>
          {
          const Result: Utilisateur= new Utilisateur( _u);
          return Result;
          })

        .toPromise();
    }
  ngOnInit(): void
    {
    this.Session();
    }
  }
