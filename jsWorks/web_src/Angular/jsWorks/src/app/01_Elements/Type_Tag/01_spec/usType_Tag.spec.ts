import { TestBed, inject } from '@angular/core/testing';
import { HttpClient, HttpHandler} from '@angular/common/http';

import { TsType_Tag } from '../usType_Tag';

describe('TsType_Tag', () =>
  {
  beforeEach(() =>
    {
    TestBed.configureTestingModule(
      {
      providers:
        [
        TsType_Tag,
        HttpClient,
        HttpHandler,
        ]
      });
    });

  it('should be created', inject([TsType_Tag], (service: TsType_Tag) =>
    {
    expect(service).toBeTruthy();
    }));
});
