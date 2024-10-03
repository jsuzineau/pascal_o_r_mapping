import {  Component,
          OnInit,
          Input,
                                 } from '@angular/core';
import { Router                  } from '@angular/router';

import { TResult_List} from '../uResult_List';
import { TsCategorie} from './usCategorie';
import { TeCategorie} from './ueCategorie';

@Component({
  selector: 'cCategorie',
  templateUrl: './ucCategorie.html',
  styleUrls: ['./ucCategorie.css'],
  providers: [TsCategorie],
  })

export class TcCategorie implements OnInit
  {
   
    @Input() public e: TeCategorie|null= null;
  constructor(private router: Router, private service: TsCategorie)
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

