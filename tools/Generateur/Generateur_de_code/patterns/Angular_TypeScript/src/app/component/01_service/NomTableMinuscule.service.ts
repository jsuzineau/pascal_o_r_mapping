import { Injectable, OnInit} from '@angular/core';
import { Headers, Http, Response } from '@angular/http';
import { HttpClient, HttpHeaders     } from '@angular/common/http';
import { Observable     } from 'rxjs/Observable';
import 'rxjs/add/operator/toPromise';
import 'rxjs/add/operator/map';
import { environment    } from '../../../environments/environment';

import { Result_List} from './result_list';
import { Nom_de_la_classe   } from './element/NomTableMinuscule';

const API_URL = environment.api_url;

@Injectable()
export class Nom_de_la_classeService
  {
  // private headers = new HttpHeaders({'Content-Type': 'application/json'});
  private headers = new HttpHeaders({'Content-Type' : 'application/x-www-form-urlencoded; charset=UTF-8'});

  constructor( private http: HttpClient)
    {
    }
  private handleError( error: any | any)
    {
    console.error( this.constructor.name + '::handleError', error);
    return Observable.throw(error);
    }

  public Delete( _e: Nom_de_la_classe): Nom_de_la_classeService
    {
    const url= API_URL + '/Nom_de_la_classe_Delete' + Nom_de_la_classe.id_parameter( _e.id);
    this.http.get(  url, {headers: this.headers});
    return this;
    }
  public Get( _id: number): Promise<Nom_de_la_classe>
    {
      const url= API_URL + '/Nom_de_la_classe_Get' + Nom_de_la_classe.id_parameter( _id);
      return this.http
        .get<Nom_de_la_classe>(  url, {headers: this.headers})
        .map<Nom_de_la_classe,Nom_de_la_classe>( _e =>
          {
          const Result: Nom_de_la_classe= new Nom_de_la_classe( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Insert( _e: Nom_de_la_classe): Promise<Nom_de_la_classe>
    {
      const url= API_URL + '/Nom_de_la_classe_Insert';
      return this.http
        .post<Nom_de_la_classe>( url, JSON.stringify( _e), {headers: this.headers})
        .map<Nom_de_la_classe,Nom_de_la_classe>( _e =>
          {
          const Result: Nom_de_la_classe= new Nom_de_la_classe( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Set( _e: Nom_de_la_classe): Promise<Nom_de_la_classe>
    {
      const e: Nom_de_la_classe= _e.to_ServerValue();

      const url= API_URL + '/Nom_de_la_classe_Set' + Nom_de_la_classe.id_parameter( e.id);
      return this.http
        .post<Nom_de_la_classe>( url, JSON.stringify( e), {headers: this.headers})
        .map<Nom_de_la_classe,Nom_de_la_classe>( _e =>
          {
          const Result: Nom_de_la_classe= new Nom_de_la_classe( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public All(): Promise<Result_List<Nom_de_la_classe>>
    {
      const url= API_URL + '/Nom_de_la_classe';
      return this.http
        .get<Result_List<Nom_de_la_classe>>( url, {headers: this.headers})
        .map<Result_List<Nom_de_la_classe>, Result_List<Nom_de_la_classe>>( _rl =>
          {
          const Result= new Result_List<Nom_de_la_classe>();
          for( let _e of _rl.Elements)
            {
            const e: Nom_de_la_classe= new Nom_de_la_classe( _e);
            e.service= this;
            Result.Elements.push( e);
            }
          return Result;
          })
        .toPromise();
    }
  }
