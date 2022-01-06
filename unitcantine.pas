
//Unit en charge de la cantine
unit unitCantine;
{$codepage utf8}
{$mode objfpc}{$H+}

interface
//----- FONCTIONS ET PROCEDURES -----
uses
  unitLieu,crtperso,sysutils,unitPersonnage,unitIHM,GestionEcran,Math;

type
    recette = record
    nomR:string;
    effet:integer;
    end;

CatalogueRecette = array[1..5000] of recette;

var
    tRecette : CatalogueRecette;  //tableau de recettes

//Fonction exécutée à l'arrivée dans la cantine
//Renvoie le prochain lieu à visiter
function cantineHUB() : typeLieu;

procedure initialiationRecettes();

//renvoi vrai si le premier parametre est plus petit (alphabetiquement)
function compareNames(a, b : string): boolean;

//procedures pricipales pour le tri à fusion
procedure TriFusionRecette (var tRecette: CatalogueRecette; debut, fin: integer);
procedure TriFusionBonus (var tRecette: CatalogueRecette; debut, fin: integer);

//procedures pour la fusion
procedure FusionRecette (var tRecette: CatalogueRecette; debut, millieu, fin : integer);
procedure FusionBonus (var tRecette: CatalogueRecette; debut, millieu, fin : integer);



implementation



//Remplis le tableau de toutes les recettes
procedure initialiationRecettes();
var
fichier:text;
i,j:integer;
ligne:string;

begin
  assign(fichier, 'Recettes.txt');
  reset(fichier);


  for i:= 1 to 5000 do
  begin
       readln(fichier,ligne);
       tRecette[i].nomR:=' ';
       j:=0;

       while (ligne[j]<>'/') do
       begin

            tRecette[i].nomR:=tRecette[i].nomR+ligne[j];
            j:=j+1;

       end;


       if ligne[length(tRecette[i].nomR)+1]='C' then
       tRecette[i].effet:=3
       else if ligne[length(tRecette[i].nomR)+1]='R' then
       tRecette[i].effet:=2
       else if ligne[length(tRecette[i].nomR)+1]='F' then
       tRecette[i].effet:=1;




  end;
  close(fichier);


end;

//Mange le plat et applique le bonus
procedure manger(nbPlat : integer);
begin
     //Fixe le buff
     setBuff(bonus(nbPlat));
end;
function effetToString(nb:integer) : String;
begin
  case tRecette[nb].effet of
       1:effetToString:='(Force)       ';
       2:effetToString:='(Regénération)';
       3:effetToString:='(Critique)    ';
  end;
end;
//Fonction exécutée pour afficher l'écran d'affichage des recettes
//Renvoie le prochain lieu à visiter
function choixRecette() : typeLieu;
var
  choix : string;
  choixNumber,page,i,y : integer;
  Ch : Char;
  tri:integer;
