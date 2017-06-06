unit uCode_barre_pdf417;
// traduit en pascal depuis http://grandzebu.net/informatique/codbar/pdf417.htm
//### Attention publié en GPL au lieu de LGPL par conformité à grandzebu.net
//### Warning: published under GPL instead of LGPL to match licence used by grandzebu.net
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
                                                                                |
    This program is free software: you can redistribute it and/or modify        |
    it under the terms of the GNU General Public License as published by |
    the Free Software Foundation, either version 3 of the License, or           |
    (at your option) any later version.                                         |
                                                                                |
    This program is distributed in the hope that it will be useful,             |
    but WITHOUT ANY WARRANTY; without even the implied warranty of              |
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               |
    GNU General Public License for more details.                                |
                                                                                |
    You should have received a copy of the GNU General Public License           |
    along with this program.  If not, see <http://www.gnu.org/licenses/>.       |
                                                                                |
|                                                                               }

{$mode delphi}

interface

uses
    //uLog,
 Classes, SysUtils,math;

function pdf417( Chaine: String): String; overload;
function pdf417( Chaine: String; var secu: Integer; var nbcol: Integer; out CodeErr: Integer): String; overload;

implementation

function pdf417( Chaine: String): String; overload;
var
   secu   : Integer;
   nbcol  : Integer;
   CodeErr: Integer;
begin
     secu:= -1;
     nbcol:= -1;
     Result:= pdf417( Chaine, secu, nbcol, CodeErr);
     //Log.Println( 'pdf417( '+Chaine+', '+IntToStr(secu)+', '+IntToStr(nbcol)+', '+IntToStr(CodeErr)+') = '+Result);
