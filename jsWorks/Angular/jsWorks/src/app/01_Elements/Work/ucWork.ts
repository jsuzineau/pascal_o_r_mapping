import {  Component,
          OnInit,
          Input,
                                 } from '@angular/core';
import { Router                  } from '@angular/router';

import { TResult_List} from '../uResult_List';
import { TsWork} from './usWork';
import { TeWork} from './ueWork';

@Component({
  selector: 'cWork',
  templateUrl: './ucWork.html',
  styleUrls: ['./ucWork.css'],
  providers: [TsWork],
  })

export class TcWork implements OnInit
  {
  @Input() id: number=-1;  
  public e: TeWork|null= null;
  public Works: TResult_List<TeWork>;
  constructor(private router: Router, private service: TsWork)
    {
    }
  ngOnInit(): void
    {
    this.service.All()
      .then( _Works =>
        {
        this.Works= new TResult_List<TeWork>(_Works);
        this.Works.Elements.forEach( _e =>
          {
          _e.service= this.service;
          });
        });
    }
  onClick( _e: TeWork)
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
  Works_Nouveau()
    {
    this.service.Insert( new TeWork)
      .then( _e =>
        {
        this.Works.Elements.push( _e);
        }
        );
    }
  }
