import { Injectable} from '@angular/core';
import { HttpClient, HttpHeaders} from '@angular/common/http';
import { Observable} from 'rxjs';
import { environment    } from '../../../environments/environment';
const API_URL = environment.api_url;

export var gICAPI: TgICAPI= null;

@Injectable()
export class TgICAPI  
  {
  public onProperty;  
  public onData;
  public onFocus;
  // private headers = new HttpHeaders({'Content-Type': 'application/json'});
  private headers = new HttpHeaders({'Content-Type' : 'application/x-www-form-urlencoded; charset=UTF-8'});
  public onICHostReady= function(version) {console.log("onICHostReady() de gICAPI.ts");   };

  constructor( private http: HttpClient)
    {
    }
  public Init()
    {
    console.log("TgICAPI.Init");   
    gICAPI=this;
    this.onICHostReady("1.0");
    if (this.onData)
      {
      this.data_Promise().then( _data => this.onData( _data))
      }
    }  

  private handleError( error: any | any)
    {
    console.error( this.constructor.name + '::handleError', error);
    return Observable.throw(error);
    }
  public data_Promise(): Promise<any>  
  {
    //const url= API_URL + '/Data';
    const url= 'Data';
    return this.http
      .get( url)
      .toPromise();
    }
  public Action(_action: string): Promise<boolean> 
    {
    // const url= API_URL + '/Action' + _Action_Name;
    const url= 'Action' + _action;
    console.log(this.constructor.name+".Action("+_action+")");   
    console.log("url="+url);   
    return this.http.get<boolean>(  url, {headers: this.headers}).toPromise();    
    }
  }
