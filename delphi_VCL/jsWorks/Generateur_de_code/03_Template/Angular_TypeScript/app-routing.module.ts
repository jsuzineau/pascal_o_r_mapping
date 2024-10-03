import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Routes } from '@angular/router';

import { CustomComponent } from './component/custom.component';
//APP_ROUTING_MODULE_TS_IMPORT_LIST

const routes: Routes =
  [
    { path: '', redirectTo: '/Works', pathMatch: 'full' },
    { path: 'custom', component: CustomComponent},
    //APP_ROUTING_MODULE_TS_ROUTES
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