begin
  choix := '';
  page:=0;

  while (choix <> '0') do
  begin
    afficherInterfacePrincipale();
    afficherLieu('Cantine de la ville de Brightwood');

    deplacerCurseurXY(63,5);write('Le cuisinier vous proposent :');
    couleurTexte(Cyan);
    deplacerCurseurXY(13,8);write('Plat');
    deplacerCurseurXY(96,8);write('Bonus');

    couleurTexte(White);

    deplacerCurseurXY(110,24);write('Trié par : Aucun    ');

    deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
    deplacerCurseurZoneAction(3);write('     ?/ Commander un plat (entrer son numéro)');

    deplacerCurseurZoneAction(6);write('     0/ Retourner sur la place principale');
    deplacerCurseurXY(85,33);write('Haut/Bas > trier les recettes');
    deplacerCurseurXY(85,36);write('Gauche/Droite >  changer de page');
    repeat



    deplacerCurseurXY(50,25);write('Page : ',page,' ');
    y:=10;

    for i:= 1+page*10 to 1+page*10+9 do
    begin
         deplacerCurseurXY(13,y);
         write(i, '/ ',tRecette[i].nomR,'                               ');

         deplacerCurseurXY(96,y);
         write(effetToString(i));
         y:=y+1;
    end;


    Ch := ReadKey;

    case Ch of
    #0: case ReadKey of    { Le code est #0, on appelle à nouveau ReadKey }

        #77:    begin                     // Droite
                     if page<499 then
                     page:=page+1;
                end;

        #75:    begin                     // Gauche
                     if page>0 then
                     page:=page-1;
                end;

        #72,#80:    begin                     // Haut / BAS
                     tri:=tri+1;
                     page:=0;
                     if tri mod 2 = 0 then
                     begin
                          TriFusionRecette (tRecette, low(tRecette), high(tRecette));
                          deplacerCurseurXY(110,24);write('Trié par : Ordre Alphabétique');
                     end
                     else if tri mod 2 = 1 then
                     begin
                          TriFusionBonus (tRecette, low(tRecette), high(tRecette));
                          deplacerCurseurXY(110,24);write('Trié par : Bonus              ');
                     end;
                end;


        end
    else
        begin

        deplacerCurseurXY(141,37);
        readln(choix);

        if (choix = '0' ) then
        ChoixRecette := ville

        else if(TryStrToInt(choix,choixNumber)) then
             begin
             if(choixNumber > 0) and (choixNumber < 5001) then
             manger(tRecette[choixNumber].effet);
             end;
        afficherCadreResponse();
        deplacerCurseurXY(155,32);Write('      Buff : ',bonusToString(getPersonnage().buff),'      ');
        end;
 end;

 until choixRecette=ville;


  end;
end;

//Fonction exécutée à l'arrivée dans la cantine
//Renvoie le prochain lieu à visiter
function cantineHUB() : typeLieu;
var choix : string;
begin
  choix := '';
  while (choix <> '0') and (choix <> '1') do
  begin
    afficherInterfacePrincipale();
    afficherLieu('Cantine de la ville de Brightwood');

    deplacerCurseurXY(30,7);write('Alors que vous approchez de la cantine, l''air s''emplit d''un épais fumet. Viandes, poissons,');
    deplacerCurseurXY(30,8);write('fruits et légumes dont certains vous sont inconnus sont exposés sur les nombreuses tables');
    deplacerCurseurXY(30,9);write('qui entourent une cuisine de fortune où des palicos s''affairent à préparer des mets aussi');
    deplacerCurseurXY(30,10);write('généreux qu''appétissants.');

    deplacerCurseurXY(30,12);write('Vous apercevez de nombreux chasseurs assis aux différentes tables de la cantine. Les rires');
    deplacerCurseurXY(30,13);write('et les chants résonnent créant en ce lieu, une ambiance chaleureuse et rassurante.');

    deplacerCurseurXY(30,15);write('Alors que vous vous asseyez à une table, un palico vous rejoint posant devant vous une cho');
    deplacerCurseurXY(30,16);write('pe et attendant votre commande.');

    couleurTexte(White);
    deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
    deplacerCurseurZoneAction(3);write('     1/ Commander un plat');

    deplacerCurseurZoneAction(6);write('     0/ Retourner sur la place principale');

    deplacerCurseurZoneResponse();
    readln(choix);
  end;

  case choix of
       '0' : cantineHUB := ville;
       '1' : cantineHUB := choixRecette();
  end;

end;

{compare deux chaines de caracteres par ordre alphabetique
et renvoi vrai si le premier parametre est plus petit (alphabetiquement)}

function compareNames(a, b : string): boolean;
var
    i: integer = 1;         //compteur
    fini : boolean = false; //variable de sortie
    res : boolean;          //variable pour le resultat

begin
    while(fini <> true) do
    begin
    //comparaison de code ascii
    if (ord(a[i]) < ord(b[i])) then
        begin
            fini := True;
           res := True;
        end
    else
        if (ord(a[i]) > ord(b[i])) then
            begin
                fini := True;
                res := False;
            end
    else
        //Si sont egaux et une chaine à fini donc on sort
        if (i >= Min(length(a),length(b))) then
            fini := True
        else
            i:= i+1;
    end;
    compareNames := res;
end;


