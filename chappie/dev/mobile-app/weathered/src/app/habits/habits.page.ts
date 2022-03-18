import { Component, OnInit, ViewChild } from '@angular/core';
import { ActionSheetController } from '@ionic/angular';
import { HttpClient } from '@angular/common/http';
import { GoogleChartInterface } from 'ng2-google-charts';
import { ToastController, Platform } from '@ionic/angular';
import { BackendServerService } from 'src/app/services/backend-server.service';
import { AlertController } from '@ionic/angular';
import { Network } from '@ionic-native/network/ngx';

@Component({
  selector: 'app-home',
  templateUrl: './habits.page.html',
  styleUrls: ['./habits.page.scss'],
})
export class HabitsPage implements OnInit {

  @ViewChild('barChart', {static: false}) barChart;

  hashtagToday = new Date().toLocaleString().substring(0, 9);
  predictedActivity = null;
  currentLastActivityType = 'Run';
  predictedDuration = null;
  predictedHabitTemperature;
  predictedHabitPressure;
  predictedHabitLight;
  noLastActivities = 0;
  temperatureBoundaries = null;
  lightBoundaries = null;
  airPressureBoundaries = null;
  gridShowSpinner = false;
  noPrevWeeks = 3;
  comparisonGraphShowLoading = true;
  failedToLoadHabitGraphs = false;
  habitsGraphsShowLoading = true;
  failedToLoadTheGraph = false;
  prevWeeksShowSpinner = true;
  notificationIcon = 'notifications-outline';

  currentSegment = 'live';
  slideOpts = {
    initialSlide: 0,
    speed: 400
  };
  lastActivities;
  ws = this.backend.ws;

  runningDistancePredictionChart: GoogleChartInterface = {
    chartType: 'SteppedAreaChart',
    dataTable: [
      ['Hour', 'Distance prediction'],
      [ 0, 0],
    ],
    options: {
      title: '',
      hAxis: {title: ''},
      vAxis: {title: ''},
      legend: 'none',
      series: {
        0: { color: '#46b4b3' },
        1: { color: '#46b4b3' }
      },
      tooltip: {
        pivot: {
          x: -50,
          y: 80
        },
        isHtml: true
      }
    },
  };

  ridingDistancePredictionChart: GoogleChartInterface = {
    chartType: 'SteppedAreaChart',
    dataTable: [
      ['Hour', 'Distance prediction'],
      [ 0, 0],
    ],
    options: {
      title: '',
      hAxis: {title: ''},
      vAxis: {title: ''},
      legend: 'none',
      series: {
        0: { color: '#46b4b3' },
        1: { color: '#46b4b3' }
      },
      tooltip: {
        pivot: {
          x: -50,
          y: 80
        },
        isHtml: true
      }
    },
  };

  availabilityChart: GoogleChartInterface = {
    chartType: 'SteppedAreaChart',
    dataTable: [
      ['Day', 'Percent'],
      [ 'Monday', 0],
      [ 'Tuesday', 0],
      [ 'Wednesday', 0],
      [ 'Thursday', 0],
      [ 'Friday', 0],
      [ 'Saturday', 0],
      [ 'Sunday', 0]
    ],
    options: {
      title: '',
      hAxis: {title: '', minValue: 0, maxValue: 15},
      vAxis: {title: '', minValue: 0, maxValue: 15},
      legend: 'none',
      series: {
        0: { color: '#46b4b3' },
        1: { color: '#46b4b3' }
      },
      tooltip: {
        pivot: {
          x: -50,
          y: 80
        },
        isHtml: true
      }
    },
  };

  weatherComparisonChart: GoogleChartInterface = {
    chartType: 'ColumnChart',
    dataTable: [
      ['Tag', 'Value', { role: 'style' } ],
      ['Ideal light', 0, 'color: #1d3557'],
      ['Actual light', 0, 'color: #1d3557; opacity: 0.2'],
      ['Ideal pressure', 0, 'color: #f4a261'],
      ['Actual pressure', 0, 'color: #f4a261; opacity: 0.2'],
      ['Ideal tempr.', 0, 'color: #46b4b3'],
      ['Actual tempr.', 0, 'opacity: 0.2'],
    ],
    options: {
      title: '',
      hAxis: {title: '', minValue: -0.5, maxValue: 1.5},
      vAxis: {title: '', minValue: -0.5, maxValue: 1.5},
      height: 400,
      tooltip: {
        pivot: {
          x: -50,
          y: 80
        },
        isHtml: true
      },
      legend: 'none',
      series: {
        0: { color: '#46b4b3' },
        1: { color: '#e7711b' }
      }
    },
  };

