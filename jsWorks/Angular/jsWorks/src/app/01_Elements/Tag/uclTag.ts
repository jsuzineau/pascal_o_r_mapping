import {  Component,
          OnInit,
          Input,
                                 } from '@angular/core';
import { Router                  } from '@angular/router';

import { TResult_List} from '../uResult_List';
import { TsTag} from './usTag';
import { TeTag} from './ueTag';

@Component({
  selector: 'clTag',
  templateUrl: './uclTag.html',
  styleUrls: ['./uclTag.css'],
  providers: [TsTag],
  })

export class TclTag implements OnInit
  {
  public e: TeTag|null= null;
  public Tags: TResult_List<TeTag>;
  constructor(private router: Router, private service: TsTag)
    {
    }
  ngOnInit(): void
    {
    this.service.All_id_Libelle()
      .then( _Tags =>
        {
        this.Tags= new TResult_List<TeTag>(_Tags);
        this.Tags.Elements.forEach( _e =>
          {
          _e.service= this.service;
          });
        });
    }
  onClick( _e: TeTag)
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
  Tags_Nouveau()
    {
    this.service.Insert( new TeTag)
      .then( _e =>
        {
        this.Tags.Elements.push( _e);
        }
        );
    }
  }

