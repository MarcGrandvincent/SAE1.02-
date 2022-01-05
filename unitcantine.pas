//Unit en charge de la cantine
unit unitCantine;
{$codepage utf8}
{$mode objfpc}{$H+}

interface
//----- FONCTIONS ET PROCEDURES -----
uses
  unitLieu,crtperso;


//Fonction exécutée à l'arrivée dans la cantine
//Renvoie le prochain lieu à visiter
function cantineHUB() : typeLieu;

procedure initialiationRecettes();










implementation
uses
  sysutils,unitPersonnage,unitIHM,GestionEcran;
type
    recette = record
    nomR:string;
    effet:integer;
    end;
var

CatalogueRecette : array[1..5000] of recette;

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
       CatalogueRecette[i].nomR:=' ';
       j:=0;

       while (ligne[j]<>'/') do
       begin

            CatalogueRecette[i].nomR:=CatalogueRecette[i].nomR+ligne[j];
            j:=j+1;

       end;


       if ligne[length(CatalogueRecette[i].nomR)+1]='C' then
       CatalogueRecette[i].effet:=3
       else if ligne[length(CatalogueRecette[i].nomR)+1]='R' then
       CatalogueRecette[i].effet:=2
       else if ligne[length(CatalogueRecette[i].nomR)+1]='F' then
       CatalogueRecette[i].effet:=1;




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
  case CatalogueRecette[nb].effet of
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


    deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
    deplacerCurseurZoneAction(3);write('     ?/ Commander un plat (entrer son numéro)');

    deplacerCurseurZoneAction(6);write('     0/ Retourner sur la place principale');

    repeat
    deplacerCurseurXY(50,25);write('Page : ',page,' ');
    y:=10;

    for i:= 1+page*10 to 1+page*10+9 do
    begin
         deplacerCurseurXY(13,y);
         write(i, '/ ',CatalogueRecette[i].nomR,'                               ');

         deplacerCurseurXY(96,y);
         write(effetToString(i));
         y:=y+1;
    end;


    Ch := ReadKey;

    case Ch of
    #0: case ReadKey of    { Le code est #0, on appelle à nouveau ReadKey }
        #77:    begin
                     if page<499 then
                     page:=page+1;
                end;

        #75:    begin
                     if page>0 then
                     page:=page-1;
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
             manger(CatalogueRecette[choixNumber].effet);
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
end.

