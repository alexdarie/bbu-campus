import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

import { IonicModule } from '@ionic/angular';

import { PairPageRoutingModule } from './pair-routing.module';

import { PairPage } from './pair.page';

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    IonicModule,
    PairPageRoutingModule
  ],
  declarations: [PairPage]
})
export class PairPageModule {}
