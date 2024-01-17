import {  Component,
          OnInit,
          Input,
                                 } from '@angular/core';
import { Router                  } from '@angular/router';

import { TResult_List} from '../uResult_List';
import { TsTag} from './usTag';
import { TeTag} from './ueTag';

@Component({
  selector: 'cTag',
  templateUrl: './ucTag.html',
  styleUrls: ['./ucTag.css'],
  providers: [TsTag],
  })

export class TcTag implements OnInit
  {
   
    @Input() public e: TeTag|null= null;
  constructor(private router: Router, private service: TsTag)
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

