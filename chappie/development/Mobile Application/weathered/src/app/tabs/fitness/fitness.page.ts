import { Component, OnInit } from '@angular/core';
import { ToastController, Platform } from '@ionic/angular';
import { HttpClient } from '@angular/common/http';
import { Network } from '@ionic-native/network/ngx';
import { LocalStorageService } from 'src/app/services/local-storage.service';
import { BackendServerService } from 'src/app/services/backend-server.service';
import { InAppBrowser } from '@ionic-native/in-app-browser/ngx';

@Component({
  selector: 'app-second',
  templateUrl: './fitness.page.html',
  styleUrls: ['./fitness.page.scss'],
})
export class FitnessPage implements OnInit {

  slideOpts = {
    initialSlide: 1,
    speed: 400
  };
  noInternetConn = false;

  currentAthlete: any;
  appKey;
  redirectURI;
  url;
  stravaCode;
  currentCode;
  currentSegment = 'this-year';

  topActivities = [
    {
      name: 'Night run',
      date: '25 May 2020',
      pressure: 9700, light: 12000, temperature: 15.5,
      label: 'Don\'t stop me now!',
      distance: 9000
    },
    {
      name: 'Night run',
      date: '25 May 2020',
      pressure: 9700, light: 12000, temperature: 15.5,
      label: 'Killing the pace',
      distance: 9000
    },
    {
      name: 'Night run',
      date: '25 May 2020',
      pressure: 9700, light: 12000, temperature: 15.5,
      label: 'Top elevation',
      distance: 9000
    }
  ];


  constructor(
    private http: HttpClient,
    private iab: InAppBrowser,
    private localStorage: LocalStorageService,
    private network: Network,
    private toast: ToastController,
    private backend: BackendServerService,
    private platform: Platform) {
      platform.ready().then(() => {
        if (platform.is('cordova')) {
          // App is put in background
          this.platform.pause.subscribe(() => {
            this.closeStream();
          });
          // App is brought in foreground
          this.platform.resume.subscribe(() => {
            this.openStream();
          });
         }
      });
      this.appKey = '44984';
      this.redirectURI = 'http://127.0.0.1:8100/tabs/tab2';
      this.url = 'https://www.strava.com/oauth/authorize?client_id=' + this.appKey
      + '&redirect_uri=' + this.redirectURI + '&response_type=code&approval_prompt=auto&scope=read,profile:read_all,activity:read';
  }

  ngOnInit() {
    // console.log(this.noInternetConn);
    this.openStream();
    this.currentAthlete = {
      firstname: '',
      lastname: '',
      country: '',
      city: '',
      state: '',
      stats: {
        _all_run_totals: {_distance: 0, _moving_time: 0, _count: 0, _elevation_gain: 0},
        _all_ride_totals: {_distance: 0, _moving_time: 0, _count: 0, _elevation_gain: 0},
        _biggest_ride_distance: 0,
        _biggest_climb_elevation_gain: 0,
        _ytd_run_totals: {_distance: 0, _moving_time: 0, _count: 0, _elevation_gain: 0},
        _ytd_ride_totals: {_distance: 0, _moving_time: 0, _count: 0, _elevation_gain: 0}
      }
    };
    this.localStorage.at('stravaAthlete').then((resp) => {
      if (resp != null) {
        this.currentAthlete = resp[0];
      }
    });

    // Actions organized on the network status:
    if (this.network.type === this.network.Connection.NONE) {
      this.noInternetConn = true;
    } else {
      const stravaAthletePromise = this.http.post(this.backend.URI + '/strava-user', null).toPromise();
      stravaAthletePromise.then((resp) => {
        this.currentAthlete = resp;
        this.currentAthlete.stats._all_run_totals._distance = Math.round(this.currentAthlete.stats._all_run_totals._distance / 1000);
        this.currentAthlete.stats._all_run_totals._moving_time = Math.round(this.currentAthlete.stats._all_run_totals._moving_time / 3600);
        this.currentAthlete.stats._all_ride_totals._distance = Math.round(this.currentAthlete.stats._all_ride_totals._distance / 1000);
        this.currentAthlete.stats._all_ride_totals._moving_time =
          Math.round(this.currentAthlete.stats._all_ride_totals._moving_time / 3600);
        this.currentAthlete.stats._ytd_ride_totals._distance = Math.round(this.currentAthlete.stats._ytd_ride_totals._distance / 1000);
        this.currentAthlete.stats._ytd_ride_totals._moving_time =
          Math.round(this.currentAthlete.stats._ytd_ride_totals._moving_time / 3600);
        this.currentAthlete.stats._ytd_run_totals._distance = Math.round(this.currentAthlete.stats._ytd_run_totals._distance / 1000);
        this.currentAthlete.stats._ytd_run_totals._moving_time = Math.round(this.currentAthlete.stats._ytd_run_totals._moving_time / 3600);
        this.currentAthlete.stats._biggest_ride_distance = Math.round(this.currentAthlete.stats._biggest_ride_distance / 1000);
        this.currentAthlete.stats._biggest_climb_elevation_gain = Math.round(this.currentAthlete.stats._biggest_climb_elevation_gain);
        this.localStorage.append('stravaAthlete', [this.currentAthlete]);
      });
    }

    // Watch network for a disconnection.
    const disconnectSubscription = this.network.onDisconnect().subscribe(() => {
      this.noInternetConn = true;
    });

    // Watch network for a connection.
    const connectSubscription = this.network.onConnect().subscribe(() => {
      setTimeout(() => {
        if (this.network.type === 'wifi') {
          this.noInternetConn = false;
        } else {
          this.noInternetConn = false;
        }
      }, 3000);
    });
  }

