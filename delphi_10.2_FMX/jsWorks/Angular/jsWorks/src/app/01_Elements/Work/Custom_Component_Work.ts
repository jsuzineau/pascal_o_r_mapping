import {  Component,
          OnInit,
          Input,
                                 } from '@angular/core';
import { Router                  } from '@angular/router';

import { TResult_List} from '../uResult_List';
import { TsWork} from './usWork';
import { TeWork} from './ueWork';

@Component({
  selector: 'Custom_Component_Work',
  templateUrl: './Custom_Component_Work.html',
  styleUrls: ['./Custom_Component_Work.css'],
  providers: [TsWork],
  })

export class Custom_Component_Work implements OnInit
  {
   
    @Input() public e: TeWork|null= null;
    public tinyMceSettings 
      = 
       {
       skin_url: '/assets/tinymce/skins/ui/oxide',
       //skin_url: '/assets/tinymce/skins/',
       //inline: false,
       //statusbar: false,
       //browser_spellcheck: true,
       //height: 320,
       //plugins: 'fullscreen link',
       toolbar: "numlist bullist",
       plugins: 'link, lists',
       };
      constructor(private router: Router, private service: TsWork)
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

