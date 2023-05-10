import { TestBed, inject } from '@angular/core/testing';
import { HttpClient, HttpHandler} from '@angular/common/http';

import { TsCategorie } from '../usCategorie';

describe('TsCategorie', () =>
  {
  beforeEach(() =>
    {
    TestBed.configureTestingModule(
      {
      providers:
        [
        TsCategorie,
        HttpClient,
        HttpHandler,
        ]
      });
    });

  it('should be created', inject([TsCategorie], (service: TsCategorie) =>
    {
    expect(service).toBeTruthy();
    }));
});