  seasons = [
    {
      name: 'Spring',
      months: [
        {name: 'March', count: 0, distance: 0, temperature: 0, pressure: 0, light: 0, moving_time: 0},
        {name: 'April', count: 0, distance: 0, temperature: 0, pressure: 0, light: 0, moving_time: 0},
        {name: 'May', count: 0, distance: 0, temperature: 0, pressure: 0, light: 0, moving_time: 0}
      ],
      pressure: 0, light: 0, temperature: 0,
      image: '../../../assets/icon/spring.jpg',
      season_color: '#9e97dc'
    },
    {
      name: 'Summer',
      months: [
        {name: 'June', count: 0, distance: 0, temperature: 0, pressure: 0, light: 0, moving_time: 0},
        {name: 'July', count: 0, distance: 0, temperature: 0, pressure: 0, light: 0, moving_time: 0},
        {name: 'August', count: 0, distance: 0, temperature: 0, pressure: 0, light: 0, moving_time: 0}
      ],
      pressure: 0, light: 0, temperature: 0,
      image: '../../../assets/icon/summer.jpg',
      season_color: '#6a8dec'
    },
    {
      name: 'Autumn',
      months: [
        {name: 'September', count: 0, distance: 0, temperature: 0, pressure: 0, light: 0, moving_time: 0},
        {name: 'October', count: 0, distance: 0, temperature: 0, pressure: 0, light: 0, moving_time: 0},
        {name: 'November', count: 0, distance: 0, temperature: 0, pressure: 0, light: 0, moving_time: 0}
      ],
      pressure: 0, light: 0, temperature: 0,
      image: '../../../assets/icon/autumn.jpg',
      season_color: '#a6aca0'
    },
    {
      name: 'Winter',
      months: [
        {name: 'December', count: 0, distance: 0, temperature: 0, pressure: 0, light: 0, moving_time: 0},
        {name: 'January', count: 0, distance: 0, temperature: 0, pressure: 0, light: 0, moving_time: 0},
        {name: 'February', count: 0, distance: 0, temperature: 0, pressure: 0, light: 0, moving_time: 0}
      ],
      pressure: 0, light: 0, temperature: 0,
      image: '../../../assets/icon/winter.jpg',
      season_color: '#93c1e7'
    },
  ];

  timeIntervalOptions = [
    {
      key: '1-week',
      value: 1
    },
    {
      key: '3-week',
      value: 3
    },
    {
      key: '1-month',
      value: 6
    },
    {
      key: '3-month',
      value: 12
    },
    {
      key: '6-month',
      value: 24
    },
    {
      key: '1-year',
      value: 52
    },
    {
      key: '2-year',
      value: 104
    }
  ];

  previousWeeks = [];

  constructor(
    public actionSheetController: ActionSheetController,
    private http: HttpClient,
    private platform: Platform,
    private network: Network,
    private toast: ToastController,
    private backend: BackendServerService,
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
  }

