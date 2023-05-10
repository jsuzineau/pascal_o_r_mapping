import {  Component,
          OnInit,
          Input,
                                 } from '@angular/core';
import { Router                  } from '@angular/router';

import { TResult_List} from '../uResult_List';
import { TsType_Tag} from './usType_Tag';
import { TeType_Tag} from './ueType_Tag';

@Component({
  selector: 'clType_Tag',
  templateUrl: './uclType_Tag.html',
  styleUrls: ['./uclType_Tag.css'],
  providers: [TsType_Tag],
  })

export class TclType_Tag implements OnInit
  {
  public e: TeType_Tag|null= null;
  public Type_Tags: TResult_List<TeType_Tag>;
  constructor(private router: Router, private service: TsType_Tag)
    {
    }
  ngOnInit(): void
    {
    this.service.All_id_Libelle()
      .then( _Type_Tags =>
        {
        this.Type_Tags= new TResult_List<TeType_Tag>(_Type_Tags);
        this.Type_Tags.Elements.forEach( _e =>
          {
          _e.service= this.service;
          });
        });
    }
  onClick( _e: TeType_Tag)
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
  Type_Tags_Nouveau()
    {
    this.service.Insert( new TeType_Tag)
      .then( _e =>
        {
        this.Type_Tags.Elements.push( _e);
        }
        );
    }
  }

