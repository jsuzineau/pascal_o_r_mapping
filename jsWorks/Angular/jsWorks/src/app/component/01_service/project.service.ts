import { Injectable, OnInit} from '@angular/core';
import { Headers, Http, Response } from '@angular/http';
import { HttpClient, HttpHeaders     } from '@angular/common/http';
import { Observable     } from 'rxjs/Observable';
import 'rxjs/add/operator/toPromise';
import 'rxjs/add/operator/map';
import { environment    } from '../../../environments/environment';

import { Project   } from './element/project';

const API_URL = environment.api_url;

@Injectable()
export class ProjectService
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

  public Delete( _u: Project): ProjectService
    {
    const url= API_URL + '/Project_Delete.php?' + Project.id_parameter( _u.id);
    this.http.get(  url, {headers: this.headers});
    return this;
    }
  public Get( _id: number): Promise<Project>
    {
      const url= API_URL + '/Project_Get.php?' + Project.id_parameter( _id);
      return this.http
        .get<Project>(  url, {headers: this.headers})
        .map<Project,Project>( _u =>
          {
          const Result: Project= new Project( _u);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Insert( _u: Project): Promise<Project>
    {
      const url= API_URL + '/Project_Insert.php';
      return this.http
        .post<Project>( url, JSON.stringify( _u), {headers: this.headers})
        .map<Project,Project>( _u =>
          {
          const Result: Project= new Project( _u);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Set( _u: Project): Promise<Project>
    {
      const u: Project= _u.to_ServerValue();

      const url= API_URL + '/Project_Set.php?' + Project.id_parameter( u.id);
      return this.http
        .post<Project>( url, JSON.stringify( u), {headers: this.headers})
        .map<Project,Project>( _u =>
          {
          const Result: Project= new Project( _u);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public All(): Promise<Array<Project>>
    {
      const url= API_URL + '/Project.php';
      return this.http
        .get<Array<Project>>( url, {headers: this.headers})
        .map<Array<Project>, Array<Project>>( _utilisateurs =>
          {
          const Result= Array<Project>();
          for( let _u of _utilisateurs)
            {
            const u: Project= new Project( _u);
            u.service= this;
            Result.push( u);
            }
          return Result;
          })
        .toPromise();
    }
  }