end;
function pdf417( Chaine: String; var secu: Integer; var nbcol: Integer; out CodeErr: Integer): String;overload;
// traduit en pascal depuis http://grandzebu.net/informatique/codbar/pdf417.htm
//  'V 1.5.0
//  'Paramètres : Une chaine à encoder
//  '             Le niveau de correction souhaité, -1 = automatique.
//  '             Le nombre de colonnes de MC de données souhaité, -1 = automatique
//  '             Une variable qui pourra récupérer un numéro d'erreur
//  'Retour : * une chaine qui, affichée avec la police PDF417.TTF, donne le code barre
//  '         * une chaine vide si paramètre fourni incorrect
//  '         * secu contient le niveau de correction effectif
//  '         * nbcol contient le nombre de colonnes de MC de données effectif
//  '         * CodeErr contient 0 si pas d'erreur, sinon :
//  '           0 : Pas d'erreur
//  '           1  : Chaine est vide
//  '           2  : Chaine contient trop de données, on dépasse le nombre de 928 MC.
//  '           3  : Nombre de MC par ligne trop faible, on dépasse 90 lignes.
//  '           10 : Le niveau de sécurité a été abaissé pour ne pas dépasser les 928 MC.
//
//  'Parameters : The string to encode.
//  '             The hoped sécurity level, -1 = automatic.
//  '             The hoped number of data MC columns, -1 = automatic.
//  '             A variable which will can retrieve an error number.
//  'Return : * a string which, printed with the PDF417.TTF font, gives the bar code.
//  '         * an empty string if the given parameters aren't good.
//  '         * secu contain le really used sécurity level.
//  '         * nbcol contain the really used number of data CW columns.
//  '         * CodeErr is 0 if no error occured, else :
//  '           0  : No error
//  '           1  : Chaine is empty
//  '           2  : Chaine contain too many datas, we go beyong the 928 CWs.
//  '           3  : Number of CWs per row too small, we go beyong 90 rows.
//  '           10 : The sécurity level has being lowers not to exceed the 928 CWs. (It's not an error, only a warning.)
//
var
   //  'Variables générales / Global variables
   I: Integer;
   J: Integer;
   K: Integer;
   IndexChaine: Integer;
   Dummy: String;
   flag: Boolean;
   //  'Découpage en blocs / Splitting into blocks
   Liste: array of array of Integer;
   IndexListe: Integer;
   //  'Compactage des données / Data compaction
   Longueur: Integer;
   ChaineMC: String;
   LongeurChaineMC: Integer;
   sLongeurChaineMC: String;
   Total: Integer;
   //  'Traitement du mode "texte" / "text" mode processing
   ListeT: array of array of Integer;
   IndexListeT: Integer;
   CurTable: Integer;
   ChaineT: String;
   NewTable: Integer;
   //  'Codes de Reed Solomon / Reed Solomon codes
   MCcorrection: array of Integer;
   //  'MC de cotés gauche et droit / Left and right side CWs
   C1: Integer;
   C2: Integer;
   C3: Integer;
   //  'Sous programme QuelMode / Sub routine QuelMode
   Mode: Integer;
   CodeASCII: Integer;
   //  'Sous programme Modulo / Sub routine Modulo
   ChaineMod: String;
   Diviseur: Integer{long};
   ChaineMult: String;
   Nombre: Integer{long};
   //  'Tables
   ASCII: String=
   //  'Cette chaine décrit le code ASCII pour le mode "texte".
   //  'ASCII$ contient 95 champs de 4 chiffres correspondant aux car. de valeur ASCII 32 à 126. Les champs sont :
   //  '  2 chiffres indiquant la ou les tables où se trouvent ce car. (Tables numérotées 1, 2, 4 et 8)
   //  '  2 chiffres indiquant le N° du car. dans la table
   //  '  Ex. 0726 en début de chaine : le car. de code 32 est dans les tables 1, 2 et 4 à la ligne 26
   //  '
   //  'This string describe the ASCII code for the "text" mode.
   //  'ASCII$ contain 95 fields of 4 digits which correspond to char. ASCII values 32 to 126. These fields are :
   //  '  2 digits indicating the table(s) (1 or several) where this char. is located. (Table numbers : 1, 2, 4 and 8)
   //  '  2 digits indicating the char. number in the table
   //  '  Sample : 0726 at the beginning of the string : The Char. having code 32 is in the tables 1, 2 and 4 at row 26
     (*ASCII$ =*) '07260810082004151218042104100828082308241222042012131216121712190400040104020403040404050406040704080409121408000801042308020825080301000101010201030104010501060107010801090110011101120113011401150116011701180119012001210122012301240125080408050806042408070808020002010202020302040205020602070208020902100211021202130214021502160217021802190220022102220223022402250826082108270809';
   CoefRS: array[0..8] of String=
   //  'CoefRS$ contient 8 chaines représentant les coefficients sur 3 chiffres des polynomes de calcul des codes de reed Solomon
   //  'CoefRS$ contain 8 strings describing the factors of the polynomial equations for the reed Solomon codes.
     (
     (*CoefRS$(0) =*) '027917'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          ,
     (*CoefRS$(1) =*) '522568723809'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    ,
     (*CoefRS$(2) =*) '237308436284646653428379'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        ,
     (*CoefRS$(3) =*) '274562232755599524801132295116442428295042176065'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ,
     (*CoefRS$(4) =*) '361575922525176586640321536742677742687284193517273494263147593800571320803133231390685330063410'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ,
     (*CoefRS$(5) =*) '539422006093862771453106610287107505733877381612723476462172430609858822543376511400672762283184440035519031460594225535517352605158651201488502648733717083404097280771840629004381843623264543'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ,
     (*CoefRS$(6) =*) '521310864547858580296379053779897444400925749415822093217208928244583620246148447631292908490704516258457907594723674292272096684432686606860569193219129186236287192775278173040379712463646776171491297763156732095270447090507048228821808898784663627378382262380602754336089614087432670616157374242726600269375898845454354130814587804034211330539297827865037517834315550086801004108539'                                                                                                                                                                                                                                                                                                                                                                                                ,
     (*CoefRS$(7) =*) '524894075766882857074204082586708250905786138720858194311913275190375850438733194280201280828757710814919089068569011204796605540913801700799137439418592668353859370694325240216257284549209884315070329793490274877162749812684461334376849521307291803712019358399908103511051008517225289470637731066255917269463830730433848585136538906090002290743199655903329049802580355588188462010134628320479130739071263318374601192605142673687234722384177752607640455193689707805641048060732621895544261852655309697755756060231773434421726528503118049795032144500238836394280566319009647550073914342126032681331792620060609441180791893754605383228749760213054297134054834299922191910532609829189020167029872449083402041656505579481173404251688095497555642543307159924558648055497010',
     (*CoefRS$(8) =*) '352077373504035599428207409574118498285380350492197265920155914299229643294871306088087193352781846075327520435543203666249346781621640268794534539781408390644102476499290632545037858916552041542289122272383800485098752472761107784860658741290204681407855085099062482180020297451593913142808684287536561076653899729567744390513192516258240518794395768848051610384168190826328596786303570381415641156237151429531207676710089168304402040708575162864229065861841512164477221092358785288357850836827736707094008494114521002499851543152729771095248361578323856797289051684466533820669045902452167342244173035463651051699591452578037124298332552043427119662777475850764364578911283711472420245288594394511327589777699688043408842383721521560644714559062145873663713159672729'
     (*CoefRS$(8) = CoefRS$(8) &*) +'624059193417158209563564343693109608563365181772677310248353708410579870617841632860289536035777618586424833077597346269757632695751331247184045787680018066407369054492228613830922437519644905789420305441207300892827141537381662513056252341242797838837720224307631061087560310756665397808851309473795378031647915459806590731425216548249321881699535673782210815905303843922281073469791660162498308155422907817187062016425535336286437375273610296183923116667751353062366691379687842037357720742330005039923311424242749321054669316342299534105667488640672576540316486721610046656447171616464190531297321762752533175134014381433717045111020596284736138646411877669141919045780407164332899165726600325498655357752768223849647063310863251366304282738675410389244031121303263'
     );
   CodageMC: array[0..2]of String=
    //  'CodageMC$ contient les 3 jeux des 929 MC. Chaque MC est représenté dans la police PDF417.TTF par 3 lettres composant 3 fois 5 bits. Le premier bit toujours à 1
    //  ' et le dernier toujours à 0 se trouvent dans le caractère séparateur.
    //  'CodageMC$ contain the 3 sets of the 929 MCs. Each MC is described in the PDF417.TTF font by 3 char. composing 3 time 5 bits. The first bit which is always 1
    //  ' and the last one which is always 0 are into the separator character.
   (
    (*CodageMC$(0) =*) 'urAxfsypyunkxdwyozpDAulspBkeBApAseAkprAuvsxhypnkutwxgzfDAplsfBkfrApvsuxyfnkptwuwzflspsyfvspxyftwpwzfxyyrxufkxFwymzonAudsxEyolkucwdBAoksucidAkokgdAcovkuhwxazdnAotsugydlkoswugjdksosidvkoxwuizdtsowydswowjdxwoyzdwydwjofAuFsxCyodkuEwxCjclAocsuEickkocgckcckEcvAohsuayctkogwuajcssogicsgcsacxsoiycwwoijcwicyyoFkuCwxBjcdAoEsuCicckoEguCbcccoEaccEoEDchkoawuDjcgsoaicggoabcgacgDobjcibcFAoCsuBicEkoCguBbcEcoCacEEoCDcECcascagcaacCkuAroBaoBDcCBtfkwpwyezmnAtdswoymlktcwwojFBAmksFAkmvkthwwqzFnAmtstgyFlkmswFksFkgFvkmxwtizFtsmwyFswFsiFxwmyzFwyFyzvfAxpsyuyvdkxowyujqlAvcsxoiqkkvcgxobqkcvcamfAtFswmyqvAmdktEwwmjqtkvgwxqjhlAEkkmcgtEbhkkqsghkcEvAmhstayhvAEtkmgwtajhtkqwwvijhssEsghsgExsmiyhxsEwwmijhwwqyjhwiEyyhyyEyjhyjvFkxmwytjqdAvEsxmiqckvEgxmbqccvEaqcEqcCmFktCwwljqhkmEstCigtAEckvaitCbgskEccmEagscqgamEDEcCEhkmawtDjgxkEgsmaigwsqiimabgwgEgaEgDEiwmbjgywEiigyiEibgybgzjqFAvCsxliqEkvCgxlbqEcvCaqEEvCDqECqEBEFAmCstBighAEEkmCgtBbggkqagvDbggcEEEmCDggEqaDgg'
    (*CodageMC$(0) = CodageMC$(0) &*)+ 'CEasmDigisEagmDbgigqbbgiaEaDgiDgjigjbqCkvBgxkrqCcvBaqCEvBDqCCqCBECkmBgtArgakECcmBagacqDamBDgaEECCgaCECBEDggbggbagbDvAqvAnqBBmAqEBEgDEgDCgDBlfAspsweyldksowClAlcssoiCkklcgCkcCkECvAlhssqyCtklgwsqjCsslgiCsgCsaCxsliyCwwlijCwiCyyCyjtpkwuwyhjndAtoswuincktogwubncctoancEtoDlFksmwwdjnhklEssmiatACcktqismbaskngglEaascCcEasEChklawsnjaxkCgstrjawsniilabawgCgaawaCiwlbjaywCiiayiCibCjjazjvpAxusyxivokxugyxbvocxuavoExuDvoCnFAtmswtirhAnEkxviwtbrgkvqgxvbrgcnEEtmDrgEvqDnEBCFAlCssliahACEklCgslbixAagknagtnbiwkrigvrblCDiwcagEnaDiwECEBCaslDiaisCaglDbiysaignbbiygrjbCaDaiDCbiajiCbbiziajbvmkxtgywrvmcxtavmExtDvmCvmBnCktlgwsrraknCcxtrracvnatlDraEnCCraCnCBraBCCklBgskraakCCclBaiikaacnDalBDiicrbaCCCiiEaaCCCBaaBCDglBrabgCDaijgabaCDDijaabDCDrijrvlcxsqvlExsnvlCvlBnBctkqrDcnBEtknrDEvlnrDCnBBrDBCBclAqaDcCBElAnibcaDEnBnibErDnCBBibCaDBibBaDqibqibnxsfvkltkfnAmnAlCAoaBoiDoCAlaBlkpkBdAkosBckkogsebBcckoaBcEkoDBhkkqwsfjBgskqiBggkqbBgaBgDBiwkrjBiiBibBjjlpAsuswhil'
    (*CodageMC$(0) = CodageMC$(0) &*)+ 'oksuglocsualoEsuDloCBFAkmssdiDhABEksvisdbDgklqgsvbDgcBEEkmDDgElqDBEBBaskniDisBagknbDiglrbDiaBaDBbiDjiBbbDjbtukwxgyirtucwxatuEwxDtuCtuBlmkstgnqklmcstanqctvastDnqElmCnqClmBnqBBCkklgDakBCcstrbikDaclnaklDbicnraBCCbiEDaCBCBDaBBDgklrDbgBDabjgDbaBDDbjaDbDBDrDbrbjrxxcyyqxxEyynxxCxxBttcwwqvvcxxqwwnvvExxnvvCttBvvBllcssqnncllEssnrrcnnEttnrrEvvnllBrrCnnBrrBBBckkqDDcBBEkknbbcDDEllnjjcbbEnnnBBBjjErrnDDBjjCBBqDDqBBnbbqDDnjjqbbnjjnxwoyyfxwmxwltsowwfvtoxwvvtmtslvtllkossfnlolkmrnonlmlklrnmnllrnlBAokkfDBolkvbDoDBmBAljbobDmDBljbmbDljblDBvjbvxwdvsuvstnkurlurltDAubBujDujDtApAAokkegAocAoEAoCAqsAqgAqaAqDAriArbkukkucshakuEshDkuCkuBAmkkdgBqkkvgkdaBqckvaBqEkvDBqCAmBBqBAngkdrBrgkvrBraAnDBrDAnrBrrsxcsxEsxCsxBktclvcsxqsgnlvEsxnlvCktBlvBAlcBncAlEkcnDrcBnEAlCDrEBnCAlBDrCBnBAlqBnqAlnDrqBnnDrnwyowymwylswotxowyvtxmswltxlksosgfltoswvnvoltmkslnvmltlnvlAkokcfBloksvDnoBlmAklbroDnmBllbrmDnlAkvBlvDnvbrvyzeyzdwyexyuwydxytswetwuswdvxutwtvxtkselsuksdntulstrvu',
    (*CodageMC$(1) =*) 'ypkzewxdAyoszeixckyogzebxccyoaxcEyoDxcCxhkyqwzfjutAxgsyqiuskxggyqbuscxgausExgDusCuxkxiwyrjptAuwsxiipskuwgxibpscuwapsEuwDpsCpxkuywxjjftApwsuyifskpwguybfscpwafsEpwDfxkpywuzjfwspyifwgpybfwafywpzjfyifybxFAymszdixEkymgzdbxEcymaxEEymDxECxEBuhAxasyniugkxagynbugcxaaugExaDugCugBoxAuisxbiowkuigxbbowcuiaowEuiDowCowBdxAoysujidwkoygujbdwcoyadwEoyDdwCdysozidygozbdyadyDdzidzbxCkylgzcrxCcylaxCEylDxCCxCBuakxDgylruacxDauaExDDuaCuaBoikubgxDroicubaoiEubDoiCoiBcykojgubrcycojacyEojDcyCcyBczgojrczaczDczrxBcykqxBEyknxBCxBBuDcxBquDExBnuDCuDBobcuDqobEuDnobCobBcjcobqcjEobncjCcjBcjqcjnxAoykfxAmxAluBoxAvuBmuBloDouBvoDmoDlcbooDvcbmcblxAexAduAuuAtoBuoBtwpAyeszFiwokyegzFbwocyeawoEyeDwoCwoBthAwqsyfitgkwqgyfbtgcwqatgEwqDtgCtgBmxAtiswrimwktigwrbmwctiamwEtiDmwCmwBFxAmystjiFwkmygtjbFwcmyaFwEmyDFwCFysmziFygmzbFyaFyDFziFzbyukzhghjsyuczhahbwyuEzhDhDyyuCyuBwmkydgzErxqkwmczhrxqcyvaydDxqEwmCxqCwmBxqBtakwngydrviktacwnavicxrawnDviEtaCviCtaBviBmiktbgwnrqykmictb'
    (*CodageMC$(1) = CodageMC$(1) &*)+ 'aqycvjatbDqyEmiCqyCmiBqyBEykmjgtbrhykEycmjahycqzamjDhyEEyChyCEyBEzgmjrhzgEzahzaEzDhzDEzrytczgqgrwytEzgngnyytCglzytBwlcycqxncwlEycnxnEytnxnCwlBxnBtDcwlqvbctDEwlnvbExnnvbCtDBvbBmbctDqqjcmbEtDnqjEvbnqjCmbBqjBEjcmbqgzcEjEmbngzEqjngzCEjBgzBEjqgzqEjngznysozgfgfyysmgdzyslwkoycfxloysvxlmwklxlltBowkvvDotBmvDmtBlvDlmDotBvqbovDvqbmmDlqblEbomDvgjoEbmgjmEblgjlEbvgjvysegFzysdwkexkuwkdxkttAuvButAtvBtmBuqDumBtqDtEDugbuEDtgbtysFwkFxkhtAhvAxmAxqBxwekyFgzCrwecyFaweEyFDweCweBsqkwfgyFrsqcwfasqEwfDsqCsqBliksrgwfrlicsraliEsrDliCliBCykljgsrrCycljaCyEljDCyCCyBCzgljrCzaCzDCzryhczaqarwyhEzananyyhCalzyhBwdcyEqwvcwdEyEnwvEyhnwvCwdBwvBsncwdqtrcsnEwdntrEwvntrCsnBtrBlbcsnqnjclbEsnnnjEtrnnjClbBnjBCjclbqazcCjElbnazEnjnazCCjBazBCjqazqCjnaznzioirsrfyziminwrdzzililyikzygozafafyyxozivivyadzyxmyglitzyxlwcoyEfwtowcmxvoyxvwclxvmwtlxvlslowcvtnoslmvrotnmsllvrmtnlvrllDoslvnbolDmrjonbmlDlrjmnblrjlCbolDvajoCbmizoajmCblizmajlizlCbvajvzieifwrFzzididyiczygeaFzywuy'
    (*CodageMC$(1) = CodageMC$(1) &*)+ 'gdihzywtwcewsuwcdxtuwstxttskutlusktvnutltvntlBunDulBtrbunDtrbtCDuabuCDtijuabtijtziFiFyiEzygFywhwcFwshxsxskhtkxvlxlAxnBxrDxCBxaDxibxiCzwFcyCqwFEyCnwFCwFBsfcwFqsfEwFnsfCsfBkrcsfqkrEsfnkrCkrBBjckrqBjEkrnBjCBjBBjqBjnyaozDfDfyyamDdzyalwEoyCfwhowEmwhmwElwhlsdowEvsvosdmsvmsdlsvlknosdvlroknmlrmknllrlBboknvDjoBbmDjmBblDjlBbvDjvzbebfwnpzzbdbdybczyaeDFzyiuyadbhzyitwEewguwEdwxuwgtwxtscustuscttvustttvtklulnukltnrulntnrtBDuDbuBDtbjuDbtbjtjfsrpyjdwrozjcyjcjzbFbFyzjhjhybEzjgzyaFyihyyxwEFwghwwxxxxschssxttxvvxkkxllxnnxrrxBBxDDxbbxjFwrmzjEyjEjbCzjazjCyjCjjBjwCowCmwClsFowCvsFmsFlkfosFvkfmkflArokfvArmArlArvyDeBpzyDdwCewauwCdwatsEushusEtshtkdukvukdtkvtAnuBruAntBrtzDpDpyDozyDFybhwCFwahwixsEhsgxsxxkcxktxlvxAlxBnxDrxbpwnuzboybojDmzbqzjpsruyjowrujjoijobbmyjqybmjjqjjmwrtjjmijmbbljjnjjlijlbjkrsCusCtkFukFtAfuAftwDhsChsaxkExkhxAdxAvxBuzDuyDujbuwnxjbuibubDtjbvjjusrxijugrxbjuajuDbtijvibtbjvbjtgrwrjtajtDbsrjtrjsqjsnBxjDxiDxbbxgnyrbxabxDDwrbxrbwqbwn',
    (*CodageMC$(2) =*) 'pjkurwejApbsunyebkpDwulzeDspByeBwzfcfjkprwzfEfbspnyzfCfDwplzzfBfByyrczfqfrwyrEzfnfnyyrCflzyrBxjcyrqxjEyrnxjCxjBuzcxjquzExjnuzCuzBpzcuzqpzEuznpzCdjAorsufydbkonwudzdDsolydBwokzdAyzdodrsovyzdmdnwotzzdldlydkzynozdvdvyynmdtzynlxboynvxbmxblujoxbvujmujlozoujvozmozlcrkofwuFzcnsodyclwoczckyckjzcucvwohzzctctycszylucxzyltxDuxDtubuubtojuojtcfsoFycdwoEzccyccjzchchycgzykxxBxuDxcFwoCzcEycEjcazcCycCjFjAmrstfyFbkmnwtdzFDsmlyFBwmkzFAyzFoFrsmvyzFmFnwmtzzFlFlyFkzyfozFvFvyyfmFtzyflwroyfvwrmwrltjowrvtjmtjlmzotjvmzmmzlqrkvfwxpzhbAqnsvdyhDkqlwvczhBsqkyhAwqkjhAiErkmfwtFzhrkEnsmdyhnsqtymczhlwEkyhkyEkjhkjzEuEvwmhzzhuzEthvwEtyzhthtyEszhszyduExzyvuydthxzyvtwnuxruwntxrttbuvjutbtvjtmjumjtgrAqfsvFygnkqdwvEzglsqcygkwqcjgkigkbEfsmFygvsEdwmEzgtwqgzgsyEcjgsjzEhEhyzgxgxyEgzgwzycxytxwlxxnxtDxvbxmbxgfkqFwvCzgdsqEygcwqEjgcigcbEFwmCzghwEEyggyEEjggjEazgizgFsqCygEwqCjgEigEbECygayECjgajgCwqBjgCigCbEBjgDjgBigBbCrklfwspzCnsldyClwlczCkyCkjzCuCvwlhzzCtCtyCszyFuCx'
    (*CodageMC$(2) = CodageMC$(2) &*)+ 'zyFtwfuwftsrusrtljuljtarAnfstpyankndwtozalsncyakwncjakiakbCfslFyavsCdwlEzatwngzasyCcjasjzChChyzaxaxyCgzawzyExyhxwdxwvxsnxtrxlbxrfkvpwxuzinArdsvoyilkrcwvojiksrciikgrcbikaafknFwtmzivkadsnEyitsrgynEjiswaciisiacbisbCFwlCzahwCEyixwagyCEjiwyagjiwjCazaiziyzifArFsvmyidkrEwvmjicsrEiicgrEbicaicDaFsnCyihsaEwnCjigwrajigiaEbigbCCyaayCCjiiyaajiijiFkrCwvljiEsrCiiEgrCbiEaiEDaCwnBjiawaCiiaiaCbiabCBjaDjibjiCsrBiiCgrBbiCaiCDaBiiDiaBbiDbiBgrAriBaiBDaAriBriAqiAnBfskpyBdwkozBcyBcjBhyBgzyCxwFxsfxkrxDfklpwsuzDdsloyDcwlojDciDcbBFwkmzDhwBEyDgyBEjDgjBazDizbfAnpstuybdknowtujbcsnoibcgnobbcabcDDFslmybhsDEwlmjbgwDEibgiDEbbgbBCyDayBCjbiyDajbijrpkvuwxxjjdArosvuijckrogvubjccroajcEroDjcCbFknmwttjjhkbEsnmijgsrqinmbjggbEajgabEDjgDDCwlljbawDCijiwbaiDCbjiibabjibBBjDDjbbjjjjjFArmsvtijEkrmgvtbjEcrmajEErmDjECjEBbCsnlijasbCgnlbjagrnbjaabCDjaDDBibDiDBbjbibDbjbbjCkrlgvsrjCcrlajCErlDjCCjCBbBgnkrjDgbBajDabBDjDDDArbBrjDrjBcrkqjBErknjBCjBBbAqjBqbAnjBnjAorkfjAmjAlb'
    (*CodageMC$(2) = CodageMC$(2) &*)+ 'AfjAvApwkezAoyAojAqzBpskuyBowkujBoiBobAmyBqyAmjBqjDpkluwsxjDosluiDoglubDoaDoDBmwktjDqwBmiDqiBmbDqbAljBnjDrjbpAnustxiboknugtxbbocnuaboEnuDboCboBDmsltibqsDmgltbbqgnvbbqaDmDbqDBliDniBlbbriDnbbrbrukvxgxyrrucvxaruEvxDruCruBbmkntgtwrjqkbmcntajqcrvantDjqEbmCjqCbmBjqBDlglsrbngDlajrgbnaDlDjrabnDjrDBkrDlrbnrjrrrtcvwqrtEvwnrtCrtBblcnsqjncblEnsnjnErtnjnCblBjnBDkqblqDknjnqblnjnnrsovwfrsmrslbkonsfjlobkmjlmbkljllDkfbkvjlvrsersdbkejkubkdjktAeyAejAuwkhjAuiAubAdjAvjBuskxiBugkxbBuaBuDAtiBviAtbBvbDuklxgsyrDuclxaDuElxDDuCDuBBtgkwrDvglxrDvaBtDDvDAsrBtrDvrnxctyqnxEtynnxCnxBDtclwqbvcnxqlwnbvEDtCbvCDtBbvBBsqDtqBsnbvqDtnbvnvyoxzfvymvylnwotyfrxonwmrxmnwlrxlDsolwfbtoDsmjvobtmDsljvmbtljvlBsfDsvbtvjvvvyevydnwerwunwdrwtDsebsuDsdjtubstjttvyFnwFrwhDsFbshjsxAhiAhbAxgkirAxaAxDAgrAxrBxckyqBxEkynBxCBxBAwqBxqAwnBxnlyoszflymlylBwokyfDxolyvDxmBwlDxlAwfBwvDxvtzetzdlyenyulydnytBweDwuBwdbxuDwtbxttzFlyFnyhBwFDwhbwxAiqAinAyokjfAymAylAifAyvkzekzdAyeByuAydBytszp'
    );
   double_break: boolean;
   procedure QuelMode;
   begin
        CodeASCII:= Ord(Chaine[IndexChaine]);
        case CodeASCII
        of
          48..57                    : Mode:= 902;
          9, 10, 13, 32..47, 58..126: Mode:= 900;
          else                        Mode:= 901;
          end;
   end;
   procedure Regroupe;
   begin
        //'Regrouper les blocs de même type / Bring together same type blocks
        if IndexListe > 1
        then
            begin
            I:= 1;
            while I < IndexListe
            do
              begin
              if Liste[1, I - 1] = Liste[1, I]
              then
                  begin
                  //'Regroupement / Bringing together
                  Liste[0, I - 1]:= Liste[0, I - 1] + Liste[0, I];
                  J:= I + 1;
                  //'Réduction de la liste / Decrease the list
                  while J < IndexListe
                  do
                    begin
                    Liste[0, J - 1]:= Liste[0, J];
                    Liste[1, J - 1]:= Liste[1, J];
                    Inc(J);
                    end;
                  Dec( IndexListe);
                  Dec( I);
                  end;
              Inc( I);
              end;
            end;
   end;
   procedure Modulo;
   begin
        //'ChaineMod représente un très grand nombre sur plus de 9 chiffres
        //'Diviseur est le diviseur, contient le résultat au retour
        //'ChaineMult contient au retour le résultat de la division entière
        //'
        //'ChaineMod depict a very large number having more than 9 digits
        //'Diviseur is the divisor, contain the result after return
        //'ChaineMult contain after return the result of the integer division
        ChaineMult:= '';
        Nombre:= 0;
        while ChaineMod <> ''
        do
          begin
          Nombre:= Nombre * 10 + StrToInt( ChaineMod[1]); //'Abaisse un chiffre / Put down a digit
          Delete( ChaineMod, 1, 1);
          if Nombre < Diviseur
          then
              begin
              if ChaineMult <> '' then ChaineMult:= ChaineMult + '0';
              end
          else
              ChaineMult:= ChaineMult + IntToStr( Nombre div Diviseur);

          Nombre:= Nombre mod Diviseur; //'Récupère le reste / get the remainder
          end;
        Diviseur:= Nombre;
   end;
