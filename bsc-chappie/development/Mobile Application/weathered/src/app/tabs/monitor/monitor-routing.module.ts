import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { MonitorPage } from './monitor.page';

const routes: Routes = [
  {
    path: '',
    component: MonitorPage
  },
  {
    path: 'new-item',
    loadChildren: () => import('./pair/pair.module').then( m => m.PairPageModule)
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class MonitorPageRoutingModule {}
