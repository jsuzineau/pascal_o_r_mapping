import {  Component,
          OnInit,
          Input,
                                 } from '@angular/core';
import { Router                  } from '@angular/router';

import { Result_List} from './01_service/result_list';
import { WorkService } from './01_service/work.service';
import { Work        } from './01_service/element/work';

@Component({
  selector: 'app-work',
  templateUrl: './03_html/app-work.component.html',
  styleUrls: ['./03_html/app-work.component.css'],
  providers: [WorkService],
  })

export class AppWorkComponent implements OnInit
  {
  public e: Work|null= null;
  public works: Result_List<Work>;
  constructor(private router: Router, private service: WorkService)
    {
    }
  ngOnInit(): void
    {
    this.service.All()
      .then( _works =>
        {
        this.works= new Result_List<Work>(_works);
        this.works.Elements.forEach( _e =>
          {
          _e.service= this.service;
          });
        });
    }
  onClick( _e: Work)
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
  works_Nouveau()
    {
    this.service.Insert( new Work)
      .then( _e =>
        {
        this.works.Elements.push( _e);
        }
        );
    }
  }