begin
     ChaineMC:= '';
     CodeErr:= 0;
     if Chaine = ''
     then
         begin
         CodeErr:= 1;
         Exit;
         end;

     IndexListe:= 0;

     //  'Découper la chaine en blocs de caractère de même type : numérique , texte, octet
     //  'La 1ère colonne du tableau Liste contient le nombre de caractères, la 2ème le commutateur de mode
     //  'Split the string in character blocks of the same type : numeric , text, byte
     //  'The first column of the array Liste contain the char. number, the second one contain the mode switch
     IndexChaine:= 1;
     QuelMode;
     repeat
           double_break:= False;
           SetLength( Liste, 1+1, IndexListe+1);
           Liste[1, IndexListe]:= Mode;
           while Liste[1, IndexListe] = Mode
           do
             begin
             Inc( Liste[0, IndexListe]);
             Inc( IndexChaine);
             double_break:= IndexChaine > Length(Chaine);
             if double_break then break;
             QuelMode;
             end;
           //if double_break then break;
           Inc( IndexListe);
     until IndexChaine > Length(Chaine);
     //  'Ne garder le mode numérique que si c'est "rentable", sinon mode "texte" voire "octet"
     //  'Les seuils de rentabilité ont étés pré-déterminés selon le mode précédent et/ou le mode suivant
     //  'We retain "numeric" mode only if it's earning, else "text" mode or even "byte" mode
     //  'The efficiency limits have been pre-defined according to the previous mode and/or the next mode.
     for I:= 0 to IndexListe - 1
     do
       begin
       if 902 = Liste[1, I]
       then
           if I = 0
           then //'C'est le premier bloc / It's the first block
               begin
               if IndexListe > 1
               then //'et il y en a d'autres derrière / And there is other blocks behind
                   begin
                        if 900 = Liste[1, I + 1]
                   then
                       begin
                       //'Premier bloc et suivi par un bloc de type "texte" / First block and followed by a "text" type block
                       if Liste[0, I] < 8 then Liste[1, I]:= 900;
                       end
                   else if 901 = Liste[1, I + 1]
                   then
                       begin
                       //'Premier bloc et suivi par un bloc de type "octet" / First block and followed by a "byte" type block
                       if Liste[0, I] = 1 then Liste[1, I]:= 901;
                       end;
                   end;
               end
           else
               begin
               //'C'est pas le premier bloc / It's not the first block
               if I = IndexListe - 1
               then
                   begin
                   //'C'est le dernier / It's the last one
                   if Liste[1, I - 1] = 900
                   then
                       begin
                       //'Il est précédé par un bloc de type "texte" / It's  preceded by a "text" type block
                       if Liste[0, I] < 7 then Liste[1, I]:= 900;
                       end
                   else if Liste[1, I - 1] = 901
                   then
                       begin
                       //'Il est précédé par un bloc de type "octet" / It's  preceded by a "byte" type block
                       if Liste[0, I] = 1 then Liste[1, I]:= 901;
                       end;
                   end
               else
                   begin
                   //'C'est pas le dernier / It's not the last block
                   if (Liste[1, I - 1] = 901) and (Liste[1, I + 1] = 901)
                   then
                       begin
                       //'Encadré par des blocs de type "octet" / Framed by "byte" type blocks
                       if Liste[0, I] < 4 then Liste[1, I]:= 901;
                       end
                   else if (Liste[1, I - 1] = 900) and (Liste[1, I + 1] = 901)
                   then
                       begin
                       //'Précédé par "texte" et suivi par "octet" (Si l'inverse jamais intéressant de changer)
                       //'Preceded by "text" and followed by "byte" (If the reverse it's never interesting to change)
                       if Liste[0, I] < 5 then Liste[1, I]:= 900;
                       end
                   else if (Liste[1, I - 1] = 900) and (Liste[1, I + 1] = 900)
                   then
                       begin
                       //'Encadré par des blocs de type "texte" / Framed by "text" type blocks
                       if Liste[0, I] < 8 then Liste[1, I]:= 900;
                       end;
                   end;
               end;
       end;

     Regroupe;
     //'Ne garder le mode "texte" que si c'est rentable / Maintain "text" mode only if it's earning
     for I:= 0 to IndexListe - 1
     do
       begin
       if (Liste[1, I] = 900) and (I > 0)
       then
           begin
           //'C'est pas le premier (Si 1er jamais intéressant de changer) / It's not the first (If first, never interesting to change)
           if I = IndexListe - 1
           then //'C'est le dernier / It's the last one
               begin
               if Liste[1, I - 1] = 901
               then
                   begin
                   //'Précédé par un bloc de type "octet" / It's  preceded by a "byte" type block
                   if Liste[0, I] = 1 then Liste[1, I]:= 901;
                   end;
               end
           else
               begin
               //'C'est pas le dernier / It's not the last one
               if (Liste[1, I - 1] = 901) and (Liste[1, I + 1] = 901)
               then
                   begin
                   //'Encadré par des blocs de type "octet" / Framed by "byte" type blocks
                   if Liste[0, I] < 5 then Liste[1, I]:= 901;
                   end
               else if ((Liste[1, I - 1] = 901) and (Liste[1, I + 1] <> 901)) or ((Liste[1, I - 1] <> 901) and (Liste[1, I + 1] = 901))
               then
                   begin
                   //'Un bloc "octet" devant ou derrière / A "byte" block ahead or behind
                   if Liste[0, I] < 3 then Liste[1, I]:= 901;
                   end;
               end;
           end;
       end;
     Regroupe;
     //'Maintenant on compacte les données dans les MC, les MC sont stockées sur 3 car. dans une grande chaine : ChaineMC
     //'Now we compress datas into the MCs, the MCs are stored in 3 char. in a large string : ChaineMC
     IndexChaine:= 1;
     for I:= 0 to IndexListe - 1
     do
       begin
       //'Donc 3 modes de compactage / Thus 3 compaction modes
       case Liste[1, I]
       of
         900: //'Texte
           begin
           SetLength( ListeT, 1+1, Liste[0, I]+1);
           //'ListeT contiendra le numéro de table(s) et la valeur de chaque caractère
           //'Numéros de table codés sur les 4 bits de poids faibles, soit en décimal 1, 2, 4, 8
           //'ListeT will contain the table number(s) (1 ou several) and the value of each char.
           //'Table number encoded in the 4 less weight bits, that is in decimal 1, 2, 4, 8
           for IndexListeT:= 0 to Liste[0, I] - 1
           do
             begin
             CodeASCII:= Ord(Chaine[ IndexChaine + IndexListeT]);
             case CodeASCII
             of
               9: //'HT
                 begin
                 ListeT[0, IndexListeT]:= 12;
                 ListeT[1, IndexListeT]:= 12;
                 end;
               10: //'LF
                 begin
                 ListeT[0, IndexListeT]:=  8;
                 ListeT[1, IndexListeT]:= 15;
                 end;
               13: //'CR
                 begin
                 ListeT[0, IndexListeT]:= 12;
                 ListeT[1, IndexListeT]:= 11;
                 end;
               else
                 begin
                 ListeT[0, IndexListeT]:= StrToInt(Copy(ASCII, CodeASCII * 4 - 127, 2));
                 ListeT[1, IndexListeT]:= StrToInt(Copy(ASCII, CodeASCII * 4 - 125, 2));
                 end;
               end;
             end;
           CurTable:= 1; //'Table par défaut / Default table
           ChaineT:= '';
           //'Les données sont stockées sur 2 car. dans la chaine TableT$ / Datas are stored in 2 char. in the string TableT$
           for J:= 0 to Liste[0, I] - 1
           do
             begin
             if (ListeT[0, J] and CurTable) > 0
             then
                 //'Le car. est dans la table courante / The char. is in the current table
                 ChaineT:= ChaineT + Format( '%.2d', [ListeT[1, J]])
             else
                 begin
                 //'Faut changer de table / Obliged to change the table
                 flag:= False; //'True si on change de table pour un seul car. / True if we change the table only for 1 char.
                 if J = Liste[0, I] - 1
                 then
                     flag:= True
                 else
                     begin
                     if (ListeT[0, J] and ListeT[0, J + 1]) = 0 then flag:= True; //'Pas de table commune avec le car. suivant / No common table with the next char.
                     end;
                 if flag
                 then
                     begin
                     //'On change de table pour 1 seul car., Chercher un commutateur fugitif
                     //'We change only for 1 char., Look for a temporary switch
                     if ((ListeT[0, J] and 1) > 0) and (CurTable = 2)
                     then
                         //'Table 2 vers 1 pour 1 car. --> T_MAJ / Table 2 to 1 for 1 char. --> T_UPP
                         ChaineT:= ChaineT + '27' + Format( '%.2d', [ListeT[1, J]])
                     else if (ListeT[0, J] and 8) > 0
                     then
                         //'Table 1 ou 2 ou 4 vers table 8 pour 1 car. --> T_PON / Table 1 or 2 or 4 to table 8 for 1 char. --> T_PUN
                         ChaineT:= ChaineT + '29' + Format( '%.2d', [ListeT[1, J]])
                     else
                         //'Pas de commutateur fugitif / No temporary switch available
                         flag:= False;
                     end;
                 if not flag
                 then //'On re-teste flag qui a peut-être changé ci-dessus ! donc ELSE pas possible / We test again flag which is perhaps changed ! Impossible tio use ELSE statement
                     begin
                     //'
                     //'On doit utiliser un commutateur à basculement
                     //'Déterminer la nouvelle table à utiliser
                     //'We must use a bi-state switch
                     //'Looking for the new table to use
                     if J = Liste[0, I] - 1
                     then
                         NewTable:= ListeT[0, J]
                     else
                         NewTable:= ifthen( (ListeT[0, J] and ListeT[0, J + 1]) = 0, ListeT[0, J], ListeT[0, J] and ListeT[0, J + 1]);
                     //'Ne garder que la première s'il y en a plusieurs de possible / Maintain the first if several tables are possible
                     case NewTable
                     of
                       3, 5, 7, 9, 11, 13, 15: NewTable:= 1;
                       6, 10, 14             : NewTable:= 2;
                       12                    : NewTable:= 4;
                       end;
                     //'Choisir le commutateur, parfois il faut 2 commutateurs de suite / Select the switch, on occasion we must use 2 switchs consecutively
                     case CurTable
                     of
                       1:
                         case NewTable
                         of
                           2: ChaineT:= ChaineT + '27';
                           4: ChaineT:= ChaineT + '28';
                           8: ChaineT:= ChaineT + '2825';
                           end;
                       2:
                         case NewTable
                         of
                           1: ChaineT:= ChaineT + '2828';
                           4: ChaineT:= ChaineT + '28';
                           8: ChaineT:= ChaineT + '2825';
                           end;
                       4:
                         case NewTable
                         of
                           1: ChaineT:= ChaineT + '28';
                           2: ChaineT:= ChaineT + '27';
                           8: ChaineT:= ChaineT + '25';
                           end;
                       8:
                         case NewTable
                         of
                           1: ChaineT:= ChaineT + '29';
                           2: ChaineT:= ChaineT + '2927';
                           4: ChaineT:= ChaineT + '2928';
                           end;
                       end;
                     CurTable:= NewTable;
                     ChaineT:= ChaineT + Format( '%.2d', [ListeT[1, J]]); //'On ajoute enfin le car. / At last we add the char.
                     end;//if
                 end;//if
             end;//for
           if Length(ChaineT) Mod 4 > 0 then ChaineT:= ChaineT + '29'; //'Bourrage si nb de car. impair / Padding if number of char. is odd
           //'Maintenant traduire la chaine ChaineT en MCs
           //'Now translate the string ChaineT into CWs
           if I > 0 then ChaineMC:= ChaineMC + '900'; //'Mettre en place le commutateur sauf si premier bloc car mode "texte" par défaut / Set up the switch exept for the first block because "text" is the default
           for J:= 1 to Length(ChaineT) (*Step 4*)
           do
             if (1 = J mod 4)//traduction rapide du step 4
             then
                 ChaineMC:= ChaineMC + Format( '%.3d', [StrToInt( Copy(ChaineT, J, 2)) * 30 + StrToInt( Copy(ChaineT, J + 2, 2))]);
           end;
         901: //'Octet
           //'Choisir le commutateur parmi les 3 possibles / Select the switch between the 3 possible
           if Liste[0, I] = 1
           then
               //'1 seul octet, c'est immédiat
               ChaineMC:= ChaineMC + '913' + Format('%.3d', [Ord(Chaine[IndexChaine])])
           else
               begin
               //'Choisir le commutateur selon qu'on a un multiple de 6 octets ou non
               //'Select the switch for perfect multiple of 6 bytes or no
               if Liste[0, I] Mod 6 = 0
               then
                   ChaineMC:= ChaineMC + '924'
               else
                   ChaineMC:= ChaineMC + '901';
               J:= 0;
               while J < Liste[0, I]
               do
                 begin
                 Longueur:= Liste[0, I] - J;
                 if Longueur >= 6
                 then
                     begin
                     //'prendre des paquets de 6 /Take groups of 6
                     Longueur:= 6;
                     Total:= 0;
                     for K:= 0 to Longueur - 1
                     do
                       Total:= Total + (Ord(Chaine[IndexChaine + J + K]) * Trunc(power(256, Longueur - 1 - K)));
                     ChaineMod:= IntToStr( Total);
                     Dummy:= '';
                     repeat
                           Diviseur:= 900;
                           Modulo;
                           Dummy:= Format('%.3d',[Diviseur]) + Dummy;
                           ChaineMod:= ChaineMult;
                     until ChaineMult = '';
                     ChaineMC:= ChaineMC + Dummy;
                     end
                 else
                     begin
                     //'S'il reste un paquet de moins de 6 octets / If it remain a group of less than 6 bytes
                     for K:= 0 to Longueur - 1
                     do
                       ChaineMC:= ChaineMC + Format('%.3d',[Ord(Chaine[ IndexChaine + J + K])]);
                     end;
                 J:= J + Longueur;
                 end;
               end;
         902: //'Numérique / Numeric
           begin
           ChaineMC:= ChaineMC + '902';
           J:= 0;
           while J < Liste[0, I]
           do
             begin
             Longueur:= Liste[0, I] - J;
             if Longueur > 44 then Longueur:= 44;
             ChaineMod:= '1' + Copy(Chaine, IndexChaine + J, Longueur);
             Dummy:= '';
             repeat
               Diviseur:= 900;
               Modulo;
               Dummy:= Format('%.3d',[Diviseur]) + Dummy;
               ChaineMod:= ChaineMult;
               if ChaineMult = '' then break;
             until False;
             ChaineMC:= ChaineMC + Dummy;
             J:= J + Longueur;
             end;
           //Log.PrintLn( 'uCode_barre_pdf417::pdf417: ChaineMC='+ChaineMC);
           end;
         end;//case
       IndexChaine:= IndexChaine + Liste[0, I];
       end;//for principal
     //'ChaineMC contient la liste des MC (sur 3 chiffres) représentant les données
     //'On s'occupe maintenant du niveau de correction
     //'ChaineMC contain the MC list (on 3 digits) depicting the datas
     //'Now we take care of the correction level
     Longueur:= Length(ChaineMC) div 3;
     if secu < 0
     then
         begin
         //'Détermination auto. du niveau de correction en fonction des recommandations de la norme
         //'Fixing auto. the correction level according to the standard recommendations
              if Longueur <  41 then secu:= 2
         else if Longueur < 161 then secu:= 3
         else if Longueur < 321 then secu:= 4
         else                        secu:= 5;
         end;
     //'On s'occupe maintenant du nombre de MC par ligne / Now we take care of the number of CW per row
     Longueur:= Longueur + 1 + trunc( power(2 , (secu + 1)));
     if nbcol > 30 then nbcol:= 30;
     if nbcol < 1
     then
         begin
         //'Avec une police haute de 3 modules, pour obtenir un code-barre "carré"
         //'x = nb. de col. | Largeur en module = 69 + 17x | Hauteur en module = 3t / x (t étant le nb total de MC)
         //'On a donc 69 + 17x = 3t/x <=> 17x²+69x-3t=0 - Le discriminant est 69²-4*17*-3t = 4761+204t donc x=SQR(discr.)-69/2*17
         //'
         //'With a 3 modules high font, for getting a "square" bar code
         //'x = nb. of col. | Width by module = 69 + 17x | Height by module = 3t / x (t is the total number of MCs)
         //'Thus we have 69 + 17x = 3t/x <=> 17x²+69x-3t=0 - Discriminant is 69²-4*17*-3t = 4761+204t thus x=SQR(discr.)-69/2*17
         nbcol:= Trunc( (Sqrt(204 * Longueur + 4761) - 69) / (34 / 1.3));   //'1.3 = coeff. de pondération déterminé au pif après essais / 1.3 = balancing factor determined at a guess after tests
         if nbcol = 0 then nbcol:= 1;
         end;
     //'Si on dépasse 928 MC on essaye de réduire le niveau de correction
     //'If we go beyong 928 CWs we try to reduce the correction level
     while secu > 0
     do
       begin
       //'Calcul du nombre total de MC en tenant compte du rembourrage pour compléter les lignes
       //'Calculation of the total number of CW with the padding
       Longueur:= Length(ChaineMC) div 3 + 1 + Trunc(power(2, (secu + 1)));
       Longueur:= (Longueur div nbcol + ifthen(Longueur mod nbcol > 0, 1, 0)) * nbcol;
       if Longueur < 929 then break;
       //'On doit réduire le niveau de sécurité pour tout faire rentrer
       //'We must reduce security level
       secu:= secu - 1;
       CodeErr:= 10;
       end;
     if Longueur > 928        then begin CodeErr:= 2; exit; end;
     if Longueur / nbcol > 90 Then begin CodeErr:= 3; exit; end;
     //'Calcul du rembourrage / Padding calculation
     Longueur:= Length(ChaineMC) div 3 + 1 + Trunc(power(2, (secu + 1)));
     I:= 0;
          if Longueur div nbcol < 3 then I:= nbcol * 3 - Longueur   //'Il faut au moins 3 lignes dans le code / A bar code must have at least 3 row
     else if Longueur mod nbcol > 0 then I:= nbcol - (Longueur Mod nbcol);

     //'On ajoute le rembourrage / We add the padding
     while I > 0
     do
       begin
       ChaineMC:= ChaineMC + '900';
       I:= I - 1;
       end;
     //'On ajoute le descripteur de longueur / We add the length descriptor
     LongeurChaineMC:= Length(ChaineMC) div 3 + 1;
     sLongeurChaineMC:= Format('%.3d',[LongeurChaineMC]);
     ChaineMC:= sLongeurChaineMC + ChaineMC;
     //'On s'occupe maintenant des codes de Reed Solomon / Now we take care of the Reed Solomon codes
     Longueur:= Length(ChaineMC) div 3;
     K:= Trunc( power( 2 , (secu + 1)));
     SetLength( MCcorrection, K - 1 +1);
     Total:= 0;
     for I:= 0 to Longueur - 1
     do
       begin
       Total:= ( StrToInt( Copy(ChaineMC, I * 3 + 1, 3)) + MCcorrection[K - 1]) mod 929;
       for J:= K - 1 downto 0 //Step -1
       do
         if J = 0
         then
             MCcorrection[J]:= (929 - (Total * StrToInt(Copy(CoefRS[secu], J * 3 + 1, 3))) mod 929) mod 929
         else
             MCcorrection[J]:= (MCcorrection[J - 1] + 929 - (Total * StrToInt(Copy(CoefRS[secu], J * 3 + 1, 3))) mod 929) mod 929;
       end;
     for J:= 0 to K - 1
     do
       if MCcorrection[J] <> 0
       then
           MCcorrection[J]:= 929 - MCcorrection[J];

     //'On va ajouter les codes de correction à la chaine / We add theses codes to the string
     for I:= K - 1 downto 0 //Step -1
     do
       ChaineMC:= ChaineMC + Format( '%.3d', [MCcorrection[I]]);

     //'La chaine des MC est terminée
     //'Calcul des paramètres pour les MC de cotés gauche et droit
     //'The CW string is finished
     //'Calculation of parameters for the left and right side CWs
     C1:= (Length(ChaineMC) div 3 div nbcol - 1) div 3;
     C2:= secu * 3 + (Length(ChaineMC) div 3 div nbcol - 1) Mod 3;
     C3:= nbcol - 1;
     Result:= '';
     //'On encode chaque ligne / We encode each row
     for I:= 0 to Length(ChaineMC) div 3 div nbcol - 1
     do
       begin
       Dummy:= Copy( ChaineMC, I * nbcol * 3 + 1, nbcol * 3);
       K:= (I div 3) * 30;
       case I mod 3
       of
         0: Dummy:= Format('%.3d', [K + C1]) + Dummy + Format('%.3d', [K + C3]);
         1: Dummy:= Format('%.3d', [K + C2]) + Dummy + Format('%.3d', [K + C1]);
         2: Dummy:= Format('%.3d', [K + C3]) + Dummy + Format('%.3d', [K + C2]);
         end;
       Result:= Result + '+*'; //'Commencer par car. de start et séparateur / Start with a start char. and a separator
       for J:= 0 to Length(Dummy) div 3 - 1
       do
         Result:= Result + Copy(CodageMC[I Mod 3], StrToInt(Copy(Dummy, J * 3 + 1, 3)) * 3 + 1, 3) + '*';
       Result:= Result + '-'#13#10; //'Ajouter car. de stop et CRLF / Add a stop char. and a CRLF
       end;
end;


end.

