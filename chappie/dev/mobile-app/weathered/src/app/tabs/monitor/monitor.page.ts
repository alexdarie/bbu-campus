import { Component, OnInit } from '@angular/core';
import { ToastController, Platform } from '@ionic/angular';
import { HttpClient } from '@angular/common/http';
import { Network } from '@ionic-native/network/ngx';
import { LocalStorageService } from 'src/app/services/local-storage.service';
import { BackendServerService } from 'src/app/services/backend-server.service';
import { GoogleChartInterface } from 'ng2-google-charts';
import { AlertController } from '@ionic/angular';


@Component({
  selector: 'app-main',
  templateUrl: './monitor.page.html',
  styleUrls: ['./monitor.page.scss'],
})
export class MonitorPage implements OnInit {
  curentlySelectedMeasurement = 'temp';
  chart: GoogleChartInterface = {
    chartType: 'LineChart',
    dataTable: [
      ['Hour', 'Value'],
      ['0', 0]
    ],
    options: {
      curveType: 'function',
      legend: 'none'
    },
  };
  noInternetConn = false;
  unpairedDevice = false;

  measurement = {
    temp: {
      name: 'Ambient temperature',
      value: null,
      unit: 'Celsius',
      chart: {
        chartType: 'LineChart',
        dataTable: [
          ['Hour', 'Value'],
          ['0', 0]
        ],
        options: {
          curveType: 'function',
          legend: {
            position: 'top'
          },
          tooltip: {
            pivot: {
              x: -50,
              y: 80
            },
            isHtml: true
          },
          series: {
            0: { color: '#022F40' },
            1: { color: '#022F40' }
          }
        },
      },
      settings: [
        {
          icon: 'eye',
          title: 'Celsius',
          description: 'Ambiental temperature',
          code: 1,
        },
        {
          icon: 'eye-off',
          title: 'Silent',
          description: 'Display will be turned off',
          code: 5
        }
    ]},
    aprs: {
      name: 'Ambient air pressure',
      value: null,
      unit: 'hPa',
      chart: {
        chartType: 'LineChart',
        dataTable: [
          ['Hour', 'Value'],
          ['0', 0]
        ],
        options: {
          curveType: 'function',
          legend: {
            position: 'top'
          },
          tooltip: {
            pivot: {
              x: -50,
              y: 80
            },
            isHtml: true
          },
          series: {
            0: { color: '#022F40' },
            1: { color: '#022F40' }
          }
        },
      },
      settings: [
      {
        icon: 'eye',
        title: 'hPa',
        description: 'Air pressure',
        code: 2
      },
      {
        icon: 'eye-off',
        title: 'Silent',
        description: 'Display will be turned off',
        code: 5
      }
    ]},
    lght: {
      name: 'Ambient light',
      value: null,
      unit: 'Lumens',
      chart: {
        chartType: 'LineChart',
        dataTable: [
          ['Hour', 'Value'],
          ['0', 0]
        ],
        options: {
          curveType: 'function',
          legend: {
            position: 'top'
          },
          tooltip: {
            pivot: {
              x: -50,
              y: 80
            },
            isHtml: true
          },
          series: {
            0: { color: '#022F40' },
            1: { color: '#022F40' }
          }
        },
      },
      settings: [
      {
        icon: 'eye',
        title: 'Lumens',
        description: 'Ambietal light intensity',
        code: 3
      },
      {
        icon: 'eye-off',
        title: 'Silent',
        description: 'Display will be turned off',
        code: 5
      }
    ]},
    colr: {
      name: 'Ambient color',
      value: 'black',
      unit: 'Common color',
      chart: {
        chartType: 'ColumnChart',
        dataTable: [
          ['Value', 'Density', { role: 'style' }],
          ['Red',  0, '#eb4034'],
          ['Green', 0, '#eb4034'],
          ['Blue',  0, '#eb4034'],
          ['Clear', 0, 'gray'],
        ],
        options: {
          legend: 'none',
          series: {
            0: { color: '#46b4b3' },
            1: { color: '#022F40' }
          }
        },
      },
      settings: [
      {
        icon: 'eye',
        title: 'RGB',
        description: 'Ambiental color',
        code: 4
      },
      {
        icon: 'eye-off',
        title: 'Silent',
        description: 'Display will be turned off',
        code: 5
      }
    ]},
    all: {
      name: 'Normalized values',
      value: '_',
      unit: 'last update',
      chart: {
        chartType: 'LineChart',
        dataTable: [
          ['Hour', 'Temperature', 'Light', 'Pressure'],
          ['0', 0, 0, 0]
        ],
        options: {
          curveType: 'function',
          legend: {
            position: 'top'
          },
          series: {
            0: { color: '#46b4b3' },
            1: { color: '#022F40' }
          },
          tooltip: {
            pivot: {
              x: -50,
              y: 80
            },
            isHtml: true
          },
          vAxis: {
            viewWindowMode: 'explicit',
            viewWindow: {
              max: 1.5,
              min: -0.5
            }
          }
        },
      },
      settings: [
      {
        icon: 'eye',
        title: 'Alternative',
        description: 'Alternattive view',
        code: 0
      },
      {
        icon: 'eye-off',
        title: 'Silent',
        description: 'Display will be turned off',
        code: 5
      }
    ]}
  };
  measurementName = this.measurement.temp.name;
  measurementValue = this.measurement.temp.value;
  measurementUnit = this.measurement.temp.unit;
  measurementDisplayFaces = this.measurement.temp;
  currentDisplay = this.measurement.temp.settings[0].title;
  savedDisplay = [];