//---------------------TRI PAR ORDRE ALPHABETIQUE---------------------//

//procedure pricipal pour le tri à fusion
procedure TriFusionRecette (var tRecette: CatalogueRecette; debut, fin: integer);
var
    millieu : integer;        //indice pour le millieu d'un tableau
begin

    if (debut < fin) then
    begin
        millieu := (debut + fin) div 2;
        //récursion sur la artie guache
        TriFusionRecette (tRecette, debut, millieu);
        //récursion sur la artie droite
        TriFusionRecette (tRecette, millieu + 1, fin);
        //On fusionne les deux moitiés
        FusionRecette (tRecette, debut, millieu, fin);
    end;
end;

//---------Fusion en se basant sur les recettes----------//
procedure FusionRecette (var tRecette: CatalogueRecette; debut, millieu, fin : integer);
var
    i, j, k: integer;       //compteurs
    temp: CatalogueRecette; //record de recettes temporaire
begin
    i := debut;
    j := millieu + 1;
    k := debut;
    while ((i <= millieu) and (j <= fin)) do
    begin

    if (compareNames(tRecette[i].nomR, tRecette[j].nomR)) then
        begin
            //on prend l'element de la partie gauche
            temp[k] := tRecette[i];
            //on increment le indice de la partie gauche
            i := i + 1;
        end
    else
        begin
            //on prend l'element de la partie droite
            temp[k] := tRecette[j];
            //on increment le inidce de la partie droite
            j := j + 1;
        end;
    k := k + 1;  //increment indice de temp
    end;

    //remplir temp de ceux qui reste dans la partie guache (si y en a)
    while (i <= millieu) do
    begin
        temp[k] := tRecette[i];
        k := k + 1;
        i := i + 1;
    end;

    //remplir temp de ceux qui reste dans la partie droite (si y en a)
    while (j <= fin) do
    begin
        temp[k] := tRecette[j];
        k := k + 1;
        j := j + 1;
    end;

    //remplir notre tableau du debut jusqu'à la fin (trié)
    for k := debut to fin do tRecette[k] := temp[k];

end;


//---------------------TRI PAR BONUS---------------------//
procedure TriFusionBonus (var tRecette: CatalogueRecette; debut, fin: integer);
var
    millieu : integer;        //indice pour le millieu d'un tableau
begin

    if (debut < fin) then
    begin
        millieu := (debut + fin) div 2;
        //récursion sur la artie guache
        TriFusionBonus (tRecette, debut, millieu);
        //récursion sur la artie droite
        TriFusionBonus (tRecette, millieu + 1, fin);
        //On fusionne les deux moitiés
        FusionBonus (tRecette, debut, millieu, fin);
    end;
end;



//---------Fusion en se basant sur le bonus----------//
procedure FusionBonus (var tRecette: CatalogueRecette; debut, millieu, fin : integer);
var
    i, j, k: integer;       //compteurs
    temp: CatalogueRecette; //record de recettes temporaire
begin
    i := debut;
    j := millieu + 1;
    k := debut;
    while ((i <= millieu) and (j <= fin)) do
    begin

    if (tRecette[i].effet < tRecette[j].effet) then
        begin
            //on prend l'element de la partie gauche
            temp[k] := tRecette[i];
            //on increment le indice de la partie gauche
            i := i + 1;
        end
    else
        begin
            //on prend l'element de la partie droite
            temp[k] := tRecette[j];
            //on increment le inidce de la partie droite
            j := j + 1;
        end;
    k := k + 1;  //increment indice de temp
    end;

    //remplir temp de ceux qui reste dans la partie guache (si y en a)
    while (i <= millieu) do
    begin
        temp[k] := tRecette[i];
        k := k + 1;
        i := i + 1;
    end;

    //remplir temp de ceux qui reste dans la partie droite (si y en a)
    while (j <= fin) do
    begin
        temp[k] := tRecette[j];
        k := k + 1;
        j := j + 1;
    end;

    //remplir notre tableau du debut jusqu'à la fin (trié)
    for k := debut to fin do tRecette[k] := temp[k];

end;




end.
