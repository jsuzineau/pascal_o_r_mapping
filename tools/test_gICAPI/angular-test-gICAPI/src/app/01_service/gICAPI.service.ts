import { Injectable, OnInit} from '@angular/core';
import { Headers, Http, Response } from '@angular/http';
import { HttpClient, HttpHeaders,HttpClientModule} from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment    } from '../../environments/environment';
import {Element} from './element/element'
const API_URL = environment.api_url;

export var gICAPI: TgICAPI= null;

export var 
  onICHostReady 
  = 
   function(version) 
     {
     if (!gICAPI)  
       {
       alert('gICAPI non affecté');
       }
    if ( version != "1.0" ) 
       {
       alert('Invalid API version');
       }
     gICAPI.onProperty 
     = 
      function (propertySet) 
        {
        }

     gICAPI.onData= gICAPI.gICAPI_onData;

     gICAPI.onFocus 
     = 
      function (polarity) 
        {
        }
     }

@Injectable()
export class TgICAPI  
  {
  public onProperty;  
  public onData;
  public onFocus;
  // private headers = new HttpHeaders({'Content-Type': 'application/json'});
  private headers = new HttpHeaders({'Content-Type' : 'application/x-www-form-urlencoded; charset=UTF-8'});
  public data: Element;

  constructor( private http: HttpClient)
    {
    gICAPI= this;
    this.Init();  
    }
  public Init()
    {
    console.log("TgICAPI.Init");   
    onICHostReady("1.0");
    if (gICAPI.onData)
      {
      this.data_Promise()
      .then( _data => 
        {
        gICAPI.onData( _data);
        console.log("TgICAPI.Init, OnData:"+_data.titre);
        })
      }
    }  
  public gICAPI_onData( _data: Element)  
    {
    this.data= _data;
    }
;
  private handleError( error: any | any)
    {
    console.error( this.constructor.name + '::handleError', error);
    return Observable.throw(error);
    }
  public data_Promise(): Promise<Element>  
  {
    //const url= API_URL + '/Data';
    const url= 'Data';
    return this.http
      .get<Element>( url)
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
