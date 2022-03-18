import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { ToastController } from '@ionic/angular';
import { Router } from '@angular/router';
import { BackendServerService } from '../../../services/backend-server.service';
import { LocalStorageService } from 'src/app/services/local-storage.service';
import { Network } from '@ionic-native/network/ngx';
import { PopoverController } from '@ionic/angular';

@Component({
  selector: 'app-new-item',
  templateUrl: './pair.page.html',
  styleUrls: ['./pair.page.scss'],
})
export class PairPage implements OnInit {

  showProgressBar = false;
  URI = this.backend.URI;
  ws = this.backend.ws;

  currentlyConnected = [{name: 'Chappie', location: '', serialNumber: 1}];
  previouslyConnected = [];
  inputSerialNumber = 0;

  constructor(
    private http: HttpClient,
    private router: Router,
    private toast: ToastController,
    private backend: BackendServerService,
    private localStorage: LocalStorageService,
    private network: Network,
    public popoverController: PopoverController) {
  }

  ngOnInit() {
    this.localStorage.at('previouslyConnected').then((resp) => {
      if (resp != null) {
        this.previouslyConnected = resp;
      }
    });
    this.localStorage.at('currentlyConnected').then((resp) => {
      if (resp != null) {
        this.currentlyConnected = resp;
      }
    });
  }

  onCreate() {
    console.log('main.new-item: onCreate');
    this.showProgressBar = true;

    // if (this.network.type === this.network.Connection.NONE) {
    //   this.localStorage.at('offline').then((offlineOrders) => {
    //     let foo = offlineOrders as Order[];
    //     if (foo == null) {
    //       foo = [];
    //     } else {
    //       foo.push(this.canvasItem);
    //     }
    //     this.localStorage.append('offline', foo);
    //   });
    //   this.presentOkToast('Stored offline.');
    //   this.router.navigate(['/tabs/tab1']);
    // } else {
    //   setTimeout(() => {
    //     const pBook = this.http.post(this.URI + '/order', this.canvasItem).toPromise();
    //     pBook.then((resp) => {
    //       this.presentOkToast('Succesfully created.');
    //       this.router.navigate(['/tabs/tab1']);
    //     })
    //     .catch((err) => {
    //       this.presentOkToast('Error while adding.');
    //       this.router.navigate(['/tabs/tab1']);
    //     });
    //   }, 1000);
    // }
  }

  presentOkToast(myMessage: string) {
    this.toast.create({
      message: myMessage,
      duration: 2000,
      buttons: [
        {
          text: 'Ok',
          role: 'cancel'
        }
      ]
    }).then(t => { t.present(); });
  }

  unpair() {
    this.backend.ws.send(JSON.stringify({emit: false})).subscribe(
      (msg) => {
          console.log('next', msg.data);
      },
      (msg) => {
          console.log('error', msg);
      },
      () => {
          console.log('complete');
          const toUnpair = this.currentlyConnected[0];
          this.currentlyConnected.splice(0, 1);
          this.previouslyConnected.push(toUnpair);
          this.localStorage.append('currentlyConnected', this.currentlyConnected);
          this.localStorage.append('previouslyConnected', this.previouslyConnected);
          this.localStorage.append('paired', [false]);
      }
    );
  }

  pair() {
    if (this.currentlyConnected.length > 0 && this.inputSerialNumber == this.currentlyConnected[0].serialNumber) {
      this.presentOkToast('Device already paired');
    } else if (this.inputSerialNumber != null && this.inputSerialNumber == 1) {
      this.backend.ws.send(JSON.stringify({emit: true})).subscribe(
        (msg) => {
          console.log('next', msg.data);
        },
        (msg) => {
          console.log('error', msg);
        },
        () => {
          console.log('complete');
          let index = -1;
          for (const device of this.previouslyConnected) {
            if (device.serialNumber == this.inputSerialNumber) {
              index = this.previouslyConnected.indexOf(device);
            }
          }
          if (index >= 0) {
            const toPair = this.previouslyConnected[index];
            this.previouslyConnected.splice(index, 1);
            this.currentlyConnected.push(toPair);
          } else {
            this.currentlyConnected.push({name: 'Chappie', location: '', serialNumber: this.inputSerialNumber});
          }
          this.localStorage.append('currentlyConnected', this.currentlyConnected);
          this.localStorage.append('previouslyConnected', this.previouslyConnected);
          this.localStorage.append('paired', [true]);
        }
      );
    } else {
      this.presentOkToast("Invalid serial number")
    }
  }
}
