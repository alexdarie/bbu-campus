import { Component, OnInit, OnDestroy } from '@angular/core';
import { BreakpointObserver } from '@angular/cdk/layout';
import { ActivatedRoute, Router } from '@angular/router';
import { DomSanitizer } from '@angular/platform-browser';
import { HttpClient } from '@angular/common/http';
import { AngularFirestore } from '@angular/fire/firestore';
import { IpServiceService } from '../ip-service.service';
import * as firebase from 'firebase/app';
import { ModalController } from '@ionic/angular';

interface Reactions {
  energy: []
};

@Component({
  selector: 'app-article',
  templateUrl: './article.page.html',
  styleUrls: ['./article.page.scss'],
})
export class ArticlePage implements OnInit, OnDestroy {

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

  article = {
    id: 0,
    title: '',
    author: '',
    date: '',
    peopleInvolved: [],
    photosAuthor: '',
    readTime: 0,
    poster: '',
    image: '',
    category: '',
    content: {
      rules: {},
      header: '',
      paragraphs: []
    },
    media: {
      picture: [],
      video: [],
      grid: []
    },
    reactions: {
      energy: 0,
      rid: ''
    }
  };
  articleHash;
  disableReactions: boolean;

  // A default structure for the content that will be later loaded.
  articles = {
    popular: [],
  };

  slideOpts = {
    initialSlide: 0,
    speed: 400,
    autoHeight: true
  };

  collectionName = 'articles';
  id: string;
  category: string;
  ipAddress;
  gaveEnergy = false;
  postFeedbackProgress = 0.0;
  maxAmountOfEnergy = 10.0;
  wideArticle = true;
  narrowArticle = false;
  logoImage = "https://firebasestorage.googleapis.com/v0/b/alexdarie-2251.appspot.com/o/utils%2Flogo.png?alt=media&token=408fdde2-51fc-4761-b285-84d7fb711dc3";
  howMany = 3;

  constructor(
    private http: HttpClient,
    private modalController: ModalController,
    private activatedRoute: ActivatedRoute,
    public sanitizer: DomSanitizer,
    private breakpointObserver: BreakpointObserver,
    private router: Router,
    private firestore: AngularFirestore,
    private ip: IpServiceService
  ) {
    this.activatedRoute.params.subscribe(params => {
      this.id = params.id;
      this.category = params.type;
    });
    this.disableReactions = false;
  }

  async ngOnInit() {
    this.router.onSameUrlNavigation = 'reload';
    const snapshot = await this.firestore.collection(this.collectionName).ref
                              .orderBy('date', 'desc')
                              .get();
    snapshot.forEach(doc => {
      this.processSnapshopDoc(doc);
    });

    await this.getIP();
    var reactRef = this.firestore.collection("reactions").doc(this.article.reactions.rid);
    const r = await reactRef.ref.get();
    const reactions = r.data();

    if (!reactions.hasOwnProperty('views') || !reactions.views.includes(this.ipAddress)) {
      reactRef.update({
        views: firebase.firestore.FieldValue.arrayUnion(this.ipAddress)
      });
    }

    if (reactions.energy.includes(this.ipAddress)) {
      this.gaveEnergy = true;
    }

    this.setViewBreakpoints();
  }

  setViewBreakpoints() {
    this.breakpointObserver.observe(['(min-width: 1199px)']).subscribe(result => {
      if (result.matches) {
        this.wideArticle = true;
        this.narrowArticle = false;
      } else {
        this.narrowArticle = true;
        this.wideArticle = false;
      }
    });
  }

  async getIP() {  
    return new Promise((resolve, reject) => {
      this.ip.getIPAddress().subscribe((res:any)=>{  
        this.ipAddress = res.ip;  
        console.log(this.ipAddress);
        resolve(true);
      });  
    });
  } 

  async processSnapshopDoc(doc) {
    const data = doc.data();
    if (data['id'] == this.id && data['category'] === this.category) {
      this.article = data;
      this.articleHash = doc.id;
      var reactRef = this.firestore.collection("reactions").doc(this.article.reactions.rid);
      const r = await reactRef.ref.get();
      const reactions = r.data();
      this.article.reactions.energy = reactions.energy.length;
      this.postFeedbackProgress = reactions.energy.length / this.maxAmountOfEnergy;
    } else {
      this.buildMostPopularArticles(data);
    }
  }

  updateArticle(doc) {
    const data = doc.data();
    if (data['id'] == this.id && data['category'] === this.category) {
      this.article = data;
      this.articleHash = doc.id;
    } 
  }

  buildMostPopularArticles(data) {
    const pop = this.articles.popular;
    const n = pop.length;
    let position = 0;
    for (let i = 0; i < n - 1; i++) {
      if (data['views'] < pop[i]['views']) {
        position += 1;
      }
    }
    for (let i = n; i > position; i--) {
      pop[i] = pop[i - 1];
    }
    pop[position] = data;
  }

  ngOnDestroy() {
    this.router.onSameUrlNavigation = 'ignore';
  }

  delay(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  async react(type) {
    this.disableReactions = true;

    if (this.articleHash.length < 1) {
      await this.getIP();
    }
    var reactRef = this.firestore.collection("reactions").doc(this.article.reactions.rid);
    const r = await reactRef.ref.get();
    const reactions = r.data();
    const docRef = this.firestore.collection("articles").doc(this.articleHash);

    if (type === 'energy') {
      if (reactions.energy.includes(this.ipAddress)) {
        reactRef.update({
          energy: firebase.firestore.FieldValue.arrayRemove(this.ipAddress)
        }).then(() => {
          this.article.reactions.energy -= 1;
          this.gaveEnergy = false;
          this.disableReactions = false;
          this.postFeedbackProgress = this.article.reactions.energy / this.maxAmountOfEnergy;
        });;
      } else {
        reactRef.update({
          energy: firebase.firestore.FieldValue.arrayUnion(this.ipAddress)
        }).then(() => {
          this.article.reactions.energy += 1;
          this.gaveEnergy = true;
          this.disableReactions = false;
          this.postFeedbackProgress = this.article.reactions.energy / this.maxAmountOfEnergy;
        });;
      }
    }
  }

  objectValues(obj) {
    return Object.values(obj);
  }

  async presentModal() {
    // const modal = await this.modalController.create({
    //   component: AlbumPage,
    //   swipeToClose: true,
    //   componentProps: { 
    //     evnt: this.article
    //   },
    //   cssClass: 'custom-modal-css'
    // });
    // return await modal.present();
  }

}
