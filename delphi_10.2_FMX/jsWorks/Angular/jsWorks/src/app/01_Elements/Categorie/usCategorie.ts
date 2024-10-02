import { Injectable, OnInit} from '@angular/core';
import { Headers, Http, Response } from '@angular/http';
import { HttpClient, HttpHeaders     } from '@angular/common/http';
import { Observable     } from 'rxjs/Observable';
import 'rxjs/add/operator/toPromise';
import 'rxjs/add/operator/map';
import { environment    } from '../../../environments/environment';

import { TResult_List} from '../uResult_List';
import { TeCategorie   } from './ueCategorie';

const API_URL = environment.api_url;

@Injectable()
export class TsCategorie
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

  public Delete( _e: TeCategorie): TsCategorie
    {
    const url= API_URL + '/Categorie_Delete' + TeCategorie.id_parameter( _e.id);
    this.http.get(  url, {headers: this.headers});
    return this;
    }
  public Get( _id: number): Promise<TeCategorie>
    {
      const url= API_URL + '/Categorie_Get' + TeCategorie.id_parameter( _id);
      return this.http
        .get<TeCategorie>(  url, {headers: this.headers})
        .map<TeCategorie,TeCategorie>( _e =>
          {
          const Result: TeCategorie= new TeCategorie( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Insert( _e: TeCategorie): Promise<TeCategorie>
    {
      const url= API_URL + '/Categorie_Insert';
      return this.http
        .post<TeCategorie>( url, JSON.stringify( _e), {headers: this.headers})
        .map<TeCategorie,TeCategorie>( _e =>
          {
          const Result: TeCategorie= new TeCategorie( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Set( _e: TeCategorie): Promise<TeCategorie>
    {
      const e: TeCategorie= _e.to_ServerValue();

      const url= API_URL + '/Categorie_Set' + TeCategorie.id_parameter( e.id);
      return this.http
        .post<TeCategorie>( url, JSON.stringify( e), {headers: this.headers})
        .map<TeCategorie,TeCategorie>( _e =>
          {
          const Result: TeCategorie= new TeCategorie( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public All(): Promise<TResult_List<TeCategorie>>
    {
      const url= API_URL + '/Categorie';
      return this.http
        .get<TResult_List<TeCategorie>>( url, {headers: this.headers})
        .map<TResult_List<TeCategorie>, TResult_List<TeCategorie>>( _rl =>
          {
          const Result= new TResult_List<TeCategorie>();
          for( let _e of _rl.Elements)
            {
            const e: TeCategorie= new TeCategorie( _e);
            e.service= this;
            Result.Elements.push( e);
            }
          return Result;
          })
        .toPromise();
    }
    public All_id_Libelle(): Promise<TResult_List<TeCategorie>>
    {
      const url= API_URL + '/Categorie_id_Libelle';
      return this.http
        .get<TResult_List<TeCategorie>>( url, {headers: this.headers})
        .map<TResult_List<TeCategorie>, TResult_List<TeCategorie>>( _rl =>
          {
          const Result= new TResult_List<TeCategorie>();
          for( let _e of _rl.Elements)
            {
            const e: TeCategorie= new TeCategorie( _e);
            e.service= this;
            Result.Elements.push( e);
            }
          return Result;
          })
        .toPromise();
    }
  }
