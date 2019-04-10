import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule     } from '@angular/forms';
import { HttpModule      } from '@angular/http';
import { HttpClientModule,
         HttpClientXsrfModule
                         } from '@angular/common/http';
import { RouterModule    } from '@angular/router';

import { AppComponent } from './component/app.component';
import { TclProject} from './01_Elements/Project/uclProject';
import { TcProject} from './01_Elements/Project/ucProject';
import { TclWork} from './01_Elements/Work/uclWork';
import { TcWork} from './01_Elements/Work/ucWork';

import { AppRoutingModule } from './app-routing.module';

@NgModule({
  declarations:
    [
    AppComponent,
    TclProject,
    TcProject,
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
    AppRoutingModule
    ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
