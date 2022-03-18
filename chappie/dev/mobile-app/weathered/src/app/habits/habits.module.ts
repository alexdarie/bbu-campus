import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

import { IonicModule } from '@ionic/angular';

import { HabitsPageRoutingModule } from './habits-routing.module';

import { HabitsPage } from './habits.page';
import { Ng2GoogleChartsModule } from 'ng2-google-charts';

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    IonicModule,
    HabitsPageRoutingModule,
    Ng2GoogleChartsModule
  ],
  declarations: [HabitsPage]
})
export class HabitsPageModule {}
