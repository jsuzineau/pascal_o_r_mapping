import { Injectable, OnInit} from '@angular/core';
import { Headers, Http, Response } from '@angular/http';
import { HttpClient, HttpHeaders     } from '@angular/common/http';
import { Observable     } from 'rxjs/Observable';
import 'rxjs/add/operator/toPromise';
import 'rxjs/add/operator/map';
import { environment    } from '../../../environments/environment';

import { TResult_List} from '../uResult_List';
import { TeDevelopment   } from './ueDevelopment';

const API_URL = environment.api_url;

@Injectable()
export class TsDevelopment
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

  public Delete( _e: TeDevelopment): TsDevelopment
    {
    const url= API_URL + '/Development_Delete' + TeDevelopment.id_parameter( _e.id);
    this.http.get(  url, {headers: this.headers});
    return this;
    }
  public Get( _id: number): Promise<TeDevelopment>
    {
      const url= API_URL + '/Development_Get' + TeDevelopment.id_parameter( _id);
      return this.http
        .get<TeDevelopment>(  url, {headers: this.headers})
        .map<TeDevelopment,TeDevelopment>( _e =>
          {
          const Result: TeDevelopment= new TeDevelopment( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Insert( _e: TeDevelopment): Promise<TeDevelopment>
    {
      const url= API_URL + '/Development_Insert';
      return this.http
        .post<TeDevelopment>( url, JSON.stringify( _e), {headers: this.headers})
        .map<TeDevelopment,TeDevelopment>( _e =>
          {
          const Result: TeDevelopment= new TeDevelopment( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Set( _e: TeDevelopment): Promise<TeDevelopment>
    {
      const e: TeDevelopment= _e.to_ServerValue();

      const url= API_URL + '/Development_Set' + TeDevelopment.id_parameter( e.id);
      return this.http
        .post<TeDevelopment>( url, JSON.stringify( e), {headers: this.headers})
        .map<TeDevelopment,TeDevelopment>( _e =>
          {
          const Result: TeDevelopment= new TeDevelopment( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public All(): Promise<TResult_List<TeDevelopment>>
    {
      const url= API_URL + '/Development';
      return this.http
        .get<TResult_List<TeDevelopment>>( url, {headers: this.headers})
        .map<TResult_List<TeDevelopment>, TResult_List<TeDevelopment>>( _rl =>
          {
          const Result= new TResult_List<TeDevelopment>();
          for( let _e of _rl.Elements)
            {
            const e: TeDevelopment= new TeDevelopment( _e);
            e.service= this;
            Result.Elements.push( e);
            }
          return Result;
          })
        .toPromise();
    }
    public All_id_Libelle(): Promise<TResult_List<TeDevelopment>>
    {
      const url= API_URL + '/Development_id_Libelle';
      return this.http
        .get<TResult_List<TeDevelopment>>( url, {headers: this.headers})
        .map<TResult_List<TeDevelopment>, TResult_List<TeDevelopment>>( _rl =>
          {
          const Result= new TResult_List<TeDevelopment>();
          for( let _e of _rl.Elements)
            {
            const e: TeDevelopment= new TeDevelopment( _e);
            e.service= this;
            Result.Elements.push( e);
            }
          return Result;
          })
        .toPromise();
    }
  }