  ngOnInit() {
    this.openStream();

    const temperaturePrediction = this.http.get(this.backend.URI + '/weather-habits/temperature').toPromise();
    temperaturePrediction.then((resp) => {
      this.predictedHabitTemperature = resp;
    });

    const lightPrediction = this.http.get(this.backend.URI + '/weather-habits/light').toPromise();
    lightPrediction.then((resp) => {
      this.predictedHabitLight = resp;
    });

    const airPressurePrediction = this.http.get(this.backend.URI + '/weather-habits/air-pressure').toPromise();
    airPressurePrediction.then((resp) => {
      this.predictedHabitPressure = resp;
    });

    const runningLastActivities = this.http.get(this.backend.URI + '/recent-activities/run').toPromise();
    runningLastActivities.then((resp) => {
      this.gridShowSpinner = true;
      this.lastActivities = resp['activities'];
      for (let activity of this.lastActivities) {
        activity['start_date'] = new Date(activity['start_date']).toLocaleString();
      }
      this.noLastActivities = this.lastActivities.length;
      this.currentLastActivityType = 'Run';
      this.gridShowSpinner = false;
    });

    const seasons = this.http.get(this.backend.URI + '/seasons').toPromise();
    seasons.then((resp) => {
      const seasons = resp['seasons'];
      this.seasons[0]['months'] =
      [
        {name: 'March', count: seasons[2]['count'], distance: seasons[2]['distance'],
          temperature: seasons[2]['temperature'], pressure: seasons[2]['air_pressure'],
          light: seasons[2]['light'], moving_time: seasons[2]['moving_time']},
        {name: 'April', count: seasons[3]['count'], distance: seasons[3]['distance'],
          temperature: seasons[3]['temperature'], pressure: seasons[3]['air_pressure'],
          light: seasons[3]['light'], moving_time: seasons[3]['moving_time']},
        {name: 'May', count: seasons[4]['count'], distance: seasons[4]['distance'],
          temperature: seasons[4]['temperature'], pressure: seasons[4]['air_pressure'],
          light: seasons[4]['light'], moving_time: seasons[4]['moving_time']},
      ];
      this.seasons[0]['temperature'] =
        (seasons[2]['temperature'] + seasons[3]['temperature'] + seasons[4]['temperature']) / 3;
      this.seasons[0]['light'] =
        (seasons[2]['light'] + seasons[3]['light'] + seasons[4]['light']) / 3;
      this.seasons[0]['pressure'] =
        (seasons[2]['air_pressure'] + seasons[3]['air_pressure'] + seasons[4]['air_pressure']) / 3;
      this.seasons[1]['months'] =
      [
        {name: 'June', count: seasons[5]['count'], distance: seasons[5]['distance'],
          temperature: seasons[5]['temperature'], pressure: seasons[5]['air_pressure'],
          light: seasons[5]['light'], moving_time: seasons[5]['moving_time']},
        {name: 'July', count: seasons[6]['count'], distance: seasons[6]['distance'],
          temperature: seasons[6]['temperature'], pressure: seasons[6]['air_pressure'],
          light: seasons[6]['light'], moving_time: seasons[6]['moving_time']},
        {name: 'August', count: seasons[7]['count'], distance: seasons[7]['distance'],
          temperature: seasons[7]['temperature'], pressure: seasons[7]['air_pressure'],
          light: seasons[7]['light'], moving_time: seasons[7]['moving_time']}
      ];
      this.seasons[1]['temperature'] =
        (seasons[5]['temperature'] + seasons[6]['temperature'] + seasons[7]['temperature']) / 3;
      this.seasons[1]['light'] =
        (seasons[5]['light'] + seasons[6]['light'] + seasons[7]['light']) / 3;
      this.seasons[1]['pressure'] =
        (seasons[5]['air_pressure'] + seasons[6]['air_pressure'] + seasons[7]['air_pressure']) / 3;
      this.seasons[2]['months'] = [
        {name: 'September', count: seasons[8]['count'], distance: seasons[8]['distance'],
          temperature: seasons[8]['temperature'], pressure: seasons[8]['air_pressure'],
          light: seasons[8]['light'], moving_time: seasons[8]['moving_time']},
        {name: 'October', count: seasons[9]['count'], distance: seasons[9]['distance'],
          temperature: seasons[9]['temperature'], pressure: seasons[9]['air_pressure'],
          light: seasons[9]['light'], moving_time: seasons[9]['moving_time']},
        {name: 'November', count: seasons[10]['count'], distance: seasons[10]['distance'],
          temperature: seasons[10]['temperature'], pressure: seasons[10]['air_pressure'],
          light: seasons[10]['light'], moving_time: seasons[10]['moving_time']}
      ];
      this.seasons[2]['temperature'] =
        (seasons[8]['temperature'] + seasons[9]['temperature'] + seasons[10]['temperature']) / 3;
      this.seasons[2]['light'] =
        (seasons[8]['light'] + seasons[9]['light'] + seasons[10]['light']) / 3;
      this.seasons[2]['pressure'] =
        (seasons[8]['air_pressure'] + seasons[9]['air_pressure'] + seasons[10]['air_pressure']) / 3;
      this.seasons[3]['months'] =
      [
        {
          name: 'December', count: seasons[11]['count'], distance: seasons[11].distance,
          temperature: seasons[11]['temperature'], pressure: seasons[11]['air_pressure'],
          light: seasons[11]['light'], moving_time: seasons[11]['moving_time']
        },
        {
          name: 'January', count: seasons[0]['count'], distance: seasons[0]['distance'],
          temperature: seasons[0]['temperature'], pressure: seasons[0]['air_pressure'],
          light: seasons[0]['light'], moving_time: seasons[0]['moving_time']
        },
        {
          name: 'February', count: seasons[1]['count'], distance: seasons[1]['distance'],
          temperature: seasons[1]['temperature'], pressure: seasons[1]['air_pressure'],
          light: seasons[1]['light'], moving_time: seasons[1]['moving_time']
        }
      ];
      this.seasons[3]['temperature'] =
        (seasons[11]['temperature'] + seasons[0]['temperature'] + seasons[1]['temperature']) / 3;
      this.seasons[3]['light'] =
        (seasons[11]['light'] + seasons[0]['light'] + seasons[1]['light']) / 3;
      this.seasons[3]['pressure'] =
        (seasons[11]['air_pressure'] + seasons[0]['air_pressure'] + seasons[1]['air_pressure']) / 3;
    });

    this.prevWeeksShowSpinner = true;
    const previousWeeks = this.http.get(this.backend.URI + '/previous-weeks/' + this.noPrevWeeks).toPromise();
    previousWeeks.then((resp) => {
      this.previousWeeks = resp['previous weeks'] as [];
      this.prevWeeksShowSpinner = false;
    },
    (err) => {
      this.prevWeeksShowSpinner = false;
    });
  }

