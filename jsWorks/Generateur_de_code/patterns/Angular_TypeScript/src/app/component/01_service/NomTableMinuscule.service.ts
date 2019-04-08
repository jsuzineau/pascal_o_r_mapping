import { Injectable, OnInit} from '@angular/core';
import { Headers, Http, Response } from '@angular/http';
import { HttpClient, HttpHeaders     } from '@angular/common/http';
import { Observable     } from 'rxjs/Observable';
import 'rxjs/add/operator/toPromise';
import 'rxjs/add/operator/map';
import { environment    } from '../../../environments/environment';

import { Nom_de_la_classe   } from './element/NomTableMinuscule';

const API_URL = environment.api_url;

@Injectable()
export class Nom_de_la_classeService
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

  public Delete( _u: Nom_de_la_classe): Nom_de_la_classeService
    {
    const url= API_URL + '/Nom_de_la_classe_Delete.php?' + Nom_de_la_classe.id_parameter( _u.id);
    this.http.get(  url, {headers: this.headers});
    return this;
    }
  public Get( _id: number): Promise<Nom_de_la_classe>
    {
      const url= API_URL + '/Nom_de_la_classe_Get.php?' + Nom_de_la_classe.id_parameter( _id);
      return this.http
        .get<Nom_de_la_classe>(  url, {headers: this.headers})
        .map<Nom_de_la_classe,Nom_de_la_classe>( _u =>
          {
          const Result: Nom_de_la_classe= new Nom_de_la_classe( _u);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Insert( _u: Nom_de_la_classe): Promise<Nom_de_la_classe>
    {
      const url= API_URL + '/Nom_de_la_classe_Insert.php';
      return this.http
        .post<Nom_de_la_classe>( url, JSON.stringify( _u), {headers: this.headers})
        .map<Nom_de_la_classe,Nom_de_la_classe>( _u =>
          {
          const Result: Nom_de_la_classe= new Nom_de_la_classe( _u);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public Set( _u: Nom_de_la_classe): Promise<Nom_de_la_classe>
    {
      const u: Nom_de_la_classe= _u.to_ServerValue();

      const url= API_URL + '/Nom_de_la_classe_Set.php?' + Nom_de_la_classe.id_parameter( u.id);
      return this.http
        .post<Nom_de_la_classe>( url, JSON.stringify( u), {headers: this.headers})
        .map<Nom_de_la_classe,Nom_de_la_classe>( _u =>
          {
          const Result: Nom_de_la_classe= new Nom_de_la_classe( _u);
          Result.service= this;
          return Result;
          })
        .toPromise();
    }
  public All(): Promise<Array<Nom_de_la_classe>>
    {
      const url= API_URL + '/Nom_de_la_classe.php';
      return this.http
        .get<Array<Nom_de_la_classe>>( url, {headers: this.headers})
        .map<Array<Nom_de_la_classe>, Array<Nom_de_la_classe>>( _utilisateurs =>
          {
          const Result= Array<Nom_de_la_classe>();
          for( let _u of _utilisateurs)
            {
            const u: Nom_de_la_classe= new Nom_de_la_classe( _u);
            u.service= this;
            Result.push( u);
            }
          return Result;
          })
        .toPromise();
    }
  }
