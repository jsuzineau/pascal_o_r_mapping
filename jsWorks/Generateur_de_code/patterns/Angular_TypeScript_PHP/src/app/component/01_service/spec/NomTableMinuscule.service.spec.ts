import { TestBed, inject } from '@angular/core/testing';
import { HttpClient, HttpHandler} from '@angular/common/http';

import { Nom_de_la_classeService } from '../NomTableMinuscule.service';

describe('Nom_de_la_classeService', () =>
  {
  beforeEach(() =>
    {
    TestBed.configureTestingModule(
      {
      providers:
        [
        Nom_de_la_classeService,
        HttpClient,
        HttpHandler,
        ]
      });
    });

  it('should be created', inject([Nom_de_la_classeService], (service: Nom_de_la_classeService) =>
    {
    expect(service).toBeTruthy();
    }));
});
