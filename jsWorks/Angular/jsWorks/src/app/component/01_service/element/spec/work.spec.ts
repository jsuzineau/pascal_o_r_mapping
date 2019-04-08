import {Work} from '../work';

describe('Work', () =>
  {
  it('devrait créer une instance', () =>
    {
    expect(new Work()).toBeTruthy();
    });
  /*
  it('devrait accepter le passage de valeurs d\'attributs dans le constructeur', () =>
    {
    const u = new Work(
      {
      nom   : 'jean',
      niveau: 1
      });
    expect(u.nom   ).toEqual('jean');
    expect(u.niveau).toEqual(1     );
    });
  */  
  });
