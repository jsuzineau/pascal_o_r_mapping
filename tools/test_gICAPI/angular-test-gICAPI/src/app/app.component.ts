import { Component, ViewEncapsulation } from '@angular/core';
import {} from  'jquery';
import {Metro} from  'metro4-dist';
import { TgICAPI} from './01_service/gICAPI.service';
import {Element, Element_Vide} from './01_service/element/element'
import { R3_VIEW_CONTAINER_REF_FACTORY } from '@angular/core/src/ivy_switch/runtime/legacy';
@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  encapsulation: ViewEncapsulation.None,
  styleUrls: ['./app.component.css'],
  providers: [TgICAPI],
})
export class AppComponent 
  {
  title = 'angular-test-gICAPI';
  parents:Array<Element>=[];
  courant:Element=null;
  constructor(private gICAPI:TgICAPI)
    {
    this.gICAPI.data_Promise()
    .then( _data => 
      {
      this.courant= _data;  
      })  
    }
  racine(): Element
   {
   var e: Element= this.gICAPI.data;  
   if (!e) e= Element_Vide;
   return e;  
   }
  action( _e: Element) 
    {
    if (_e.children.length)
      {
      this.parents.push( this.courant);    
      this.courant= _e;
      }
    else
      {    
      console.log("AppComponent.action("+JSON.stringify(_e)+")");   
      this.gICAPI.Action( _e.id);  
      }
    }
  parent()
    {
    this.courant= this.parents.pop();    
    }  
  }
