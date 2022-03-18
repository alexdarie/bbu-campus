import { Component, OnInit } from '@angular/core';
import { BackendServerService } from 'src/app/services/backend-server.service';
import { LocalStorageService } from 'src/app/services/local-storage.service';
import { ToastController, Platform } from '@ionic/angular';

@Component({
  selector: 'app-notif',
  templateUrl: './notif.page.html',
  styleUrls: ['./notif.page.scss'],
})
export class NotifPage implements OnInit {

  notifications;

  constructor(
    private backend: BackendServerService,
    private localStorage: LocalStorageService,
    private platform: Platform
  ) {
    platform.ready().then(() => {
      if (platform.is('cordova')) {
        // App is put in background
        this.platform.pause.subscribe(() => {
          this.closeStream();
        });
        // App is put in foreground
        this.platform.resume.subscribe(() => {
          this.openStream();
        });
       }
    });
  }

  ngOnInit() {
    this.openStream();
    this.localStorage.at('notifications').then((res) => {
      this.notifications = res;
    });
  }

  openStream() {
    this.backend.ws.getDataStream().subscribe(
      (msg) => {
        msg = JSON.parse(msg.data);
        // console.log(msg);
        if (msg.notifications != null) {
          // console.log(msg.notifications);
          this.localStorage.at('notifications').then(
            (res) => {
              const listOfNotifications = res;
              for (const m of msg.notifications) {
                listOfNotifications.push(m);
              }
              this.localStorage.append('notifications', listOfNotifications);
              this.notifications = listOfNotifications;
            },
            (err) => {
              const listOfNotifications = [];
              for (const m of msg.notifications) {
                listOfNotifications.push(m);
              }
              this.localStorage.append('notifications', listOfNotifications);
              this.notifications = listOfNotifications;
            }
          );
        }
      }
    );
  }

  closeStream() {
    console.log('main.main: closeStream\n' +
      'Stop listening on port: ' + this.backend.portws);
    this.backend.ws.close(false);
  }

  removeItem(elem) {
    const index = this.notifications.indexOf(elem);
    this.notifications.splice(index, 1);
    this.localStorage.append('notifications', this.notifications);
  }

}
