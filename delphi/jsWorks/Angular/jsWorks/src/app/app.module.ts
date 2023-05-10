import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule     } from '@angular/forms';
import { HttpModule      } from '@angular/http';
import { HttpClientModule,
         HttpClientXsrfModule
                         } from '@angular/common/http';
import { RouterModule    } from '@angular/router';
import { EditorModule } from '@tinymce/tinymce-angular';


import { AppComponent } from './component/app.component';
import { CustomComponent } from './component/custom.component';
import { Custom_Component_Works} from './01_Elements/Work/Custom_Component_Works';
import { Custom_Component_Work} from './01_Elements/Work/Custom_Component_Work';
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

import { AppRoutingModule } from './app-routing.module';

@NgModule({
  declarations:
    [
    AppComponent,
    CustomComponent,
    Custom_Component_Works,
    Custom_Component_Work,
    TclCategorie,
    TcCategorie,
    TclDevelopment,
    TcDevelopment,
    TclProject,
    TcProject,
    TclState,
    TcState,
    TclTag,
    TcTag,
    TclTag_Development,
    TcTag_Development,
    TclTag_Work,
    TcTag_Work,
    TclType_Tag,
    TcType_Tag,
    TclWork,
    TcWork,
    
    ],
  imports:
    [
    BrowserModule,
    FormsModule,
    HttpModule,
    HttpClientModule,
    HttpClientXsrfModule.disable(),
    AppRoutingModule,
    EditorModule
    ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