  public doRefresh(event) {

    // Actions per refresh
    if (this.network.type === this.network.Connection.NONE) {
      // No internet connection
      // this.presentOkToast('No internet connection.');
      event.target.complete();
    } else if (this.network.type === 'wifi') {
      // Over Wi-fi
      // this.localStorage.at('offline').then((offlineOrders) => {
      //   this.presentOkToast(offlineOrders);
      //   offlineOrders.forEach(element => {
      //     const pOrder = this.http.post(this.URI + '/order', element).toPromise();
      //     pOrder.then((resp) => {
      //       this.presentOkToast('Succesfully created.');
      //     })
      //     .catch((err) => {
      //       this.presentOkToast('Error while adding.');
      //     });
      //   });
      //   this.localStorage.append('offline', []);
      // });

      // const pBooks = this.http.get(this.URI + '/recorded').toPromise();
      // pBooks
      // .then((resp) => {
      //   this.items = resp as Order[];
      //   event.target.complete();
      // })
      // .catch((err) => {
      //   this.presentOkToast('Server down');
      //   event.target.complete();
      // });

    } else {

      // Over 4G
      // this.presentOkToast('Not connected to Local Area Network');
      event.target.complete();
    }
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

  ionViewWillEnter() {
    // this.localStorage.at('recorded').then((resp) => {
    //   this.items = resp as Order[];
    // });
  }

  ionViewWillLeave() {
  }

  openStream() {
    // this.presentOkToast('Listening on port: ' + this.backend.port);
    // this.ws.getDataStream().subscribe(
    //   (msg) => {
    //     this.presentOkToast('next');
    //     // msg = JSON.parse(msg.data);
    //     // this.items.push(msg);
    //     // this.localStorage.append(this.filter, this.items);
    //   },
    //   (msg) => {
    //       console.log('error', msg);
    //   },
    //   () => {
    //       console.log('complete');
    //   }
    // );
  }

  closeStream() {
    // this.presentOkToast('Stop listening on port: ' + this.backend.port);
    // this.ws.close(false);
  }

  stravaAccess() {
    if (this.network.type !== this.network.Connection.NONE) {
      this.doLogin().then((code) => {
        this.currentCode = code;
        this.stravaCode = code;
        this.localStorage.append('code', [code]);
        const promise = this.http.post('https://www.strava.com/api/v3/oauth/token?client_id=' + this.appKey +
            '&client_secret=cceb00d52819159ea4af338cd681ff0f730709ac&code=' + this.stravaCode +
            '&grant_type=authorization_code', null).toPromise();
        promise.then((resp) => {
          this.stravaCode = resp;
          this.presentOkToast('Sync Strava profile as ' + resp['athlete']['firstname'] + ' '
            + resp['athlete']['lastname']);
          const stravaAthletePromise = this.http.post(this.backend.URI + '/strava-user', resp).toPromise();
          stravaAthletePromise.then((resp) => {
            this.localStorage.append('stravaAthlete', [resp]);
            this.currentAthlete = resp;
            this.currentAthlete.stats._all_run_totals._distance = Math.round(this.currentAthlete.stats._all_run_totals._distance / 1000);
            this.currentAthlete.stats._all_run_totals._moving_time =
            Math.round(this.currentAthlete.stats._all_run_totals._moving_time / 3600);
            this.currentAthlete.stats._all_ride_totals._distance = Math.round(this.currentAthlete.stats._all_ride_totals._distance / 1000);
            this.currentAthlete.stats._all_ride_totals._moving_time =
            Math.round(this.currentAthlete.stats._all_ride_totals._moving_time / 3600);
            this.currentAthlete.stats._ytd_ride_totals._distance = Math.round(this.currentAthlete.stats._ytd_ride_totals._distance / 1000);
            this.currentAthlete.stats._ytd_ride_totals._moving_time =
            Math.round(this.currentAthlete.stats._ytd_ride_totals._moving_time / 3600);
            this.currentAthlete.stats._ytd_run_totals._distance = Math.round(this.currentAthlete.stats._ytd_run_totals._distance / 1000);
            this.currentAthlete.stats._ytd_run_totals._moving_time =
            Math.round(this.currentAthlete.stats._ytd_run_totals._moving_time / 3600);
            this.currentAthlete.stats._biggest_ride_distance = Math.round(this.currentAthlete.stats._biggest_ride_distance / 1000);
            this.currentAthlete.stats._biggest_climb_elevation_gain = Math.round(this.currentAthlete.stats._biggest_climb_elevation_gain);
          });
        },
        (err) => {
          this.presentOkToast('Sync Strava profile failed');
        });
      });
    } else {
      this.presentOkToast('No internet connection');
    }
    // this.doLogin();
  }

  // The login function
  doLogin() {
    return new Promise((resolve, reject) => {
      const browser = this.iab.create(this.url, '_blank', 'location=no');
      const listener = browser.on('loadstart').subscribe((event: any) => {

        // Avoid transition pages
        if ((event.url.indexOf('oauth/authorize') > -1) || (event.url.indexOf('oauth/accept_application') > -1)){
          return;
        }

        // On unauthorize
        if (event.url.indexOf('?state=&error=access_denied') > -1){
          browser.close();
          alert('You must authorize access to Strava in order to manage your equipment.');
          return;
        }

        // On authorization success
        if (event.url.indexOf(this.redirectURI) > -1 ){
          const token = event.url.split('&')[1].split('=')[1];
          listener.unsubscribe();
          browser.close();
          resolve(token);
        } else {
          reject('Could not authenticate');
        }
      });
    });
  }
}
