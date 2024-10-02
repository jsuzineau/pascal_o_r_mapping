import {TeDevelopment} from '../ueDevelopment';

describe('TDevelopment', () =>
  {
  it('devrait créer une instance', () =>
    {
    expect(new TeDevelopment()).toBeTruthy();
    });
  /*
  it('devrait accepter le passage de valeurs d\'attributs dans le constructeur', () =>
    {
    const e = new TDevelopment(
      {
      nom   : 'jean',
      niveau: 1
      });
    expect(e.nom   ).toEqual('jean');
    expect(e.niveau).toEqual(1     );
    });
  */  
  });
