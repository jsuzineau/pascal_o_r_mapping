import { Injectable, OnInit} from '@angular/core';
import { Headers, Http, Response } from '@angular/http';
import { HttpClient, HttpHeaders     } from '@angular/common/http';
import { Observable     } from 'rxjs/Observable';
import 'rxjs/add/operator/toPromise';
import 'rxjs/add/operator/map';
import { environment    } from '../../../environments/environment';

import { TResult_List} from '../uResult_List';
import { TeTag_Development   } from './ueTag_Development';

const API_URL = environment.api_url;

@Injectable()
export class TsTag_Development
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

  public Delete( _e: TeTag_Development): TsTag_Development
    {
    const url= API_URL + '/Tag_Development_Delete' + TeTag_Development.id_parameter( _e.id);
    this.http.get(  url, {headers: this.headers});
    return this;
    }
  public Get( _id: number): Promise<TeTag_Development>
    {
      const url= API_URL + '/Tag_Development_Get' + TeTag_Development.id_parameter( _id);
      return this.http
        .get<TeTag_Development>(  url, {headers: this.headers})
        .map<TeTag_Development,TeTag_Development>( _e =>
          {
          const Result: TeTag_Development= new TeTag_Development( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Insert( _e: TeTag_Development): Promise<TeTag_Development>
    {
      const url= API_URL + '/Tag_Development_Insert';
      return this.http
        .post<TeTag_Development>( url, JSON.stringify( _e), {headers: this.headers})
        .map<TeTag_Development,TeTag_Development>( _e =>
          {
          const Result: TeTag_Development= new TeTag_Development( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Set( _e: TeTag_Development): Promise<TeTag_Development>
    {
      const e: TeTag_Development= _e.to_ServerValue();

      const url= API_URL + '/Tag_Development_Set' + TeTag_Development.id_parameter( e.id);
      return this.http
        .post<TeTag_Development>( url, JSON.stringify( e), {headers: this.headers})
        .map<TeTag_Development,TeTag_Development>( _e =>
          {
          const Result: TeTag_Development= new TeTag_Development( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public All(): Promise<TResult_List<TeTag_Development>>
    {
      const url= API_URL + '/Tag_Development';
      return this.http
        .get<TResult_List<TeTag_Development>>( url, {headers: this.headers})
        .map<TResult_List<TeTag_Development>, TResult_List<TeTag_Development>>( _rl =>
          {
          const Result= new TResult_List<TeTag_Development>();
          for( let _e of _rl.Elements)
            {
            const e: TeTag_Development= new TeTag_Development( _e);
            e.service= this;
            Result.Elements.push( e);
            }
          return Result;
          })
        .toPromise();
    }
    public All_id_Libelle(): Promise<TResult_List<TeTag_Development>>
    {
      const url= API_URL + '/Tag_Development_id_Libelle';
      return this.http
        .get<TResult_List<TeTag_Development>>( url, {headers: this.headers})
        .map<TResult_List<TeTag_Development>, TResult_List<TeTag_Development>>( _rl =>
          {
          const Result= new TResult_List<TeTag_Development>();
          for( let _e of _rl.Elements)
            {
            const e: TeTag_Development= new TeTag_Development( _e);
            e.service= this;
            Result.Elements.push( e);
            }
          return Result;
          })
        .toPromise();
    }
  }
