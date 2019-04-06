import {PROJECT} from '../project';

describe('PROJECT', () =>
  {
  it('devrait créer une instance', () =>
    {
    expect(new PROJECT()).toBeTruthy();
    });
  /*
  it('devrait accepter le passage de valeurs d\'attributs dans le constructeur', () =>
    {
    const u = new PROJECT(
      {
      nom   : 'jean',
      niveau: 1
      });
    expect(u.nom   ).toEqual('jean');
    expect(u.niveau).toEqual(1     );
    });
  */  
  });
