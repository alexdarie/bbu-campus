import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { PairPage } from './pair.page';

const routes: Routes = [
  {
    path: '',
    component: PairPage
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class PairPageRoutingModule {}
