import { TestBed, inject } from '@angular/core/testing';
import { HttpClient, HttpHandler} from '@angular/common/http';

import { ProjectService } from '../project.service';

describe('ProjectService', () =>
  {
  beforeEach(() =>
    {
    TestBed.configureTestingModule(
      {
      providers:
        [
        ProjectService,
        HttpClient,
        HttpHandler,
        ]
      });
    });

  it('should be created', inject([ProjectService], (service: ProjectService) =>
    {
    expect(service).toBeTruthy();
    }));
});
