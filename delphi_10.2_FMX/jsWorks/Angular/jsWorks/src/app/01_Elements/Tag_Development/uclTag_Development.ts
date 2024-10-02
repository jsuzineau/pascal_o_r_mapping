import {  Component,
          OnInit,
          Input,
                                 } from '@angular/core';
import { Router                  } from '@angular/router';

import { TResult_List} from '../uResult_List';
import { TsTag_Development} from './usTag_Development';
import { TeTag_Development} from './ueTag_Development';

@Component({
  selector: 'clTag_Development',
  templateUrl: './uclTag_Development.html',
  styleUrls: ['./uclTag_Development.css'],
  providers: [TsTag_Development],
  })

export class TclTag_Development implements OnInit
  {
  public e: TeTag_Development|null= null;
  public Tag_Developments: TResult_List<TeTag_Development>;
  constructor(private router: Router, private service: TsTag_Development)
    {
    }
  ngOnInit(): void
    {
    this.service.All_id_Libelle()
      .then( _Tag_Developments =>
        {
        this.Tag_Developments= new TResult_List<TeTag_Development>(_Tag_Developments);
        this.Tag_Developments.Elements.forEach( _e =>
          {
          _e.service= this.service;
          });
        });
    }
  onClick( _e: TeTag_Development)
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
  Tag_Developments_Nouveau()
    {
    this.service.Insert( new TeTag_Development)
      .then( _e =>
        {
        this.Tag_Developments.Elements.push( _e);
        }
        );
    }
  }

