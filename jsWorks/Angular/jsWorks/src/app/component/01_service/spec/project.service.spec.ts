import { TestBed, inject } from '@angular/core/testing';
import { HttpClient, HttpHandler} from '@angular/common/http';

import { PROJECTService } from '../project.service';

describe('PROJECTService', () =>
  {
  beforeEach(() =>
    {
    TestBed.configureTestingModule(
      {
      providers:
        [
        PROJECTService,
        HttpClient,
        HttpHandler,
        ]
      });
    });

  it('should be created', inject([PROJECTService], (service: PROJECTService) =>
    {
    expect(service).toBeTruthy();
    }));
});
