import {  Component,
          OnInit,
          Input,
                                 } from '@angular/core';
import { Router                  } from '@angular/router';

import { TResult_List} from '../uResult_List';
import { TsState} from './usState';
import { TeState} from './ueState';

@Component({
  selector: 'clState',
  templateUrl: './uclState.html',
  styleUrls: ['./uclState.css'],
  providers: [TsState],
  })

export class TclState implements OnInit
  {
  public e: TeState|null= null;
  public States: TResult_List<TeState>;
  constructor(private router: Router, private service: TsState)
    {
    }
  ngOnInit(): void
    {
    this.service.All_id_Libelle()
      .then( _States =>
        {
        this.States= new TResult_List<TeState>(_States);
        this.States.Elements.forEach( _e =>
          {
          _e.service= this.service;
          });
        });
    }
  onClick( _e: TeState)
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
  States_Nouveau()
    {
    this.service.Insert( new TeState)
      .then( _e =>
        {
        this.States.Elements.push( _e);
        }
        );
    }
  }

