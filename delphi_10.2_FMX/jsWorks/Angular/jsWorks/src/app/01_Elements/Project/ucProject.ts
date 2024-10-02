import {  Component,
          OnInit,
          Input,
                                 } from '@angular/core';
import { Router                  } from '@angular/router';

import { TResult_List} from '../uResult_List';
import { TsProject} from './usProject';
import { TeProject} from './ueProject';

@Component({
  selector: 'cProject',
  templateUrl: './ucProject.html',
  styleUrls: ['./ucProject.css'],
  providers: [TsProject],
  })

export class TcProject implements OnInit
  {
   
    @Input() public e: TeProject|null= null;
  constructor(private router: Router, private service: TsProject)
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

