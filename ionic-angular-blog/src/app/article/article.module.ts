import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

import { IonicModule } from '@ionic/angular';

import { ArticlePageRoutingModule } from './article-routing.module';

import { ArticlePage } from './article.page';
import { SafePipe } from '../safe.pipe';
import { HttpClientModule } from '@angular/common/http';
import { KeyvaluePipe } from '../keyvalue.pipe';

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    IonicModule,
    ArticlePageRoutingModule,
    HttpClientModule
  ],
  declarations: [ArticlePage, SafePipe, KeyvaluePipe]
})
export class ArticlePageModule {}
