import {  Component,
          OnInit,
          Input,
                                 } from '@angular/core';
import { Router                  } from '@angular/router';

import { TResult_List} from '../uResult_List';
import { TsTag_Work} from './usTag_Work';
import { TeTag_Work} from './ueTag_Work';

@Component({
  selector: 'clTag_Work',
  templateUrl: './uclTag_Work.html',
  styleUrls: ['./uclTag_Work.css'],
  providers: [TsTag_Work],
  })

export class TclTag_Work implements OnInit
  {
  public e: TeTag_Work|null= null;
  public Tag_Works: TResult_List<TeTag_Work>;
  constructor(private router: Router, private service: TsTag_Work)
    {
    }
  ngOnInit(): void
    {
    this.service.All_id_Libelle()
      .then( _Tag_Works =>
        {
        this.Tag_Works= new TResult_List<TeTag_Work>(_Tag_Works);
        this.Tag_Works.Elements.forEach( _e =>
          {
          _e.service= this.service;
          });
        });
    }
  onClick( _e: TeTag_Work)
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
  Tag_Works_Nouveau()
    {
    this.service.Insert( new TeTag_Work)
      .then( _e =>
        {
        this.Tag_Works.Elements.push( _e);
        }
        );
    }
  }

