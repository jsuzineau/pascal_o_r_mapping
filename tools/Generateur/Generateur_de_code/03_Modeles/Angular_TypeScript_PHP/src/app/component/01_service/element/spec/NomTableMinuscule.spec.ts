import {Nom_de_la_classe} from '../NomTableMinuscule';

describe('Nom_de_la_classe', () =>
  {
  it('devrait créer une instance', () =>
    {
    expect(new Nom_de_la_classe()).toBeTruthy();
    });
  /*
  it('devrait accepter le passage de valeurs d\'attributs dans le constructeur', () =>
    {
    const u = new Nom_de_la_classe(
      {
      nom   : 'jean',
      niveau: 1
      });
    expect(u.nom   ).toEqual('jean');
    expect(u.niveau).toEqual(1     );
    });
  */  
  });
