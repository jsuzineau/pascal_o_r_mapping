import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule     } from '@angular/forms';
import { HttpModule      } from '@angular/http';
import { HttpClientModule,
         HttpClientXsrfModule
                         } from '@angular/common/http';
import { RouterModule    } from '@angular/router';

import { AppComponent } from './component/app.component';
//APP_MODULE_TS_IMPORT_LIST
import { AppRoutingModule } from './app-routing.module';

@NgModule({
  declarations:
    [
    AppComponent,
    //APP_MODULE_TS_DECLARATIONS
    ],
  imports:
    [
    BrowserModule,
    FormsModule,
    HttpModule,
    HttpClientModule,
    HttpClientXsrfModule.disable(),
    AppRoutingModule
    ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
