import { TestBed, inject } from '@angular/core/testing';
import { HttpClient, HttpHandler} from '@angular/common/http';

import { WorkService } from '../work.service';

describe('WorkService', () =>
  {
  beforeEach(() =>
    {
    TestBed.configureTestingModule(
      {
      providers:
        [
        WorkService,
        HttpClient,
        HttpHandler,
        ]
      });
    });

  it('should be created', inject([WorkService], (service: WorkService) =>
    {
    expect(service).toBeTruthy();
    }));
});
