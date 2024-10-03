import {  Component,
          OnInit,
          Input,
                                 } from '@angular/core';
import { Router                  } from '@angular/router';

import { TResult_List} from '../uResult_List';
import { TsDevelopment} from './usDevelopment';
import { TeDevelopment} from './ueDevelopment';

@Component({
  selector: 'cDevelopment',
  templateUrl: './ucDevelopment.html',
  styleUrls: ['./ucDevelopment.css'],
  providers: [TsDevelopment],
  })

export class TcDevelopment implements OnInit
  {
   
    @Input() public e: TeDevelopment|null= null;
  constructor(private router: Router, private service: TsDevelopment)
    {
    }
  ngOnInit(): void
    {
    }
  onClick()
    {
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
  }

