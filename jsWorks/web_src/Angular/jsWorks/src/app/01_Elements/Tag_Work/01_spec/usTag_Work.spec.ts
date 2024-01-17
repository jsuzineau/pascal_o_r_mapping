import { TestBed, inject } from '@angular/core/testing';
import { HttpClient, HttpHandler} from '@angular/common/http';

import { TsTag_Work } from '../usTag_Work';

describe('TsTag_Work', () =>
  {
  beforeEach(() =>
    {
    TestBed.configureTestingModule(
      {
      providers:
        [
        TsTag_Work,
        HttpClient,
        HttpHandler,
        ]
      });
    });

  it('should be created', inject([TsTag_Work], (service: TsTag_Work) =>
    {
    expect(service).toBeTruthy();
    }));
});
