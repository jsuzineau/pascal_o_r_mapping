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
   
    @Input() public e: TeWork|null= null;
  constructor(private router: Router, private service: TsWork)
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

