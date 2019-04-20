import { TestBed, inject } from '@angular/core/testing';
import { HttpClient, HttpHandler} from '@angular/common/http';

import { TsNom_de_la_classe } from '../usNom_de_la_classe';

describe('TsNom_de_la_classe', () =>
  {
  beforeEach(() =>
    {
    TestBed.configureTestingModule(
      {
      providers:
        [
        TsNom_de_la_classe,
        HttpClient,
        HttpHandler,
        ]
      });
    });

  it('should be created', inject([TsNom_de_la_classe], (service: TsNom_de_la_classe) =>
    {
    expect(service).toBeTruthy();
    }));
});
