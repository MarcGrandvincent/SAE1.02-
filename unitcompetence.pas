unit unitCompetence;

{$mode objfpc}{$H+}
{$codepage utf8}

interface

uses
  Classes, SysUtils;

type typeCompetence = record
     nom : string;
     description : string;
     prix : integer;
     cout : integer;
     degats : integer;
end;

function getCompetence(i : Integer) : typeCompetence;

implementation


function getCompetence(i : Integer) : typeCompetence;
var comp : typeCompetence;
begin
     case i of
          1 : begin
              comp.nom := 'Enchainement';
              comp.description := 'Enchaine 3 coups dans les parties vitales du monstre, infligent des dégâts conséquents. Une base chez les chasseurs.';
              comp.prix := 500;
              comp.cout := 40;
              comp.degats := 40;
          end;
          2 : begin
              comp.nom := 'Vague Flamboyante';
              comp.description := 'Consiste à enchainer des coups circulaires sur les points faibles du monstre. Inflige de gros dégâts, technique acquis par les vétérans.';

              comp.prix := 1500;
              comp.cout := 70;
              comp.degats := 90;
          end;
          3 : begin
              comp.nom := 'Purgatoire';
              comp.description := 'Enchainement de coup d''épée précis et complexe infligeant des dégats colossaux. Technique très dur à acquérir que peu de personne maitrise.';
              comp.prix := 3000 ;
              comp.cout := 100;
              comp.degats := 200;
          end;
     end;
     getCompetence := comp;
end;

end.

