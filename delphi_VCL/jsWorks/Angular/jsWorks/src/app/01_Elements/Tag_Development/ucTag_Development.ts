import {  Component,
          OnInit,
          Input,
                                 } from '@angular/core';
import { Router                  } from '@angular/router';

import { TResult_List} from '../uResult_List';
import { TsTag_Development} from './usTag_Development';
import { TeTag_Development} from './ueTag_Development';

@Component({
  selector: 'cTag_Development',
  templateUrl: './ucTag_Development.html',
  styleUrls: ['./ucTag_Development.css'],
  providers: [TsTag_Development],
  })

export class TcTag_Development implements OnInit
  {
   
    @Input() public e: TeTag_Development|null= null;
  constructor(private router: Router, private service: TsTag_Development)
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

