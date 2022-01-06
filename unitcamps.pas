unit unitCamps;

{$mode objfpc}{$H+}
{$codepage utf8}

interface

uses
  unitLieu,unitIHM,GestionEcran,unitCompetence,unitPersonnage;

function campsHub() : typeLieu;
function acheterComp() : typeLieu;

implementation


function acheterComp() : typeLieu;
var choix : integer;
    i : integer;
begin
  choix := -1;
  while (choix <> 0) do
  begin
      afficherInterfacePrincipale();
      afficherLieu('Camps d''entrainement de la ville de Brightwood');
      deplacerCurseurXY(5,5); write('L''instructeur vous propose :');
      for i := 1 to 3 do
      begin
          couleurTexte(white);
          if (getPersonnage.argent < getCompetence(i).prix) then couleurTexte(lightred);
          if (getPersonnage.competence[i] = 1) then
             begin
                  couleurTexte(green);
                  deplacerCurseurXY(5,2+(i*6)); write('(Déjà apprise)')
             end;
          deplacerCurseurXY(5,3+(i*6)); write(i,'/ ',getCompetence(i).nom,'   Prix : ',getCompetence(i).prix);
          deplacerCurseurXY(5,4+(i*6)); write(getCompetence(i).description);
          deplacerCurseurXY(5,5+(i*6)); write('Coût en combat : ',getCompetence(i).cout,'%');
          deplacerCurseurXY(5,6+(i*6)); write('Dégats : ',getCompetence(i).degats);
      end;

      couleurTexte(white);
      deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
      deplacerCurseurZoneAction(3);write('     ?/ Apprendre une compétence (entrer son numéro)');
      deplacerCurseurZoneAction(6);write('     0/ Retourner sur la place principale');
      deplacerCurseurZoneResponse();
      readln(choix);

      if (getPersonnage.competence[choix] = 1) then
      else if (getPersonnage.argent < getCompetence(choix).prix) then
      else if (choix = 0) then
      else
          apprendreCompetence(choix);

  end;
  acheterComp := camps;
end;

function campsHub() : typeLieu;
var choix : string;
begin
  choix := '';
  while (choix <> '0') and (choix <> '1') do
  begin
    afficherInterfacePrincipale();
    afficherLieu('Camps d''entrainement de la ville de Brightwood');
    deplacerCurseurXY(30,7);write('Vous arrivez au camp d''entrainement. Vous entendez les chocs des lames qui s''entrecroise.');
    deplacerCurseurXY(30,8);write('Vous regardez autour de vous, il y au moins une vingtaine de chasseur, dont certains qui s-');
    deplacerCurseurXY(30,9);write('-ont très célèbres.');

    deplacerCurseurXY(30,12);write('Un instructeur s''approche de vous, avec un katana à la main. La lame a été forgée dans un');
    deplacerCurseurXY(30,13);write('métal très rare qui lui donne un rouge vif telle une flamme qui crépite autour de l''épée');

    deplacerCurseurXY(30,15);write('Il s''approche et dit :');

    deplacerCurseurXY(30,17);write('"Qu''est ce que je peux faire pour toi jeune ',getPersonnage.nom, '?"');
    deplacerCurseurXY(30,19);write('avec un sourire radiant.');

    couleurTexte(White);
    deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
    deplacerCurseurZoneAction(3);write('     1/ S''entrainer');

    deplacerCurseurZoneAction(6);write('     0/ Retourner sur la place principale');

    deplacerCurseurZoneResponse();
    readln(choix);
  end;

  case choix of
       '0' : campsHub := ville;
       '1' : campsHub := acheterComp();
  end;

end;

end.

