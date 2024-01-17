import {  Component,
          OnInit,
          Input,
                                 } from '@angular/core';
import { Router                  } from '@angular/router';

import { TResult_List} from '../uResult_List';
import { TsType_Tag} from './usType_Tag';
import { TeType_Tag} from './ueType_Tag';

@Component({
  selector: 'cType_Tag',
  templateUrl: './ucType_Tag.html',
  styleUrls: ['./ucType_Tag.css'],
  providers: [TsType_Tag],
  })

export class TcType_Tag implements OnInit
  {
   
    @Input() public e: TeType_Tag|null= null;
  constructor(private router: Router, private service: TsType_Tag)
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

