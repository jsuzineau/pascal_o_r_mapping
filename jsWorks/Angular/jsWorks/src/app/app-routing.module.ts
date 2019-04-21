import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Routes } from '@angular/router';

import { TclCategorie} from './01_Elements/Categorie/uclCategorie';
import { TcCategorie} from './01_Elements/Categorie/ucCategorie';
import { TclDevelopment} from './01_Elements/Development/uclDevelopment';
import { TcDevelopment} from './01_Elements/Development/ucDevelopment';
import { TclProject} from './01_Elements/Project/uclProject';
import { TcProject} from './01_Elements/Project/ucProject';
import { TclState} from './01_Elements/State/uclState';
import { TcState} from './01_Elements/State/ucState';
import { TclTag} from './01_Elements/Tag/uclTag';
import { TcTag} from './01_Elements/Tag/ucTag';
import { TclTag_Development} from './01_Elements/Tag_Development/uclTag_Development';
import { TcTag_Development} from './01_Elements/Tag_Development/ucTag_Development';
import { TclTag_Work} from './01_Elements/Tag_Work/uclTag_Work';
import { TcTag_Work} from './01_Elements/Tag_Work/ucTag_Work';
import { TclType_Tag} from './01_Elements/Type_Tag/uclType_Tag';
import { TcType_Tag} from './01_Elements/Type_Tag/ucType_Tag';
import { TclWork} from './01_Elements/Work/uclWork';
import { TcWork} from './01_Elements/Work/ucWork';


const routes: Routes =
  [
    { path: '', redirectTo: '/Works', pathMatch: 'full' },
    { path: 'Categories'   , component: TclCategorie},
    { path: 'Categorie'   , component: TcCategorie},
    { path: 'Developments'   , component: TclDevelopment},
    { path: 'Development'   , component: TcDevelopment},
    { path: 'Projects'   , component: TclProject},
    { path: 'Project'   , component: TcProject},
    { path: 'States'   , component: TclState},
    { path: 'State'   , component: TcState},
    { path: 'Tags'   , component: TclTag},
    { path: 'Tag'   , component: TcTag},
    { path: 'Tag_Developments'   , component: TclTag_Development},
    { path: 'Tag_Development'   , component: TcTag_Development},
    { path: 'Tag_Works'   , component: TclTag_Work},
    { path: 'Tag_Work'   , component: TcTag_Work},
    { path: 'Type_Tags'   , component: TclType_Tag},
    { path: 'Type_Tag'   , component: TcType_Tag},
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
