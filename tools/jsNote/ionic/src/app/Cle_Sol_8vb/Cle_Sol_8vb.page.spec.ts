import { CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { Cle_Sol_8vbPage } from './Cle_Sol_8vb.page';

describe('Cle_Sol_8vbPage', () => {
  let component: Cle_Sol_8vbPage;
  let fixture: ComponentFixture<Cle_Sol_8vbPage>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ Cle_Sol_8vbPage ],
      schemas: [CUSTOM_ELEMENTS_SCHEMA],
    })
      .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(Cle_Sol_8vbPage);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
