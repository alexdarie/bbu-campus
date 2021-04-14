import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { FitnessPage } from './fitness.page';

describe('FitnessPage', () => {
  let component: FitnessPage;
  let fixture: ComponentFixture<FitnessPage>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ FitnessPage ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(FitnessPage);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
