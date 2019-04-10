import { TestBed, inject } from '@angular/core/testing';
import { HttpClient, HttpHandler} from '@angular/common/http';

import { TsProject } from '../usProject';

describe('TsProject', () =>
  {
  beforeEach(() =>
    {
    TestBed.configureTestingModule(
      {
      providers:
        [
        TsProject,
        HttpClient,
        HttpHandler,
        ]
      });
    });

  it('should be created', inject([TsProject], (service: TsProject) =>
    {
    expect(service).toBeTruthy();
    }));
});
