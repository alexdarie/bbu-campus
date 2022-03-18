import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { HabitsPage } from './habits.page';

const routes: Routes = [
  {
    path: '',
    component: HabitsPage
  },
  {
    path: 'notif',
    loadChildren: () => import('./notif/notif.module').then( m => m.NotifPageModule)
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class HabitsPageRoutingModule {}