  openStream() {
    // this.presentOkToast('Listening on port: ' + this.backend.port);
    this.ws.getDataStream().subscribe(
      (msg) => {
        msg = JSON.parse(msg.data);
        if (msg.temperature != null) {
          this.comparisonGraphShowLoading = true;
          msg.light = Number(msg.light);
          msg.temperature = Number(msg.temperature);
          msg.air_pressure = Number(msg.air_pressure);
          if ( this.temperatureBoundaries == null || this.lightBoundaries == null || this.airPressureBoundaries == null) {
            const temperatureBoundaries = this.http.get(this.backend.URI + '/weather-boundaries/temperature').toPromise();
            const lightBoundaries = this.http.get(this.backend.URI + '/weather-boundaries/light').toPromise();
            const airPressureBoundaries = this.http.get(this.backend.URI + '/weather-boundaries/air-pressure').toPromise();
            temperatureBoundaries.then((btemp) => {
              lightBoundaries.then((blight) => {
                airPressureBoundaries.then((bpres) => {
                  this.temperatureBoundaries = btemp;
                  this.lightBoundaries = blight;
                  this.airPressureBoundaries = bpres;
                  this.weatherComparisonChart.dataTable = [
                    ['Tag', 'Value', { role: 'style' } ],
                    [
                      'Ideal light',
                      (this.predictedHabitLight - this.lightBoundaries.min_light) /
                      (this.lightBoundaries.max_light - this.lightBoundaries.min_light),
                      'color: #1d3557'
                    ],
                    [
                      'Actual light', 
                      (msg.light - this.lightBoundaries.min_light) /
                      (this.lightBoundaries.max_light - this.lightBoundaries.min_light),
                      'color: #1d3557; opacity: 0.2'
                    ],
                    [
                      'Ideal pressure',
                      (this.predictedHabitPressure - this.airPressureBoundaries.min_air_pressure) /
                      (this.airPressureBoundaries.max_air_pressure - this.airPressureBoundaries.min_air_pressure),
                      'color: #f4a261'
                    ],
                    [
                      'Actual pressure',
                      (msg.air_pressure - this.airPressureBoundaries.min_air_pressure) /
                      (this.airPressureBoundaries.max_air_pressure - this.airPressureBoundaries.min_air_pressure),
                      'color: #f4a261; opacity: 0.2'
                    ],
                    [
                      'Ideal tempr.',
                      (this.predictedHabitTemperature - this.temperatureBoundaries.min_temperature) /
                      (this.temperatureBoundaries.max_temperature - this.temperatureBoundaries.min_temperature),
                      'color: #46b4b3'
                    ],
                    [
                      'Actual tempr.',
                      (msg.temperature - this.temperatureBoundaries.min_temperature) /
                      (this.temperatureBoundaries.max_temperature - this.temperatureBoundaries.min_temperature),
                      'opacity: 0.2'
                    ]
                  ];
                  this.comparisonGraphShowLoading = false;
                  this.weatherComparisonChart.component.draw();
                });
              });
            });
          } else {
            this.weatherComparisonChart.dataTable = [
              ['Tag', 'Value', { role: 'style' } ],
              [
                'Ideal light',
                (this.predictedHabitLight - this.lightBoundaries.min_light) /
                (this.lightBoundaries.max_light - this.lightBoundaries.min_light),
                'color: #1d3557'
              ],
              [
                'Actual light', 
                (msg.light - this.lightBoundaries.min_light) /
                (this.lightBoundaries.max_light - this.lightBoundaries.min_light),
                'color: #1d3557; opacity: 0.2'
              ],
              [
                'Ideal pressure',
                (this.predictedHabitPressure - this.airPressureBoundaries.min_air_pressure) /
                (this.airPressureBoundaries.max_air_pressure - this.airPressureBoundaries.min_air_pressure),
                'color: #f4a261'
              ],
              [
                'Actual pressure',
                (msg.air_pressure - this.airPressureBoundaries.min_air_pressure) /
                (this.airPressureBoundaries.max_air_pressure - this.airPressureBoundaries.min_air_pressure),
                'color: #f4a261; opacity: 0.2'
              ],
              [
                'Ideal tempr.',
                (this.predictedHabitTemperature - this.temperatureBoundaries.min_temperature) /
                (this.temperatureBoundaries.max_temperature - this.temperatureBoundaries.min_temperature),
                'color: #46b4b3'
              ],
              [
                'Actual tempr.',
                (msg.temperature - this.temperatureBoundaries.min_temperature) /
                (this.temperatureBoundaries.max_temperature - this.temperatureBoundaries.min_temperature),
                'opacity: 0.2'
              ]
            ];
            this.comparisonGraphShowLoading = false;
            this.weatherComparisonChart.component.draw();
          }
        }
      },
      (msg) => {
          console.log('main.main: openStream: error', msg);
      },
      () => {
          const promise = this.sleep(3000);
          promise.then(() => {
            this.comparisonGraphShowLoading = false;
            this.failedToLoadTheGraph = true;
          });
      }
    );
  }

