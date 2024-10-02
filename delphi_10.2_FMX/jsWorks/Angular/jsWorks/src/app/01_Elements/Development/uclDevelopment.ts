import {  Component,
          OnInit,
          Input,
                                 } from '@angular/core';
import { Router                  } from '@angular/router';

import { TResult_List} from '../uResult_List';
import { TsDevelopment} from './usDevelopment';
import { TeDevelopment} from './ueDevelopment';

@Component({
  selector: 'clDevelopment',
  templateUrl: './uclDevelopment.html',
  styleUrls: ['./uclDevelopment.css'],
  providers: [TsDevelopment],
  })

export class TclDevelopment implements OnInit
  {
  public e: TeDevelopment|null= null;
  public Developments: TResult_List<TeDevelopment>;
  constructor(private router: Router, private service: TsDevelopment)
    {
    }
  ngOnInit(): void
    {
    this.service.All_id_Libelle()
      .then( _Developments =>
        {
        this.Developments= new TResult_List<TeDevelopment>(_Developments);
        this.Developments.Elements.forEach( _e =>
          {
          _e.service= this.service;
          });
        });
    }
  onClick( _e: TeDevelopment)
    {
    this.e= _e;
    this.e.modifie= true;
    }
  onKeyDown( event): void
    {
    if (13 === event.keyCode)
      {
      if (this.e)
        {
        this.e.Valide();
        }
      }
    }
  Developments_Nouveau()
    {
    this.service.Insert( new TeDevelopment)
      .then( _e =>
        {
        this.Developments.Elements.push( _e);
        }
        );
    }
  }

