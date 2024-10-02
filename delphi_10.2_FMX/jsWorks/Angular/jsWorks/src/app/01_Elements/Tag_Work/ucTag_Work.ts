import {  Component,
          OnInit,
          Input,
                                 } from '@angular/core';
import { Router                  } from '@angular/router';

import { TResult_List} from '../uResult_List';
import { TsTag_Work} from './usTag_Work';
import { TeTag_Work} from './ueTag_Work';

@Component({
  selector: 'cTag_Work',
  templateUrl: './ucTag_Work.html',
  styleUrls: ['./ucTag_Work.css'],
  providers: [TsTag_Work],
  })

export class TcTag_Work implements OnInit
  {
   
    @Input() public e: TeTag_Work|null= null;
  constructor(private router: Router, private service: TsTag_Work)
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

