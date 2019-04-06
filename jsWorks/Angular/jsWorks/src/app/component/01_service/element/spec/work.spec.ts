import {WORK} from '../work';

describe('WORK', () =>
  {
  it('devrait créer une instance', () =>
    {
    expect(new WORK()).toBeTruthy();
    });
  /*
  it('devrait accepter le passage de valeurs d\'attributs dans le constructeur', () =>
    {
    const u = new WORK(
      {
      nom   : 'jean',
      niveau: 1
      });
    expect(u.nom   ).toEqual('jean');
    expect(u.niveau).toEqual(1     );
    });
  */  
  });
