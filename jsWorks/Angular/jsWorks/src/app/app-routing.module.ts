import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Routes } from '@angular/router';

import { TclProject} from './01_Elements/Project/uclProject';
import { TcProject} from './01_Elements/Project/ucProject';
import { TclWork} from './01_Elements/Work/uclWork';
import { TcWork} from './01_Elements/Work/ucWork';


const routes: Routes =
  [
    { path: '', redirectTo: '/Works', pathMatch: 'full' },
    { path: 'Projects'   , component: TclProject},
    { path: 'Project'   , component: TcProject},
    { path: 'Works'   , component: TclWork},
    { path: 'Work'   , component: TcWork},
    
    // { path: 'detail/:id', component: HeroDetailComponent },
  ];

@NgModule({
  declarations: [],
  imports: 
    [
    CommonModule,
    RouterModule.forRoot(routes) //recopié, à surveiller
    ],
  exports: [ RouterModule ]  
})
export class AppRoutingModule { }
