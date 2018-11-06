import { Component, ViewEncapsulation,OnInit } from '@angular/core';
import {} from  'jquery';
import {Metro} from  'metro4-dist';
import { TgICAPI_Client} from './01_service/ugICAPI_Client';
import { gICAPI, TgICAPI} from './01_service/gICAPI/ugICAPI';
import {TElement} from './01_service/element/uElement'
import { R3_VIEW_CONTAINER_REF_FACTORY } from '@angular/core/src/ivy_switch/runtime/legacy';


@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  encapsulation: ViewEncapsulation.None,
  styleUrls: ['./app.component.css'],
  providers: [TgICAPI_Client,TgICAPI],
})
export class AppComponent implements OnInit 
  {
  title = 'angular-test-giCAPI';
  parents:Array<TElement>=[];
  courant:TElement=null;
  constructor(private gICAPI_Client:TgICAPI_Client)
    {}
  ngOnInit()
    {  
    console.log("Début AppComponent.ngOnInit()");   
    this.gICAPI_Client.Init();
    this.gICAPI_Client.p.subscribe({ next: (_e) => this.SetRacine(_e)});
    console.log("Fin AppComponent.ngOnInit()");   
    }
  public SetRacine( _e: TElement)  
    {
    console.log("Début AppComponent.SetRacine");   
    this.parents= [];  
    this.courant= _e;  
    console.log("Fin AppComponent.SetRacine");   
    }
  action( _e: TElement) 
    {
    console.log("AppComponent.action("+JSON.stringify(_e)+")");   
    if (_e.children.length)
      {
      console.log("AppComponent.action: sous menu");   
      this.parents.push( this.courant);    
      this.courant= _e;
      }
    else
      {    
      console.log("AppComponent.action: appel gICAPI.Action");   
      gICAPI.Action( _e.id);  
      }
    }
  parent()
    {
    console.log("Début AppComponent.parent()");   
    if (this.parents.length)
      {
      console.log("AppComponent.parent(): dépilage de this.parents");     
      this.courant= this.parents.pop();    
      }
    }  
  }
