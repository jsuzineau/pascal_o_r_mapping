import { TestBed, inject } from '@angular/core/testing';
import { HttpClient, HttpHandler} from '@angular/common/http';

import { TsState } from '../usState';

describe('TsState', () =>
  {
  beforeEach(() =>
    {
    TestBed.configureTestingModule(
      {
      providers:
        [
        TsState,
        HttpClient,
        HttpHandler,
        ]
      });
    });

  it('should be created', inject([TsState], (service: TsState) =>
    {
    expect(service).toBeTruthy();
    }));
});
