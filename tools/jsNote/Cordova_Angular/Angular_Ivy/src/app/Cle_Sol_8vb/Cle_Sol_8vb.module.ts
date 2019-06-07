import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';

import { Cle_Sol_8vbPage } from './Cle_Sol_8vb.page';

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    RouterModule.forChild([
      {
        path: '',
        component: Cle_Sol_8vbPage
      }
    ])
  ],
  declarations: [Cle_Sol_8vbPage]
})
export class Cle_Sol_8vbPageModule {}
