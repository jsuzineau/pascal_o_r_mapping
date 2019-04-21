import {TeCategorie} from '../ueCategorie';

describe('TCategorie', () =>
  {
  it('devrait créer une instance', () =>
    {
    expect(new TeCategorie()).toBeTruthy();
    });
  /*
  it('devrait accepter le passage de valeurs d\'attributs dans le constructeur', () =>
    {
    const e = new TCategorie(
      {
      nom   : 'jean',
      niveau: 1
      });
    expect(e.nom   ).toEqual('jean');
    expect(e.niveau).toEqual(1     );
    });
  */  
  });
