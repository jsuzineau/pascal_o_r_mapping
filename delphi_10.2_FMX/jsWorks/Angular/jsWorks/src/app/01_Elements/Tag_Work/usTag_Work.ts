import { Injectable, OnInit} from '@angular/core';
import { Headers, Http, Response } from '@angular/http';
import { HttpClient, HttpHeaders     } from '@angular/common/http';
import { Observable     } from 'rxjs/Observable';
import 'rxjs/add/operator/toPromise';
import 'rxjs/add/operator/map';
import { environment    } from '../../../environments/environment';

import { TResult_List} from '../uResult_List';
import { TeTag_Work   } from './ueTag_Work';

const API_URL = environment.api_url;

@Injectable()
export class TsTag_Work
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

  public Delete( _e: TeTag_Work): TsTag_Work
    {
    const url= API_URL + '/Tag_Work_Delete' + TeTag_Work.id_parameter( _e.id);
    this.http.get(  url, {headers: this.headers});
    return this;
    }
  public Get( _id: number): Promise<TeTag_Work>
    {
      const url= API_URL + '/Tag_Work_Get' + TeTag_Work.id_parameter( _id);
      return this.http
        .get<TeTag_Work>(  url, {headers: this.headers})
        .map<TeTag_Work,TeTag_Work>( _e =>
          {
          const Result: TeTag_Work= new TeTag_Work( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Insert( _e: TeTag_Work): Promise<TeTag_Work>
    {
      const url= API_URL + '/Tag_Work_Insert';
      return this.http
        .post<TeTag_Work>( url, JSON.stringify( _e), {headers: this.headers})
        .map<TeTag_Work,TeTag_Work>( _e =>
          {
          const Result: TeTag_Work= new TeTag_Work( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Set( _e: TeTag_Work): Promise<TeTag_Work>
    {
      const e: TeTag_Work= _e.to_ServerValue();

      const url= API_URL + '/Tag_Work_Set' + TeTag_Work.id_parameter( e.id);
      return this.http
        .post<TeTag_Work>( url, JSON.stringify( e), {headers: this.headers})
        .map<TeTag_Work,TeTag_Work>( _e =>
          {
          const Result: TeTag_Work= new TeTag_Work( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public All(): Promise<TResult_List<TeTag_Work>>
    {
      const url= API_URL + '/Tag_Work';
      return this.http
        .get<TResult_List<TeTag_Work>>( url, {headers: this.headers})
        .map<TResult_List<TeTag_Work>, TResult_List<TeTag_Work>>( _rl =>
          {
          const Result= new TResult_List<TeTag_Work>();
          for( let _e of _rl.Elements)
            {
            const e: TeTag_Work= new TeTag_Work( _e);
            e.service= this;
            Result.Elements.push( e);
            }
          return Result;
          })
        .toPromise();
    }
    public All_id_Libelle(): Promise<TResult_List<TeTag_Work>>
    {
      const url= API_URL + '/Tag_Work_id_Libelle';
      return this.http
        .get<TResult_List<TeTag_Work>>( url, {headers: this.headers})
        .map<TResult_List<TeTag_Work>, TResult_List<TeTag_Work>>( _rl =>
          {
          const Result= new TResult_List<TeTag_Work>();
          for( let _e of _rl.Elements)
            {
            const e: TeTag_Work= new TeTag_Work( _e);
            e.service= this;
            Result.Elements.push( e);
            }
          return Result;
          })
        .toPromise();
    }
  }
