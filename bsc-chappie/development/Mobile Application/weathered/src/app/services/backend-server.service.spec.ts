import { TestBed } from '@angular/core/testing';

import { BackendServerService } from './backend-server.service';

describe('BackendServerService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: BackendServerService = TestBed.get(BackendServerService);
    expect(service).toBeTruthy();
  });
});
