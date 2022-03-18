import { Component, ViewChild, OnInit} from '@angular/core';
import { BreakpointObserver } from '@angular/cdk/layout';
import { IonSlides, Platform } from '@ionic/angular';
import { ModalController } from '@ionic/angular';
import { AngularFirestore } from '@angular/fire/firestore';

@Component({
  selector: 'app-home',
  templateUrl: 'home.page.html',
  styleUrls: ['home.page.scss'],
})
export class HomePage implements OnInit {

  @ViewChild('slider')  slides: IonSlides;

  crntSldOpt: number;
  slideOptions = {
    1: {
      initialSlide: 0,
      speed: 600,
      loop: true,
      // autoplay: true
    },
    2: {
      initialSlide: 0,
      speed: 400,
      slidesPerView: 4.5
    },
    3: {
      initialSlide: 0,
      speed: 400,
      slidesPerView: 2.5
    },
    4: {
      initialSlide: 0,
      speed: 400,
      slidesPerView: 1.8
    }
  };

  firebaseEntries = [];
  x3articles = [];
  articles = [];
  recap = [];
  sab = [];
  festivals= [];
  soon = [];
  descriptions = {
    website: '',
    rollnotes: '',
    festivals: '',
    sab: ''
  }
  collectionName = 'articles';
  localData;
  title = "Alex Darie";

  smallImage = "https://firebasestorage.googleapis.com/v0/b/alexdarie-2251.appspot.com/o/utils%2FDSC_0123-2.jpg?alt=media&token=af9bfb63-d364-4e75-9910-5c8a77d8c6d0";
  projectsImage = "https://firebasestorage.googleapis.com/v0/b/alexdarie-2251.appspot.com/o/projects%2Fsabina-zmau-coral-pink.jpg?alt=media&token=939afb5e-1493-4cfe-b73f-5b9cb99358c7";
  logoImage = "https://firebasestorage.googleapis.com/v0/b/alexdarie-2251.appspot.com/o/utils%2Flogo.png?alt=media&token=408fdde2-51fc-4761-b285-84d7fb711dc3";

  constructor(
    private modalController: ModalController,
    private breakpointObserver: BreakpointObserver,
    private platform: Platform,
    private firestore: AngularFirestore
  ) {}

  async ngOnInit() {
    this.crntSldOpt = 2;
    let snapshot = await this.firestore.collection(this.collectionName).ref
                            .orderBy('id', 'asc')
                            .get();
    snapshot.forEach(doc => {
      this.processSnapshopDoc(doc);
    });
    this.x3articles = this.articles;

    snapshot = await this.firestore.collection('metadata').ref.get();
    snapshot.forEach(doc => {
      this.processMetadata(doc);
    });

    this.setViewBreakpoints();
    this.setPlatformReadyRoutine();
  }

  setViewBreakpoints() {
    this.breakpointObserver.observe(['(max-width: 1020px)']).subscribe(result => {
      if (result.matches) {
        this.crntSldOpt = 3;
      } else {
        this.crntSldOpt = 2;
      }
    });

    this.breakpointObserver.observe(['(max-width: 953px)']).subscribe(result => {
      if (result.matches) {
        this.x3articles = this.articles;
        this.articles = [];
        for(let article of this.firebaseEntries) {
          this.addEntry(article, 2);
        }
      } else {
        this.articles = this.x3articles;
      }
    });

    this.breakpointObserver.observe(['(max-width: 540px)']).subscribe(result => {
      if (result.matches) {
        this.crntSldOpt = 4;
      } else {
        this.crntSldOpt = 3;
      }
    });
  }

  setPlatformReadyRoutine() {
    this.platform.ready().then((readySource) => {
      const width = this.platform.width();
      if (width > 1020) {
        this.crntSldOpt = 2;
      } else if (width > 520) {
        this.crntSldOpt = 3;
      } else {
        this.crntSldOpt = 4;
      }
    });
  }

  processSnapshopDoc(doc) {
    const data = doc.data();
    this.localData = data;
    console.log(data.id);
    if (data['category'] === 'roll-note') {
      this.firebaseEntries.push(data);
      this.addEntry(data, 3);
    }
    if (data['category'] === 'festival') {
      this.festivals.push(data);
    }
    if (data['category'] === 'business') {
      this.sab.push(data);
    }
    this.findTopPosts();
  }

  processMetadata(doc) {
    const key = doc.id;
    if (key === 'project') {
      this.descriptions.website = doc.data()['description'];
      this.descriptions.rollnotes = doc.data()['rollnotes'];
      this.descriptions.festivals = doc.data()['festivals'];
      this.descriptions.sab = doc.data()['sab'];
    }
  }

  addEntry(data, maxPerRow) {
    const tt = this.articles;
    const n = tt.length - 1;
    if (tt.length === 0 || tt[n].length === maxPerRow) {
      tt.push([data]);
    } else {
      tt[n].push(data);
    }
  }

  findTopPosts() {
    let top_post;
    this.recap = [];
    if (this.sab.length > 0) {
      top_post = this.sab[0];
      for (let i = 1; i < this.sab.length; i++) {
        if (this.sab[i]['views'] > top_post['views']) {
          top_post = this.sab[i];
        }
      }
      this.recap.push(top_post);
    }
    if (this.festivals.length > 0) {
      top_post = this.festivals[0];
      for (let i = 1; i < this.festivals.length; i++) {
        if (this.festivals[i]['views'] > top_post['views']) {
          top_post = this.festivals[i];
        }
      }
      this.recap.push(top_post);
    }
    console.log(this.recap);
  }

}
