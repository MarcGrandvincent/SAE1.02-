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

