import {TeType_Tag} from '../ueType_Tag';

describe('TType_Tag', () =>
  {
  it('devrait créer une instance', () =>
    {
    expect(new TeType_Tag()).toBeTruthy();
    });
  /*
  it('devrait accepter le passage de valeurs d\'attributs dans le constructeur', () =>
    {
    const e = new TType_Tag(
      {
      nom   : 'jean',
      niveau: 1
      });
    expect(e.nom   ).toEqual('jean');
    expect(e.niveau).toEqual(1     );
    });
  */  
  });
