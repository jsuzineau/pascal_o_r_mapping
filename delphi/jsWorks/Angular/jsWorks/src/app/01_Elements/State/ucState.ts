import {  Component,
          OnInit,
          Input,
                                 } from '@angular/core';
import { Router                  } from '@angular/router';

import { TResult_List} from '../uResult_List';
import { TsState} from './usState';
import { TeState} from './ueState';

@Component({
  selector: 'cState',
  templateUrl: './ucState.html',
  styleUrls: ['./ucState.css'],
  providers: [TsState],
  })

export class TcState implements OnInit
  {
   
    @Input() public e: TeState|null= null;
  constructor(private router: Router, private service: TsState)
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

