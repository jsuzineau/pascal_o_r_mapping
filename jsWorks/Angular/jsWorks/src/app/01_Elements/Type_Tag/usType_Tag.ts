import { Injectable, OnInit} from '@angular/core';
import { Headers, Http, Response } from '@angular/http';
import { HttpClient, HttpHeaders     } from '@angular/common/http';
import { Observable     } from 'rxjs/Observable';
import 'rxjs/add/operator/toPromise';
import 'rxjs/add/operator/map';
import { environment    } from '../../../environments/environment';

import { TResult_List} from '../uResult_List';
import { TeType_Tag   } from './ueType_Tag';

const API_URL = environment.api_url;

@Injectable()
export class TsType_Tag
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

  public Delete( _e: TeType_Tag): TsType_Tag
    {
    const url= API_URL + '/Type_Tag_Delete' + TeType_Tag.id_parameter( _e.id);
    this.http.get(  url, {headers: this.headers});
    return this;
    }
  public Get( _id: number): Promise<TeType_Tag>
    {
      const url= API_URL + '/Type_Tag_Get' + TeType_Tag.id_parameter( _id);
      return this.http
        .get<TeType_Tag>(  url, {headers: this.headers})
        .map<TeType_Tag,TeType_Tag>( _e =>
          {
          const Result: TeType_Tag= new TeType_Tag( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Insert( _e: TeType_Tag): Promise<TeType_Tag>
    {
      const url= API_URL + '/Type_Tag_Insert';
      return this.http
        .post<TeType_Tag>( url, JSON.stringify( _e), {headers: this.headers})
        .map<TeType_Tag,TeType_Tag>( _e =>
          {
          const Result: TeType_Tag= new TeType_Tag( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Set( _e: TeType_Tag): Promise<TeType_Tag>
    {
      const e: TeType_Tag= _e.to_ServerValue();

      const url= API_URL + '/Type_Tag_Set' + TeType_Tag.id_parameter( e.id);
      return this.http
        .post<TeType_Tag>( url, JSON.stringify( e), {headers: this.headers})
        .map<TeType_Tag,TeType_Tag>( _e =>
          {
          const Result: TeType_Tag= new TeType_Tag( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public All(): Promise<TResult_List<TeType_Tag>>
    {
      const url= API_URL + '/Type_Tag';
      return this.http
        .get<TResult_List<TeType_Tag>>( url, {headers: this.headers})
        .map<TResult_List<TeType_Tag>, TResult_List<TeType_Tag>>( _rl =>
          {
          const Result= new TResult_List<TeType_Tag>();
          for( let _e of _rl.Elements)
            {
            const e: TeType_Tag= new TeType_Tag( _e);
            e.service= this;
            Result.Elements.push( e);
            }
          return Result;
          })
        .toPromise();
    }
    public All_id_Libelle(): Promise<TResult_List<TeType_Tag>>
    {
      const url= API_URL + '/Type_Tag_id_Libelle';
      return this.http
        .get<TResult_List<TeType_Tag>>( url, {headers: this.headers})
        .map<TResult_List<TeType_Tag>, TResult_List<TeType_Tag>>( _rl =>
          {
          const Result= new TResult_List<TeType_Tag>();
          for( let _e of _rl.Elements)
            {
            const e: TeType_Tag= new TeType_Tag( _e);
            e.service= this;
            Result.Elements.push( e);
            }
          return Result;
          })
        .toPromise();
    }
  }
