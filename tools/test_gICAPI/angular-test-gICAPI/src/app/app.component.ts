import { Component, ViewEncapsulation } from '@angular/core';
import {} from  'jquery';
import {Metro} from  'metro4-dist';
import { TgICAPI} from './01_service/gICAPI.service';
import {Element, Element_Vide} from './01_service/element/element'
@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  encapsulation: ViewEncapsulation.None,
  styleUrls: ['./app.component.css'],
  providers: [TgICAPI],
})
export class AppComponent 
  {
  title = 'angular-test-giCAPI';
  constructor(private gICAPI:TgICAPI)
    {
      
    }
  data(): Element
   {
   var e: Element= this.gICAPI.data;  
   if (!e) e= Element_Vide;
   return e;  
   }
  action( _action: string) 
    {
    console.log("AppComponent.action("+_action+")");   
    this.gICAPI.Action( _action);  
    }
  }
