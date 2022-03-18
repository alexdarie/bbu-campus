import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { TabsPage } from './tabs.page';

const routes: Routes = [
  {
    path: 'tabs',
    component: TabsPage,
    children: [
      {
        path: 'home',
        children: [
          {
            path: '',
            loadChildren: () => import('../habits/habits.module').then( m => m.HabitsPageModule)
          },
          {
            path: 'notif',
            loadChildren: () => import('../habits/notif/notif.module').then( m => m.NotifPageModule)
          }
        ]
      },
      {
        path: 'tab1',
        children: [
          {
            path: '',
            loadChildren: () => import('./monitor/monitor.module').then( m => m.MonitorPageModule)
          },
          {
            path: 'new',
            loadChildren: () => import('./monitor/pair/pair.module').then( m => m.PairPageModule)
          }
        ]
      },
      {
        path: 'tab2',
        children: [
          {
            path: '',
            loadChildren: () => import('./fitness/fitness.module').then( m => m.FitnessPageModule)
          }
        ]
      }
    ]
  },
  {
    path: '',
    redirectTo: '/tabs/tab1',
    pathMatch: 'full'
  },
  {
    path: 'second',
    loadChildren: () => import('./fitness/fitness.module').then( m => m.FitnessPageModule)
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class TabsPageRoutingModule {}
