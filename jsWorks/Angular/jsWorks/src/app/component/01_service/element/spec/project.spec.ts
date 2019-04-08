import {Project} from '../project';

describe('Project', () =>
  {
  it('devrait créer une instance', () =>
    {
    expect(new Project()).toBeTruthy();
    });
  /*
  it('devrait accepter le passage de valeurs d\'attributs dans le constructeur', () =>
    {
    const u = new Project(
      {
      nom   : 'jean',
      niveau: 1
      });
    expect(u.nom   ).toEqual('jean');
    expect(u.niveau).toEqual(1     );
    });
  */  
  });
