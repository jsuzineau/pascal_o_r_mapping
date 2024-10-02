import {TeTag} from '../ueTag';

describe('TTag', () =>
  {
  it('devrait créer une instance', () =>
    {
    expect(new TeTag()).toBeTruthy();
    });
  /*
  it('devrait accepter le passage de valeurs d\'attributs dans le constructeur', () =>
    {
    const e = new TTag(
      {
      nom   : 'jean',
      niveau: 1
      });
    expect(e.nom   ).toEqual('jean');
    expect(e.niveau).toEqual(1     );
    });
  */  
  });
