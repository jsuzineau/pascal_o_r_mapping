import {  Component,
          OnInit,
          Input,
                                 } from '@angular/core';
import { Router                  } from '@angular/router';

import { TResult_List} from '../uResult_List';
import { TsNom_de_la_classe} from './usNom_de_la_classe';
import { TeNom_de_la_classe} from './ueNom_de_la_classe';

@Component({
  selector: 'cNom_de_la_classe',
  templateUrl: './ucNom_de_la_classe.html',
  styleUrls: ['./ucNom_de_la_classe.css'],
  providers: [TsNom_de_la_classe],
  })

export class TcNom_de_la_classe implements OnInit
  {
   
    @Input() public e: TeNom_de_la_classe|null= null;
  constructor(private router: Router, private service: TsNom_de_la_classe)
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

