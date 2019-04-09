import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Routes } from '@angular/router';

import { AppProjectComponent     } from './component/app-project.component';
import { AppWorkComponent     } from './component/app-work.component';


const routes: Routes =
  [
    { path: '', redirectTo: '/work', pathMatch: 'full' },
    { path: 'project', component: AppProjectComponent},
    { path: 'work'   , component: AppWorkComponent},
    
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
