import { Injectable, OnInit} from '@angular/core';
import { Headers, Http, Response } from '@angular/http';
import { HttpClient, HttpHeaders     } from '@angular/common/http';
import { Observable     } from 'rxjs/Observable';
import 'rxjs/add/operator/toPromise';
import 'rxjs/add/operator/map';
import { environment    } from '../../../environments/environment';

import { Result_List} from './result_list';
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

  public Delete( _e: Project): ProjectService
    {
    const url= API_URL + '/Project_Delete' + Project.id_parameter( _e.id);
    this.http.get(  url, {headers: this.headers});
    return this;
    }
  public Get( _id: number): Promise<Project>
    {
      const url= API_URL + '/Project_Get' + Project.id_parameter( _id);
      return this.http
        .get<Project>(  url, {headers: this.headers})
        .map<Project,Project>( _e =>
          {
          const Result: Project= new Project( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Insert( _e: Project): Promise<Project>
    {
      const url= API_URL + '/Project_Insert';
      return this.http
        .post<Project>( url, JSON.stringify( _e), {headers: this.headers})
        .map<Project,Project>( _e =>
          {
          const Result: Project= new Project( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Set( _e: Project): Promise<Project>
    {
      const e: Project= _e.to_ServerValue();

      const url= API_URL + '/Project_Set' + Project.id_parameter( e.id);
      return this.http
        .post<Project>( url, JSON.stringify( e), {headers: this.headers})
        .map<Project,Project>( _e =>
          {
          const Result: Project= new Project( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public All(): Promise<Result_List<Project>>
    {
      const url= API_URL + '/Project';
      return this.http
        .get<Result_List<Project>>( url, {headers: this.headers})
        .map<Result_List<Project>, Result_List<Project>>( _rl =>
          {
          const Result= new Result_List<Project>();
          for( let _e of _rl.Elements)
            {
            const e: Project= new Project( _e);
            e.service= this;
            Result.Elements.push( e);
            }
          return Result;
          })
        .toPromise();
    }
  }
