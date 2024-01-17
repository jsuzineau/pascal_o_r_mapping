import {TeTag_Development} from '../ueTag_Development';

describe('TTag_Development', () =>
  {
  it('devrait créer une instance', () =>
    {
    expect(new TeTag_Development()).toBeTruthy();
    });
  /*
  it('devrait accepter le passage de valeurs d\'attributs dans le constructeur', () =>
    {
    const e = new TTag_Development(
      {
      nom   : 'jean',
      niveau: 1
      });
    expect(e.nom   ).toEqual('jean');
    expect(e.niveau).toEqual(1     );
    });
  */  
  });