  temperature = [];
  light = [];
  airPressure = [];
  allValues = [];

  URI = this.backend.URI;
  ws = this.backend.ws;

  constructor(
    private http: HttpClient,
    private localStorage: LocalStorageService,
    private network: Network,
    private toast: ToastController,
    private backend: BackendServerService,
    private platform: Platform,
    public alertController: AlertController) {
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

      const weatherChart = this.http.get(this.URI + '/weather-graph').toPromise();
      weatherChart.then((resp) => {
        let minTemperature = 100, maxTemperature = -100;
        let minLight = 1000000, maxLight = -100;
        let minPressure = 10000000, maxPressure = -100;

        this.temperature = [['Hour', 'Value']];
        this.light = [['Hour', 'Value']];
        this.airPressure = [['Hour', 'Value']];
        this.allValues = [['Hour', 'Temperature', 'Light', 'Pressure']];

        for (const event of resp['data']) {
          const time = new Date(event['event_time']).toISOString().substring(11, 16);
          this.temperature.push([time, event['temperature']]);
          this.light.push([time, event['light']]);
          this.airPressure.push([time, event['air_pressure']]);
          if (event['temperature'] > maxTemperature) {
            maxTemperature = event['temperature'];
          }
          if (event['light'] > maxLight) {
            maxLight = event['light'];
          }
          if (event['air_pressure'] > maxPressure) {
            maxPressure = event['air_pressure'];
          }
          if (event['temperature'] < minTemperature) {
            minTemperature = event['temperature'];
          }
          if (event['light'] < minLight) {
            minLight = event['light'];
          }
          if (event['air_pressure'] < minPressure) {
            minPressure = event['air_pressure'];
          }
        }
        for (const event of resp['data']) {
          const time = new Date(event['event_time']).toISOString().substring(11, 16);
          this.allValues.push(
            [
              time,
              (event['temperature'] - minTemperature) / (maxTemperature - minTemperature),
              (event['light'] - minLight) / (maxLight - minLight),
              (event['air_pressure'] - minPressure) / (maxPressure - minPressure)
            ]
          );
        }
        this.measurement.temp.chart.dataTable = this.temperature;
        this.measurement.aprs.chart.dataTable = this.airPressure;
        this.measurement.lght.chart.dataTable = this.light;
        this.measurement.all.chart.dataTable = this.allValues;
        this.measurement.all.value = this.allValues[this.allValues.length - 1][0];
        this.chart.dataTable = this.measurement[this.curentlySelectedMeasurement].chart.dataTable;
        this.chart.chartType = this.measurement[this.curentlySelectedMeasurement].chart.chartType;
        this.chart.options = this.measurement[this.curentlySelectedMeasurement].chart.options;
        this.chart.component.draw();
      });
  }

  ngOnInit() {
    console.log('main.main: ngOnInit');

    this.openStream();

    this.localStorage.at('paired').then((res) => {
      this.unpairedDevice = !res[0];
    });

    this.localStorage.at('savedDisplay').then((resp) => {
      if (resp != null) {
        this.savedDisplay = resp;
        this.currentDisplay = resp[0][0];
      } else {
        this.savedDisplay = [this.measurement.temp.settings[0].title, this.measurement.temp.settings[0].code];
      }
    });

    // Actions organized on the network status:
    if (this.network.type === this.network.Connection.NONE) {
      this.presentAlert();
      this.noInternetConn = true;
      this.unpairedDevice = true;
    } else {
      this.noInternetConn = false;
      this.unpairedDevice = false;
    }

    // Watch network for a disconnection.
    const disconnectSubscription = this.network.onDisconnect().subscribe(() => {
      this.noInternetConn = true;
      this.unpairedDevice = true;
    });

    // Watch network for a connection.
    const connectSubscription = this.network.onConnect().subscribe(() => {
      setTimeout(() => {
        if (this.network.type === 'wifi') {
          this.noInternetConn = false;
          this.unpairedDevice = false;
        } else {
          this.noInternetConn = false;
          this.unpairedDevice = false;
        }
      }, 3000);
    });
  }

