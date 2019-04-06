import { Injectable, OnInit} from '@angular/core';
import { Headers, Http, Response } from '@angular/http';
import { HttpClient, HttpHeaders     } from '@angular/common/http';
import { Observable     } from 'rxjs/Observable';
import 'rxjs/add/operator/toPromise';
import 'rxjs/add/operator/map';
import { environment    } from '../../../environments/environment';

import { SessionService} from './session.service';
import { WORK   } from './element/work';

const API_URL = environment.api_url;

@Injectable()
export class WORKService
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

  public Delete( _u: WORK): WORKService
    {
    const url= API_URL + '/WORK_Delete.php' + SessionService.SID + WORK.id_parameter( _u.id);
    this.http.get(  url, {headers: this.headers});
    return this;
    }
  public Get( _id: number): Promise<WORK>
    {
      const url= API_URL + '/WORK_Get.php' + SessionService.SID + WORK.id_parameter( _id);
      return this.http
        .get<WORK>(  url, {headers: this.headers})
        .map<WORK,WORK>( _u =>
          {
          const Result: WORK= new WORK( _u);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Insert( _u: WORK): Promise<WORK>
    {
      const url= API_URL + '/WORK_Insert.php' + SessionService.SID;
      return this.http
        .post<WORK>( url, JSON.stringify( _u), {headers: this.headers})
        .map<WORK,WORK>( _u =>
          {
          const Result: WORK= new WORK( _u);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Set( _u: WORK): Promise<WORK>
    {
      const u: WORK= _u.to_ServerValue();

      const url= API_URL + '/WORK_Set.php' + SessionService.SID + WORK.id_parameter( u.id);
      return this.http
        .post<WORK>( url, JSON.stringify( u), {headers: this.headers})
        .map<WORK,WORK>( _u =>
          {
          const Result: WORK= new WORK( _u);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public All(): Promise<Array<WORK>>
    {
      const url= API_URL + '/WORK.php' + SessionService.SID;
      return this.http
        .get<Array<WORK>>( url, {headers: this.headers})
        .map<Array<WORK>, Array<WORK>>( _utilisateurs =>
          {
          const Result= Array<WORK>();
          for( let _u of _utilisateurs)
            {
            const u: WORK= new WORK( _u);
            u.service= this;
            Result.push( u);
            }
          return Result;
          })
        .toPromise();
    }
  }
