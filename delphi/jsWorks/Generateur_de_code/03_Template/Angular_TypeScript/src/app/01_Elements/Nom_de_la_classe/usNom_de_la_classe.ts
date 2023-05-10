import { Injectable, OnInit} from '@angular/core';
import { Headers, Http, Response } from '@angular/http';
import { HttpClient, HttpHeaders     } from '@angular/common/http';
import { Observable     } from 'rxjs/Observable';
import 'rxjs/add/operator/toPromise';
import 'rxjs/add/operator/map';
import { environment    } from '../../../environments/environment';

import { TResult_List} from '../uResult_List';
import { TeNom_de_la_classe   } from './ueNom_de_la_classe';

const API_URL = environment.api_url;

@Injectable()
export class TsNom_de_la_classe
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

  public Delete( _e: TeNom_de_la_classe): TsNom_de_la_classe
    {
    const url= API_URL + '/Nom_de_la_classe_Delete' + TeNom_de_la_classe.id_parameter( _e.id);
    this.http.get(  url, {headers: this.headers});
    return this;
    }
  public Get( _id: number): Promise<TeNom_de_la_classe>
    {
      const url= API_URL + '/Nom_de_la_classe_Get' + TeNom_de_la_classe.id_parameter( _id);
      return this.http
        .get<TeNom_de_la_classe>(  url, {headers: this.headers})
        .map<TeNom_de_la_classe,TeNom_de_la_classe>( _e =>
          {
          const Result: TeNom_de_la_classe= new TeNom_de_la_classe( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Insert( _e: TeNom_de_la_classe): Promise<TeNom_de_la_classe>
    {
      const url= API_URL + '/Nom_de_la_classe_Insert';
      return this.http
        .post<TeNom_de_la_classe>( url, JSON.stringify( _e), {headers: this.headers})
        .map<TeNom_de_la_classe,TeNom_de_la_classe>( _e =>
          {
          const Result: TeNom_de_la_classe= new TeNom_de_la_classe( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Set( _e: TeNom_de_la_classe): Promise<TeNom_de_la_classe>
    {
      const e: TeNom_de_la_classe= _e.to_ServerValue();

      const url= API_URL + '/Nom_de_la_classe_Set' + TeNom_de_la_classe.id_parameter( e.id);
      return this.http
        .post<TeNom_de_la_classe>( url, JSON.stringify( e), {headers: this.headers})
        .map<TeNom_de_la_classe,TeNom_de_la_classe>( _e =>
          {
          const Result: TeNom_de_la_classe= new TeNom_de_la_classe( _e);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public All(): Promise<TResult_List<TeNom_de_la_classe>>
    {
      const url= API_URL + '/Nom_de_la_classe';
      return this.http
        .get<TResult_List<TeNom_de_la_classe>>( url, {headers: this.headers})
        .map<TResult_List<TeNom_de_la_classe>, TResult_List<TeNom_de_la_classe>>( _rl =>
          {
          const Result= new TResult_List<TeNom_de_la_classe>();
          for( let _e of _rl.Elements)
            {
            const e: TeNom_de_la_classe= new TeNom_de_la_classe( _e);
            e.service= this;
            Result.Elements.push( e);
            }
          return Result;
          })
        .toPromise();
    }
    public All_id_Libelle(): Promise<TResult_List<TeNom_de_la_classe>>
    {
      const url= API_URL + '/Nom_de_la_classe_id_Libelle';
      return this.http
        .get<TResult_List<TeNom_de_la_classe>>( url, {headers: this.headers})
        .map<TResult_List<TeNom_de_la_classe>, TResult_List<TeNom_de_la_classe>>( _rl =>
          {
          const Result= new TResult_List<TeNom_de_la_classe>();
          for( let _e of _rl.Elements)
            {
            const e: TeNom_de_la_classe= new TeNom_de_la_classe( _e);
            e.service= this;
            Result.Elements.push( e);
            }
          return Result;
          })
        .toPromise();
    }
  }
