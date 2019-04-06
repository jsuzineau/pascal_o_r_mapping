import { TestBed, inject } from '@angular/core/testing';
import { HttpClient, HttpHandler} from '@angular/common/http';

import { WORKService } from '../work.service';

describe('WORKService', () =>
  {
  beforeEach(() =>
    {
    TestBed.configureTestingModule(
      {
      providers:
        [
        WORKService,
        HttpClient,
        HttpHandler,
        ]
      });
    });

  it('should be created', inject([WORKService], (service: WORKService) =>
    {
    expect(service).toBeTruthy();
    }));
});
