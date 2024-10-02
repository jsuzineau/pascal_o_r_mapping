import { TestBed, inject        } from '@angular/core/testing';
import { HttpClientTestingModule,
         HttpTestingController  } from '@angular/common/http/testing';
import { HttpClient             ,
         HttpHandler            } from '@angular/common/http';
import { SessionService         } from '../session.service';
import { Utilisateur            } from '../element/utilisateur';

const test_utilisateur_nom         = 'jean';
const test_utilisateur_mot_de_passe= '123';
const test_utilisateur_SID         = '1234';

describe('SessionService', () =>
  {
  beforeEach(() =>
    {
    TestBed.configureTestingModule(
      {
      imports  : [ HttpClientTestingModule ],  
      providers: [ SessionService          ]
      });
    });
  afterEach(inject([HttpTestingController], (httpMock: HttpTestingController) => 
    {
    httpMock.verify();
    }));

  it('devrait être créé', inject([SessionService], (service: SessionService) =>
    {
    expect(service).toBeTruthy();
    }));


  it( '.Session_from_Login() devrait retourner l\'Utilisateur envoyé par le serveur http' ,
      inject(
        [
        SessionService,
        HttpTestingController
        ],
        (
        s : SessionService,
        htc: HttpTestingController
        ) =>
    {
    const login: Utilisateur
    =
     new Utilisateur(
       {
       nom         : test_utilisateur_nom,
       mot_de_passe: test_utilisateur_mot_de_passe
       });
    const session: Utilisateur= new Utilisateur(login);
    session.SID= test_utilisateur_SID;
    // session.nom= 'truc'; juste pour tester le test ;-)

    s.Session_from_Login( login)
      .then( value =>
        {
        expect(value).toBeTruthy();
        expect(value.nom).toEqual(login.nom);
        });
    const url= s.Session_from_Login_url();   

    const r= htc.expectOne( url);
    expect(r.request.method).toEqual('POST');
    r.flush( session);
    }));


  it( '.Session() devrait retourner l\'Utilisateur envoyé par le serveur http' ,
      inject(
        [
        SessionService,
        HttpTestingController
        ],
        (
        s : SessionService,
        htc: HttpTestingController
        ) =>
    {
    const session: Utilisateur
    =
     new Utilisateur(
       {
       nom         : test_utilisateur_nom,
       mot_de_passe: test_utilisateur_mot_de_passe,
       SID         : test_utilisateur_SID,
       });
    s.Session()
      .then( value =>
        {
        expect(value).toEqual(session);
        });
    const url= s.Session_url();   
        
    const r= htc.expectOne( url);
    expect(r.request.method).toEqual('GET');
    r.flush( session);
    }));


  

  });
