import { Injectable, OnInit} from '@angular/core';
import { Headers, Http, Response } from '@angular/http';
import { HttpClient, HttpHeaders     } from '@angular/common/http';
import { Observable     } from 'rxjs/Observable';
import 'rxjs/add/operator/toPromise';
import 'rxjs/add/operator/map';
import { environment    } from '../../../environments/environment';

import { SessionService} from './session.service';
import { PROJECT   } from './element/project';

const API_URL = environment.api_url;

@Injectable()
export class PROJECTService
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

  public Delete( _u: PROJECT): PROJECTService
    {
    const url= API_URL + '/PROJECT_Delete.php' + SessionService.SID + PROJECT.id_parameter( _u.id);
    this.http.get(  url, {headers: this.headers});
    return this;
    }
  public Get( _id: number): Promise<PROJECT>
    {
      const url= API_URL + '/PROJECT_Get.php' + SessionService.SID + PROJECT.id_parameter( _id);
      return this.http
        .get<PROJECT>(  url, {headers: this.headers})
        .map<PROJECT,PROJECT>( _u =>
          {
          const Result: PROJECT= new PROJECT( _u);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Insert( _u: PROJECT): Promise<PROJECT>
    {
      const url= API_URL + '/PROJECT_Insert.php' + SessionService.SID;
      return this.http
        .post<PROJECT>( url, JSON.stringify( _u), {headers: this.headers})
        .map<PROJECT,PROJECT>( _u =>
          {
          const Result: PROJECT= new PROJECT( _u);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Set( _u: PROJECT): Promise<PROJECT>
    {
      const u: PROJECT= _u.to_ServerValue();

      const url= API_URL + '/PROJECT_Set.php' + SessionService.SID + PROJECT.id_parameter( u.id);
      return this.http
        .post<PROJECT>( url, JSON.stringify( u), {headers: this.headers})
        .map<PROJECT,PROJECT>( _u =>
          {
          const Result: PROJECT= new PROJECT( _u);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public All(): Promise<Array<PROJECT>>
    {
      const url= API_URL + '/PROJECT.php' + SessionService.SID;
      return this.http
        .get<Array<PROJECT>>( url, {headers: this.headers})
        .map<Array<PROJECT>, Array<PROJECT>>( _utilisateurs =>
          {
          const Result= Array<PROJECT>();
          for( let _u of _utilisateurs)
            {
            const u: PROJECT= new PROJECT( _u);
            u.service= this;
            Result.push( u);
            }
          return Result;
          })
        .toPromise();
    }
  }
