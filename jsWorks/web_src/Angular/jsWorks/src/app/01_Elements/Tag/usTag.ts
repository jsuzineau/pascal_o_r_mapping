import { Injectable, OnInit} from '@angular/core';
import { Headers, Http, Response } from '@angular/http';
import { HttpClient, HttpHeaders     } from '@angular/common/http';
import { Observable     } from 'rxjs/Observable';
import 'rxjs/add/operator/toPromise';
import 'rxjs/add/operator/map';
import { environment    } from '../../../environments/environment';

import { TResult_List} from '../uResult_List';
import { TeTag   } from './ueTag';

const API_URL = environment.api_url;

@Injectable()
export class TsTag
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

  public Delete( _e: TeTag): TsTag
    {
    const url= API_URL + '/Tag_Delete' + TeTag.id_parameter( _e.id);
    this.http.get(  url, {headers: this.headers});
    return this;
    }
  public Get( _id: number): Promise<TeTag>
    {
      const url= API_URL + '/Tag_Get' + TeTag.id_parameter( _id);
      return this.http
        .get<TeTag>(  url, {headers: this.headers})
        .map<TeTag,TeTag>( _e =>
          {
          const Result: TeTag= new TeTag( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Insert( _e: TeTag): Promise<TeTag>
    {
      const url= API_URL + '/Tag_Insert';
      return this.http
        .post<TeTag>( url, JSON.stringify( _e), {headers: this.headers})
        .map<TeTag,TeTag>( _e =>
          {
          const Result: TeTag= new TeTag( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Set( _e: TeTag): Promise<TeTag>
    {
      const e: TeTag= _e.to_ServerValue();

      const url= API_URL + '/Tag_Set' + TeTag.id_parameter( e.id);
      return this.http
        .post<TeTag>( url, JSON.stringify( e), {headers: this.headers})
        .map<TeTag,TeTag>( _e =>
          {
          const Result: TeTag= new TeTag( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public All(): Promise<TResult_List<TeTag>>
    {
      const url= API_URL + '/Tag';
      return this.http
        .get<TResult_List<TeTag>>( url, {headers: this.headers})
        .map<TResult_List<TeTag>, TResult_List<TeTag>>( _rl =>
          {
          const Result= new TResult_List<TeTag>();
          for( let _e of _rl.Elements)
            {
            const e: TeTag= new TeTag( _e);
            e.service= this;
            Result.Elements.push( e);
            }
          return Result;
          })
        .toPromise();
    }
    public All_id_Libelle(): Promise<TResult_List<TeTag>>
    {
      const url= API_URL + '/Tag_id_Libelle';
      return this.http
        .get<TResult_List<TeTag>>( url, {headers: this.headers})
        .map<TResult_List<TeTag>, TResult_List<TeTag>>( _rl =>
          {
          const Result= new TResult_List<TeTag>();
          for( let _e of _rl.Elements)
            {
            const e: TeTag= new TeTag( _e);
            e.service= this;
            Result.Elements.push( e);
            }
          return Result;
          })
        .toPromise();
    }
  }
