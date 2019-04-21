import {TeTag_Work} from '../ueTag_Work';

describe('TTag_Work', () =>
  {
  it('devrait créer une instance', () =>
    {
    expect(new TeTag_Work()).toBeTruthy();
    });
  /*
  it('devrait accepter le passage de valeurs d\'attributs dans le constructeur', () =>
    {
    const e = new TTag_Work(
      {
      nom   : 'jean',
      niveau: 1
      });
    expect(e.nom   ).toEqual('jean');
    expect(e.niveau).toEqual(1     );
    });
  */  
  });
