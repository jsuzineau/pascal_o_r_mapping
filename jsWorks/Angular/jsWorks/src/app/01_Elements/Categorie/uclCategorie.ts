import {  Component,
          OnInit,
          Input,
                                 } from '@angular/core';
import { Router                  } from '@angular/router';

import { TResult_List} from '../uResult_List';
import { TsCategorie} from './usCategorie';
import { TeCategorie} from './ueCategorie';

@Component({
  selector: 'clCategorie',
  templateUrl: './uclCategorie.html',
  styleUrls: ['./uclCategorie.css'],
  providers: [TsCategorie],
  })

export class TclCategorie implements OnInit
  {
  public e: TeCategorie|null= null;
  public Categories: TResult_List<TeCategorie>;
  constructor(private router: Router, private service: TsCategorie)
    {
    }
  ngOnInit(): void
    {
    this.service.All_id_Libelle()
      .then( _Categories =>
        {
        this.Categories= new TResult_List<TeCategorie>(_Categories);
        this.Categories.Elements.forEach( _e =>
          {
          _e.service= this.service;
          });
        });
    }
  onClick( _e: TeCategorie)
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
  Categories_Nouveau()
    {
    this.service.Insert( new TeCategorie)
      .then( _e =>
        {
        this.Categories.Elements.push( _e);
        }
        );
    }
  }

