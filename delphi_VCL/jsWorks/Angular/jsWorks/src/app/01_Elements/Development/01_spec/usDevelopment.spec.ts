import { TestBed, inject } from '@angular/core/testing';
import { HttpClient, HttpHandler} from '@angular/common/http';

import { TsDevelopment } from '../usDevelopment';

describe('TsDevelopment', () =>
  {
  beforeEach(() =>
    {
    TestBed.configureTestingModule(
      {
      providers:
        [
        TsDevelopment,
        HttpClient,
        HttpHandler,
        ]
      });
    });

  it('should be created', inject([TsDevelopment], (service: TsDevelopment) =>
    {
    expect(service).toBeTruthy();
    }));
});
