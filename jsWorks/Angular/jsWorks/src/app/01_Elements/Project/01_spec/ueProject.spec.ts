import {TeProject} from '../ueProject';

describe('TProject', () =>
  {
  it('devrait créer une instance', () =>
    {
    expect(new TeProject()).toBeTruthy();
    });
  /*
  it('devrait accepter le passage de valeurs d\'attributs dans le constructeur', () =>
    {
    const e = new TProject(
      {
      nom   : 'jean',
      niveau: 1
      });
    expect(e.nom   ).toEqual('jean');
    expect(e.niveau).toEqual(1     );
    });
  */  
  });
