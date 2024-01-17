import { TestBed, inject } from '@angular/core/testing';
import { HttpClient, HttpHandler} from '@angular/common/http';

import { TsTag_Development } from '../usTag_Development';

describe('TsTag_Development', () =>
  {
  beforeEach(() =>
    {
    TestBed.configureTestingModule(
      {
      providers:
        [
        TsTag_Development,
        HttpClient,
        HttpHandler,
        ]
      });
    });

  it('should be created', inject([TsTag_Development], (service: TsTag_Development) =>
    {
    expect(service).toBeTruthy();
    }));
});