  closeStream() {
    console.log('main.main: closeStream\n' +
      'Stop listening on port: ' + this.backend.portws);
    this.ws.close(false);
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

  async presentActionSheet() {
    const actionSheet = await this.actionSheetController.create({
      header: 'Options',
      buttons: [{
        text: 'Run',
        icon: 'walk',
        handler: () => {
          if (this.currentLastActivityType !== 'Run') {
            // Actions organized on the network status:
            if (this.network.type !== this.network.Connection.NONE) {
                this.gridShowSpinner = true;
                const runningLastActivities = this.http.get(this.backend.URI + '/recent-activities/run').toPromise();
                runningLastActivities.then((resp) => {
                  this.lastActivities = resp['activities'];
                  for (const activity of this.lastActivities) {
                    activity.start_date = new Date(activity.start_date).toLocaleString();
                  }
                  this.noLastActivities = this.lastActivities.length;
                  this.currentLastActivityType = 'Run';
                  this.gridShowSpinner = false;
                });
            } else {
                this.presentOkToast('Unable to fetch recent activities.');
            }
          }
        }
      }, {
        text: 'Ride',
        icon: 'bicycle',
        handler: () => {
          if (this.currentLastActivityType !== 'Ride') {
            // Actions organized on the network status:
            if (this.network.type !== this.network.Connection.NONE) {
              this.gridShowSpinner = true;
              const ridingLastActivities = this.http.get(this.backend.URI + '/recent-activities/ride').toPromise();
              ridingLastActivities.then((resp) => {
                this.lastActivities = resp['activities'];
                for (const activity of this.lastActivities) {
                  activity.start_date = new Date(activity.start_date).toLocaleString();
                }
                this.noLastActivities = this.lastActivities.length;
                this.currentLastActivityType = 'Ride';
                this.gridShowSpinner = false;
              });
            } else {
                this.presentOkToast('Unable to fetch recent activities.');
            }
         }
        }
      }, {
        text: 'Weights Training',
        icon: 'body',
        handler: () => {
          if (this.currentLastActivityType !== 'Weights') {
            // Actions organized on the network status:
            if (this.network.type !== this.network.Connection.NONE) {
              this.gridShowSpinner = true;
              const weightTrainingLastActivities = this.http.get(this.backend.URI + '/recent-activities/weights').toPromise();
              weightTrainingLastActivities.then((resp) => {
                this.lastActivities = resp['activities'];
                for (let activity of this.lastActivities) {
                  activity.start_date = new Date(activity.start_date).toLocaleString();
                }
                this.noLastActivities = this.lastActivities.length;
                this.currentLastActivityType = 'Weights';
                this.gridShowSpinner = false;
              });
            } else {
              this.presentOkToast('Unable to fetch recent activities.');
            }
          }
        }
      }, {
        text: 'Cancel',
        icon: 'close',
        role: 'cancel',
        handler: () => {
          console.log('Cancel clicked');
        }
      }]
    });
    await actionSheet.present();
  }

  sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  segmentChanged(event) {
    console.log(event);
  }

  prepareGraphs() {
    this.habitsGraphsShowLoading = true;
    const runningDistancePredictionChart = this.http.get(this.backend.URI + '/prediction/run').toPromise();
    const ridingDistancePredictionChart = this.http.get(this.backend.URI + '/prediction/riding-distance').toPromise();
    const availabilityPredictionChart = this.http.get(this.backend.URI + '/prediction/availability').toPromise();

    runningDistancePredictionChart.then((resp) => {
      const runningPrediction = [];
      runningPrediction.push(['Hour', 'Km']);
      for (const pair of resp as []) {
        runningPrediction.push([pair[1] + ':00', pair[0]]);
      }
      this.runningDistancePredictionChart.dataTable = runningPrediction;
      this.runningDistancePredictionChart.component.draw();
      ridingDistancePredictionChart.then((resp) => {
        const ridePred = [];
        ridePred.push(['Hour', 'Km']);
        for (const pair of resp as []) {
          ridePred.push([pair[1] + ':00', pair[0]]);
        }
        this.ridingDistancePredictionChart.dataTable = ridePred;
        this.ridingDistancePredictionChart.component.draw();
        availabilityPredictionChart.then((resp) => {
          const avlPred = [];
          avlPred.push(['Day', 'Percent']);
          for (const pair of resp['week distribution'] as []) {
            avlPred.push([pair['dayofweek'], Number(pair['percent'])]);
          }
          console.log(avlPred);
          this.availabilityChart.dataTable = avlPred;
          this.habitsGraphsShowLoading = false;
          this.availabilityChart.component.draw();
        });
      });
    },
    (err) => {
      this.failedToLoadHabitGraphs = true;
      this.habitsGraphsShowLoading = false;
    });
  }

  async displayInfoRegardingPrediction() {
    const alert = await this.alertController.create({
      cssClass: 'my-custom-class',
      header: '',
      subHeader: 'Habits algorithm',
      message: 'These values are obtained from all of the recorded activities, using linear ' +
      'regression and logistic regression. The first statistical method is used to predict the weather ' +
      'habits, while the former classifies the activities.',
      buttons: ['Okay']
    });

    await alert.present();
  }

  onPrevWeekSelectChange(value) {
    this.prevWeeksShowSpinner = true;
    const previousWeeks = this.http.get(this.backend.URI + '/previous-weeks/' + value).toPromise();
    previousWeeks.then((resp) => {
      this.previousWeeks = resp['previous weeks'] as [];
      this.noPrevWeeks = value;
      this.prevWeeksShowSpinner = false;
    },
    (err) => {
      this.noPrevWeeks = value;
      this.prevWeeksShowSpinner = false;
    });
  }

}
