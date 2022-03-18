import { Injectable } from '@angular/core';
import { $WebSocket } from 'angular2-websocket/angular2-websocket';

@Injectable({
  providedIn: 'root'
})
export class BackendServerService {

  porthttp = 4001;
  portws = 4000;

  mywsIPOverNetwork = '161.35.76.247';
  myhttpIPOverNetwork = '161.35.76.247';
  // myhttpIPOverNetwork = 'localhost';

  URI = 'http://' + this.myhttpIPOverNetwork + ':' + this.porthttp;
  ws = new $WebSocket('ws://' + this.mywsIPOverNetwork + ':' + this.portws);

  subscription = null;
  constructor() {}
}
