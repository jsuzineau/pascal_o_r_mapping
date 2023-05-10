import {TeWork} from '../ueWork';

describe('TWork', () =>
  {
  it('devrait créer une instance', () =>
    {
    expect(new TeWork()).toBeTruthy();
    });
  /*
  it('devrait accepter le passage de valeurs d\'attributs dans le constructeur', () =>
    {
    const e = new TWork(
      {
      nom   : 'jean',
      niveau: 1
      });
    expect(e.nom   ).toEqual('jean');
    expect(e.niveau).toEqual(1     );
    });
  */  
  });
