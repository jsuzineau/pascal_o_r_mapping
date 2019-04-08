import { Injectable, OnInit} from '@angular/core';
import { Headers, Http, Response } from '@angular/http';
import { HttpClient, HttpHeaders     } from '@angular/common/http';
import { Observable     } from 'rxjs/Observable';
import 'rxjs/add/operator/toPromise';
import 'rxjs/add/operator/map';
import { environment    } from '../../../environments/environment';

import { SessionService} from './session.service';
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

  public Delete( _u: Work): WorkService
    {
    const url= API_URL + '/Work_Delete.php' + SessionService.SID + Work.id_parameter( _u.id);
    this.http.get(  url, {headers: this.headers});
    return this;
    }
  public Get( _id: number): Promise<Work>
    {
      const url= API_URL + '/Work_Get.php' + SessionService.SID + Work.id_parameter( _id);
      return this.http
        .get<Work>(  url, {headers: this.headers})
        .map<Work,Work>( _u =>
          {
          const Result: Work= new Work( _u);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Insert( _u: Work): Promise<Work>
    {
      const url= API_URL + '/Work_Insert.php' + SessionService.SID;
      return this.http
        .post<Work>( url, JSON.stringify( _u), {headers: this.headers})
        .map<Work,Work>( _u =>
          {
          const Result: Work= new Work( _u);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Set( _u: Work): Promise<Work>
    {
      const u: Work= _u.to_ServerValue();

      const url= API_URL + '/Work_Set.php' + SessionService.SID + Work.id_parameter( u.id);
      return this.http
        .post<Work>( url, JSON.stringify( u), {headers: this.headers})
        .map<Work,Work>( _u =>
          {
          const Result: Work= new Work( _u);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public All(): Promise<Array<Work>>
    {
      const url= API_URL + '/Work.php' + SessionService.SID;
      return this.http
        .get<Array<Work>>( url, {headers: this.headers})
        .map<Array<Work>, Array<Work>>( _utilisateurs =>
          {
          const Result= Array<Work>();
          for( let _u of _utilisateurs)
            {
            const u: Work= new Work( _u);
            u.service= this;
            Result.push( u);
            }
          return Result;
          })
        .toPromise();
    }
  }
