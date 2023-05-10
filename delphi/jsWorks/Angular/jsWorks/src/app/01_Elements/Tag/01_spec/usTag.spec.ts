import { TestBed, inject } from '@angular/core/testing';
import { HttpClient, HttpHandler} from '@angular/common/http';

import { TsTag } from '../usTag';

describe('TsTag', () =>
  {
  beforeEach(() =>
    {
    TestBed.configureTestingModule(
      {
      providers:
        [
        TsTag,
        HttpClient,
        HttpHandler,
        ]
      });
    });

  it('should be created', inject([TsTag], (service: TsTag) =>
    {
    expect(service).toBeTruthy();
    }));
});
