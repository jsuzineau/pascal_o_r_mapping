import { Injectable, OnInit} from '@angular/core';
import { Headers, Http, Response } from '@angular/http';
import { HttpClient, HttpHeaders     } from '@angular/common/http';
import { Observable     } from 'rxjs/Observable';
import 'rxjs/add/operator/toPromise';
import 'rxjs/add/operator/map';
import { environment    } from '../../../environments/environment';

import { TResult_List} from '../uResult_List';
import { TeWork   } from './ueWork';

const API_URL = environment.api_url;

@Injectable()
export class TsWork
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

  public Delete( _e: TeWork): TsWork
    {
    const url= API_URL + '/Work_Delete' + TeWork.id_parameter( _e.id);
    this.http.get(  url, {headers: this.headers});
    return this;
    }
  public Get( _id: number): Promise<TeWork>
    {
      const url= API_URL + '/Work_Get' + TeWork.id_parameter( _id);
      return this.http
        .get<TeWork>(  url, {headers: this.headers})
        .map<TeWork,TeWork>( _e =>
          {
          const Result: TeWork= new TeWork( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Insert( _e: TeWork): Promise<TeWork>
    {
      const url= API_URL + '/Work_Insert';
      return this.http
        .post<TeWork>( url, JSON.stringify( _e), {headers: this.headers})
        .map<TeWork,TeWork>( _e =>
          {
          const Result: TeWork= new TeWork( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Set( _e: TeWork): Promise<TeWork>
    {
      const e: TeWork= _e.to_ServerValue();

      const url= API_URL + '/Work_Set' + TeWork.id_parameter( e.id);
      return this.http
        .post<TeWork>( url, JSON.stringify( e), {headers: this.headers})
        .map<TeWork,TeWork>( _e =>
          {
          const Result: TeWork= new TeWork( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public All(): Promise<TResult_List<TeWork>>
    {
      const url= API_URL + '/Work';
      return this.http
        .get<TResult_List<TeWork>>( url, {headers: this.headers})
        .map<TResult_List<TeWork>, TResult_List<TeWork>>( _rl =>
          {
          const Result= new TResult_List<TeWork>();
          for( let _e of _rl.Elements)
            {
            const e: TeWork= new TeWork( _e);
            e.service= this;
            Result.Elements.push( e);
            }
          return Result;
          })
        .toPromise();
    }
    public All_id_Libelle(): Promise<TResult_List<TeWork>>
    {
      const url= API_URL + '/Work_id_Libelle';
      return this.http
        .get<TResult_List<TeWork>>( url, {headers: this.headers})
        .map<TResult_List<TeWork>, TResult_List<TeWork>>( _rl =>
          {
          const Result= new TResult_List<TeWork>();
          for( let _e of _rl.Elements)
            {
            const e: TeWork= new TeWork( _e);
            e.service= this;
            Result.Elements.push( e);
            }
          return Result;
          })
        .toPromise();
    }
  }
