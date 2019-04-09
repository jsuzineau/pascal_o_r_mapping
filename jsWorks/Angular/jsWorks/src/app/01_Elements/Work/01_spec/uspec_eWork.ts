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
    const e = new Work(
      {
      nom   : 'jean',
      niveau: 1
      });
    expect(e.nom   ).toEqual('jean');
    expect(e.niveau).toEqual(1     );
    });
  */  
  });
