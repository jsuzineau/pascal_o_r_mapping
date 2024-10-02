import { Injectable, OnInit} from '@angular/core';
import { Headers, Http, Response } from '@angular/http';
import { HttpClient, HttpHeaders     } from '@angular/common/http';
import { Observable     } from 'rxjs/Observable';
import 'rxjs/add/operator/toPromise';
import 'rxjs/add/operator/map';
import { environment    } from '../../../environments/environment';

import { TResult_List} from '../uResult_List';
import { TeState   } from './ueState';

const API_URL = environment.api_url;

@Injectable()
export class TsState
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

  public Delete( _e: TeState): TsState
    {
    const url= API_URL + '/State_Delete' + TeState.id_parameter( _e.id);
    this.http.get(  url, {headers: this.headers});
    return this;
    }
  public Get( _id: number): Promise<TeState>
    {
      const url= API_URL + '/State_Get' + TeState.id_parameter( _id);
      return this.http
        .get<TeState>(  url, {headers: this.headers})
        .map<TeState,TeState>( _e =>
          {
          const Result: TeState= new TeState( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Insert( _e: TeState): Promise<TeState>
    {
      const url= API_URL + '/State_Insert';
      return this.http
        .post<TeState>( url, JSON.stringify( _e), {headers: this.headers})
        .map<TeState,TeState>( _e =>
          {
          const Result: TeState= new TeState( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Set( _e: TeState): Promise<TeState>
    {
      const e: TeState= _e.to_ServerValue();

      const url= API_URL + '/State_Set' + TeState.id_parameter( e.id);
      return this.http
        .post<TeState>( url, JSON.stringify( e), {headers: this.headers})
        .map<TeState,TeState>( _e =>
          {
          const Result: TeState= new TeState( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public All(): Promise<TResult_List<TeState>>
    {
      const url= API_URL + '/State';
      return this.http
        .get<TResult_List<TeState>>( url, {headers: this.headers})
        .map<TResult_List<TeState>, TResult_List<TeState>>( _rl =>
          {
          const Result= new TResult_List<TeState>();
          for( let _e of _rl.Elements)
            {
            const e: TeState= new TeState( _e);
            e.service= this;
            Result.Elements.push( e);
            }
          return Result;
          })
        .toPromise();
    }
    public All_id_Libelle(): Promise<TResult_List<TeState>>
    {
      const url= API_URL + '/State_id_Libelle';
      return this.http
        .get<TResult_List<TeState>>( url, {headers: this.headers})
        .map<TResult_List<TeState>, TResult_List<TeState>>( _rl =>
          {
          const Result= new TResult_List<TeState>();
          for( let _e of _rl.Elements)
            {
            const e: TeState= new TeState( _e);
            e.service= this;
            Result.Elements.push( e);
            }
          return Result;
          })
        .toPromise();
    }
  }
