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
//Angular_TypeScript_APP_MODULE_TS_IMPORT_LIST
import { AppRoutingModule } from './app-routing.module';

@NgModule({
  declarations:
    [
    AppComponent,
    CustomComponent,
    Custom_Component_Works,
    Custom_Component_Work,
    //Angular_TypeScript_APP_MODULE_TS_DECLARATIONS
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