  public doRefresh(event) {

    console.log('main.main: doRefresh');

    // Actions per refresh
    if (this.network.type === this.network.Connection.NONE) {

      // No internet connection
      this.presentOkToast('No internet connection.');
      event.target.complete();
    } else if (this.network.type === 'wifi') {

      // Over Wi-fi
      // const pBooks = this.http.get(this.URI + '/orders').toPromise();
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
      this.presentOkToast('Not connected to Local Area Network');
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
    // this.localStorage.get().then((resp) => {
    //   this.items = resp as Order[];
    // });
  }

  ionViewWillLeave() {
  }

  openStream() {
    // this.presentOkToast('Listening on port: ' + this.backend.port);
    this.ws.getDataStream().subscribe(
      (msg) => {
        msg = JSON.parse(msg.data);
        console.log(msg);
        if (msg.temperature != null) {
          this.measurement.temp.value = msg.temperature;
          this.measurement.aprs.value = msg.air_pressure;
          this.measurement.lght.value = msg.light;
          this.measurementValue = this.measurement[this.curentlySelectedMeasurement].value;
          this.measurement.colr.value = 'rgb(' + msg.color.red + ', ' + msg.color.green +  ', ' + msg.color.blue + ')';
          this.measurement.colr.chart.dataTable = [
            ['Value', 'Density', { role: 'style' }],
            ['Red',  msg.color.red, 'lightgray'],
            ['Green', msg.color.green, 'lightgray'],
            ['Blue',  msg.color.blue, 'lightgray'],
            ['Clear', msg.color.clear, 'lightgray'],
          ];
          if (this.curentlySelectedMeasurement === 'colr') {
            this.chart.dataTable = this.measurement.colr.chart.dataTable;
            this.chart.chartType = this.measurement.colr.chart.chartType;
            this.chart.options = this.measurement.colr.chart.options;
            this.chart.component.draw();
          }
        }
        if (msg.emit != null) {
          this.localStorage.at('paired').then((res) => {
            this.unpairedDevice = !res[0];
          });
          if (msg.emit === false) {
            this.sleep(2000).then((r) => {
              this.measurement.temp.value = null;
              this.measurement.aprs.value = null;
              this.measurement.lght.value = null;
              this.measurement.colr.value = 'rgb(0, 0, 0)';
              this.measurementValue = this.measurement[this.curentlySelectedMeasurement].value;
            });
          } else {
            this.localStorage.at('savedDisplayCode').then((code) =>
            this.backend.ws.send(JSON.stringify({displayCode: code[0]})).subscribe(
              (msg) => {
                  console.log('next', msg.data);
                  this.localStorage.at('savedDisplay').then((saved) => {
                    this.currentDisplay = saved[0];
                  });
              },
              (msg) => {
                  console.log('error', msg);
                  if (msg.includes('Socket connection has been closed')) {
                    this.presentOkToast('Weather device cannot be reached');
                  } else {
                    this.presentOkToast('Cannot connect to weather device');
                  }
              },
              () => {
                  console.log('complete');
              }
            ));
          }
        }
      },
      (msg) => {
        console.log('main.main: openStream: complete');
      },
      () => {
        this.presentAlert();
        this.noInternetConn = true;
        console.log('main.main: openStream: error');
      }
    );
  }

  closeStream() {
    console.log('main.main: closeStream');
    //this.presentOkToast('Stop listening on port: ' + this.backend.portws);
    this.ws.close(false);
  }

  changeMeasurement(x) {
    this.curentlySelectedMeasurement = x;
    this.measurementName = this.measurement[x].name;
    this.measurementValue = this.measurement[x].value;
    this.measurementUnit = this.measurement[x].unit;
    this.measurementDisplayFaces = this.measurement[x];
    this.chart.dataTable = this.measurement[x].chart.dataTable;
    this.chart.chartType = this.measurement[x].chart.chartType;
    this.chart.options = this.measurement[x].chart.options;
    this.chart.component.draw();
    console.log(this.savedDisplay[0]);
    this.currentDisplay = this.savedDisplay[0][0].toString();
  }

  saveDisplayOption(title, code) {
    this.savedDisplay = [title, code];
    this.localStorage.append('savedDisplay', [this.savedDisplay]);
    this.localStorage.append('savedDisplayCode', [code]);
    this.backend.ws.send(JSON.stringify({displayCode: code})).subscribe(
      (msg) => {
          console.log('next', msg.data);
      },
      (msg) => {
          console.log('error', msg);
          if (msg.includes('Socket connection has been closed')) {
            this.presentOkToast('Weather device cannot be reached');
          } else {
            this.presentOkToast('Cannot connect to weather device');
          }
      },
      () => {
          console.log('complete');
      }
    );
  }

  async presentAlert() {
    const alert = await this.alertController.create({
      cssClass: 'my-custom-class',
      header: 'Cloud',
      subHeader: 'Unstable internet connection',
      message: 'The cloud seems to be uncertain, so you should go the hard way for now and run like our ancestors, without predictions.',
      buttons: ['Okay']
    });

    await alert.present();
  }

  sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

}
