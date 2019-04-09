import { Injectable, OnInit} from '@angular/core';
import { Headers, Http, Response } from '@angular/http';
import { HttpClient, HttpHeaders     } from '@angular/common/http';
import { Observable     } from 'rxjs/Observable';
import 'rxjs/add/operator/toPromise';
import 'rxjs/add/operator/map';
import { environment    } from '../../../environments/environment';

import { Result_List} from './result_list';
import { Work   } from './element/work';

const API_URL = environment.api_url;

@Injectable()
export class WorkService
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

  public Delete( _e: Work): WorkService
    {
    const url= API_URL + '/Work_Delete' + Work.id_parameter( _e.id);
    this.http.get(  url, {headers: this.headers});
    return this;
    }
  public Get( _id: number): Promise<Work>
    {
      const url= API_URL + '/Work_Get' + Work.id_parameter( _id);
      return this.http
        .get<Work>(  url, {headers: this.headers})
        .map<Work,Work>( _e =>
          {
          const Result: Work= new Work( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Insert( _e: Work): Promise<Work>
    {
      const url= API_URL + '/Work_Insert';
      return this.http
        .post<Work>( url, JSON.stringify( _e), {headers: this.headers})
        .map<Work,Work>( _e =>
          {
          const Result: Work= new Work( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Set( _e: Work): Promise<Work>
    {
      const e: Work= _e.to_ServerValue();

      const url= API_URL + '/Work_Set' + Work.id_parameter( e.id);
      return this.http
        .post<Work>( url, JSON.stringify( e), {headers: this.headers})
        .map<Work,Work>( _e =>
          {
          const Result: Work= new Work( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public All(): Promise<Result_List<Work>>
    {
      const url= API_URL + '/Work';
      return this.http
        .get<Result_List<Work>>( url, {headers: this.headers})
        .map<Result_List<Work>, Result_List<Work>>( _rl =>
          {
          const Result= new Result_List<Work>();
          for( let _e of _rl.Elements)
            {
            const e: Work= new Work( _e);
            e.service= this;
            Result.Elements.push( e);
            }
          return Result;
          })
        .toPromise();
    }
  }
