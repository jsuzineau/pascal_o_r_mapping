import { Injectable, OnInit} from '@angular/core';
import { Headers, Http, Response } from '@angular/http';
import { HttpClient, HttpHeaders     } from '@angular/common/http';
import { Observable     } from 'rxjs/Observable';
import 'rxjs/add/operator/toPromise';
import 'rxjs/add/operator/map';
import { environment    } from '../../../environments/environment';

import { TResult_List} from '../uResult_List';
import { TeProject   } from './ueProject';

const API_URL = environment.api_url;

@Injectable()
export class TsProject
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

  public Delete( _e: TeProject): TsProject
    {
    const url= API_URL + '/Project_Delete' + TeProject.id_parameter( _e.id);
    this.http.get(  url, {headers: this.headers});
    return this;
    }
  public Get( _id: number): Promise<TeProject>
    {
      const url= API_URL + '/Project_Get' + TeProject.id_parameter( _id);
      return this.http
        .get<TeProject>(  url, {headers: this.headers})
        .map<TeProject,TeProject>( _e =>
          {
          const Result: TeProject= new TeProject( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Insert( _e: TeProject): Promise<TeProject>
    {
      const url= API_URL + '/Project_Insert';
      return this.http
        .post<TeProject>( url, JSON.stringify( _e), {headers: this.headers})
        .map<TeProject,TeProject>( _e =>
          {
          const Result: TeProject= new TeProject( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Set( _e: TeProject): Promise<TeProject>
    {
      const e: TeProject= _e.to_ServerValue();

      const url= API_URL + '/Project_Set' + TeProject.id_parameter( e.id);
      return this.http
        .post<TeProject>( url, JSON.stringify( e), {headers: this.headers})
        .map<TeProject,TeProject>( _e =>
          {
          const Result: TeProject= new TeProject( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public All(): Promise<TResult_List<TeProject>>
    {
      const url= API_URL + '/Project';
      return this.http
        .get<TResult_List<TeProject>>( url, {headers: this.headers})
        .map<TResult_List<TeProject>, TResult_List<TeProject>>( _rl =>
          {
          const Result= new TResult_List<TeProject>();
          for( let _e of _rl.Elements)
            {
            const e: TeProject= new TeProject( _e);
            e.service= this;
            Result.Elements.push( e);
            }
          return Result;
          })
        .toPromise();
    }
    public All_id_Libelle(): Promise<TResult_List<TeProject>>
    {
      const url= API_URL + '/Project_id_Libelle';
      return this.http
        .get<TResult_List<TeProject>>( url, {headers: this.headers})
        .map<TResult_List<TeProject>, TResult_List<TeProject>>( _rl =>
          {
          const Result= new TResult_List<TeProject>();
          for( let _e of _rl.Elements)
            {
            const e: TeProject= new TeProject( _e);
            e.service= this;
            Result.Elements.push( e);
            }
          return Result;
          })
        .toPromise();
    }
  }
