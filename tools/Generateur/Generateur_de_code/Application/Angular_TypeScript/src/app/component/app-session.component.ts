import { Component, Input, OnInit  } from '@angular/core';
import { Router                    } from '@angular/router';
import { HttpClient, HttpHeaders   } from '@angular/common/http';
import { Observable                } from 'rxjs/Observable';

import { environment    } from '../../environments/environment';

@Component({
  selector: 'app-session',
  templateUrl: './03_html/app-session.component.html',
  styleUrls: ['./03_html/app-session.component.css'],
  providers: []
})
export class AppSessionComponent implements OnInit
  {
  title = 'app';
  constructor ( private router: Router,
                private http: HttpClient)
    {
    }
  public gotoRepertoire(): void
    {
    this.router.navigate(['/repertoire']);
    }
  ngOnInit(): void
    {
    }
  }
