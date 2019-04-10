import { TestBed, inject } from '@angular/core/testing';
import { HttpClient, HttpHandler} from '@angular/common/http';

import { TsWork } from '../usWork';

describe('TsWork', () =>
  {
  beforeEach(() =>
    {
    TestBed.configureTestingModule(
      {
      providers:
        [
        TsWork,
        HttpClient,
        HttpHandler,
        ]
      });
    });

  it('should be created', inject([TsWork], (service: TsWork) =>
    {
    expect(service).toBeTruthy();
    }));
});
