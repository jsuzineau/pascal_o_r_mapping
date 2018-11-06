import { Injectable} from '@angular/core';
import { Subject } from 'rxjs';
import {TElement, Element_Vide} from './element/uElement'
import { gICAPI, TgICAPI} from './gICAPI/ugICAPI'; //## ligne à commenter en webcomponent Genero

export var gICAPI_Client: TgICAPI_Client= null;
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

     gICAPI.onData
     = 
      function (data) 
        {
        gICAPI_Client.gICAPI_onData(data);
        }

     gICAPI.onFocus 
     = 
      function (polarity) 
        {
        }
     }

@Injectable()
export class TgICAPI_Client 
  {
  public e: TElement=Element_Vide;
  public p: Subject<TElement>= new Subject<TElement>();
  constructor(
               private gICAPI: TgICAPI //## ligne à commenter en webcomponent Genero     
             )
    {}
  public Init()
    {
    console.log("Début TgICAPI_Client.Init");   
    console.log("TgICAPI_Client.Init p="+JSON.stringify(this.p));   
    gICAPI_Client= this;
    console.log("TgICAPI_Client.Init gICAPI_Client.p="+JSON.stringify(gICAPI_Client.p));   
    this.gICAPI.onICHostReady=onICHostReady;//## ligne à commenter en webcomponent Genero
    this.gICAPI.Init();//## ligne à commenter en webcomponent Genero
    }  
  public gICAPI_onData( _e: TElement)  
    {
    console.log("TgICAPI_Client.gICAPI_onData(_e: TElement), _e.titre="+_e.titre);
    this.e= _e;
    this.p.next( this.e);
    }
  }

