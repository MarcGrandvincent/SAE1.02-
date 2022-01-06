//Unit en charge de la gestion du personnage
unit unitPersonnage;
{$codepage utf8}
{$mode objfpc}{$H+}

interface
uses
    unitObjet,unitEquipement;
//----- TYPES -----
type
  bonus = (AucunB,Force,Regeneration,Critique);       //Bonus de la cantinue
  genre = (Masculin,Feminin,Autre);         //Genre du personnage

  //Type représentant le personnage
  Personnage = record
    nom : String;                           //Nom du personnage
    sexe : genre;                           //Genre du personnage
    taille : integer;                       //taille du personnage
    inventaire : Tinventaire;               //Inventaire
    parties : TinventairePartie;            //Inventaire des parties de monstres
    arme : materiaux;                       //Arme utilisée
    armures : TArmures;                     //Armures
    sante : integer;                        //Vie du personnage
    santeMax : integer;                     //Vie maximum du personnage
    argent : integer;                       //Argent du personnage
    buff : bonus;                           //Buff du joueur
    exp : integer;                          //Expérience du personnage
    lvl : integer;                          //Niveau du personnage
    competence : array[1..3] of integer;    //Compétence
  end;

  //Type représentant un coffre d'équipement
  TCoffre = record
    armures : TCoffreArmures;               //Armures présentes dans le coffre
    armes : TCoffreArmes;                   //Armes présentes dans le coffre
  end;

   
//----- FONCTIONS ET PROCEDURES -----  
//Initialisation du joueur
procedure initialisationJoueur(); 
//Initialisation du coffre de la chambre
procedure initialisationCoffre();
//Renvoie le personnage (lecture seul)
function getPersonnage() : Personnage;
//Renvoie le coffre (lecture seul)
function getCoffre() : TCoffre;
//Transforme un Genre en chaine de caractères
function genreToString(sexe : genre) : string;
//Change le nom du joueur
procedure setNomPersonnage(nom : string);
//Change la taille du joueur
procedure setTaillePersonnage(taille : integer);  
//Change le genre du joueur
procedure setGenrePersonnage(sexe : genre);
//Ajoute (ou retire) une quantité QTE de l'objet ID dans l'inventaire du joueur
procedure ajoutObjet(id : integer; qte : integer);    
//Dormir dans son lit
procedure dormir(); 
//Change l'arme du joueur
procedure changerArme(mat : integer); 
//Change l'armure du joueur
procedure changerArmure(slot,mat : integer); 
//Achete un objet du type i
procedure acheterObjet(i : integer);  
//Vendre un objet du type i
procedure vendreObjet(i : integer); 
//Renvoie le montant de dégats d'une attaque
function degatsAttaque() : integer;  
//Renvoie le montant de dégats recu
function degatsRecu() : integer; 
//Ajoute une partie de monstre
procedure ajouterPartie(i : integer); 
//Soigne le personnage de 50pv
procedure soigner();        
//Soigne le personnage de 1pv
procedure regen();
//Supprime 1 objet
procedure utiliserObjet(i : integer); 
//Récupère une prime pour avoir tué un monstre
procedure recupererPrime(qte : integer); 
//Renvoie si le joueur possède les ingrédients (et l'or) pour crafter l'objet
function peuxForger(mat : materiaux) : boolean;
//Forge une arme du matériaux donné
procedure forgerArme(mat : materiaux);
//Forge une armure du matériaux donné
procedure forgerArmure(slot : integer; mat : materiaux); 
//Converti un bonus en chaine de caractères
function bonusToString(buff : bonus) : String;
//Change le buff du joueur
procedure setBuff(buff : bonus);
// Calcul le nombre d'exp nécessaire pour le niveau suivant
function calculNextLvl() : integer;
// Ajoute un lvl au personnage si il a l'exp nécessaire
procedure lvlUp();
// Ajoute une quantite d'exp
procedure ajouteExp(valeur : integer);
// Calcul la sante maximal du joueur en fonction de son niveau
function calculSanteMax() : Integer;
//Ajoute une compétence apprise
procedure apprendreCompetence(i : integer);
//Vérifie si le joueur a une competence
function verifCompetence() : boolean;
// Création des fichiers si ils n'ont pas déjà été créer
procedure verificationFichier();
// Creation du fichier de sauvegarde
procedure creationDataJoueur(val,pos : Integer);
// Modification du fichier de sauvegarde
procedure modificationDataJoueur(val,pos : Integer);
// Renvoie une valeur du fichier
function dataJoueur(pos : Integer) : Integer;
// On sauvegarde les données du joueur
procedure sauvegarder();
// On recupère les données sauvegarder
procedure recupData();
// Modification du fichier pour les strings
procedure modificationDataString(val : string);
// Renvoie une valeur du fichier des strings
function dataString() : string;
// Ajoute une arme dans le coffre du joueur
procedure ajouterArme(val : integer);
// Ajoute une arme dans le coffre du joueur
procedure ajouterArmure(slot,val : integer);
// ---------- Sauvegarde ----------











implementation
uses
    unitMonstre,unitCompetence,SysUtils;
var
   perso : Personnage;                      //Le personnage
   coffre : TCoffre;                        //Le coffre de la chambre
   data : file of Integer;                  //Fichier sauvegarde
   datas : Text;                  //Fichier sauvegarde pour les strings

// On recupère les données sauvegarder
procedure recupData();
var i : integer;
    j : integer;
    sexe : genre;
    arme : materiaux;
    armure : materiaux;
    buff : bonus;
    slot : integer = 22;
begin
     perso.nom := dataString();                                                        // On recupere le nom du joueur
     case dataJoueur(2) of                                                              // On recupere le sexe du joueur
          0 : sexe := Masculin;
          1 : sexe := Feminin;
          2 : sexe := Autre;
     end;
     perso.sexe := sexe;
     perso.taille := dataJoueur(3);                                                     // On recupère la taille du joueur
     for i:= 1 to nbObjets do perso.inventaire[i] := dataJoueur(3+i);                   // On recupère les objets du joueur
     for i:= 0 to ord(high(TypeMonstre)) do perso.parties[i] := 200;//dataJoueur(6+i);        // On recupère les parties de monstre du joueur
     case dataJoueur(8) of                                                              // On recupère l'arme du joueur
          0 : arme := aucun;
          1 : arme := fer;
          2 : arme := Os;
          3 : arme := Ecaille;
          4 : arme := Obsidienne;
     end;
     perso.arme := arme;
     for i:=0 to 4 do                                                                   // On recupère l'armure du joueur
       begin
            case dataJoueur(9+i) of
                 0 : armure := aucun;
                 1 : armure := fer;
                 2 : armure := Os;
                 3 : armure := Ecaille;
                 4 : armure := Obsidienne;
            end;
            perso.armures[i] := armure;
       end;
     perso.sante := dataJoueur(14);                                                     // On recupère la santé du joueur
     perso.argent := 10000;// dataJoueur(15);                                                    // On recupère l'argent du joueur
     case dataJoueur(16) of                                                             // On recupère le buff du joueur
          0 : buff := AucunB;
          1 : buff := Force;
          2 : buff := Regeneration;
          3 : buff := Critique;
     end;
     perso.buff := buff;
     perso.exp := dataJoueur(17);                                                       // On recupère l'expérience du joueur
     perso.lvl := 9;//dataJoueur(18);                                                       // On recupère le niveau du joueur
     for i:= 1 to 3 do perso.competence[i] := dataJoueur(18+i);                         // On recupère les compétences du joueur
     for i:= 0 to 4 do                                                                  // On recupère les armures dans le coffre du joueur
       begin
            for j := 1 to ord(high(materiaux)) do
                begin
                     if (dataJoueur(slot) = 1) then
                         coffre.armures[i,j] := True
                     else
                         coffre.armures[i,j] := False;
                     slot += 1;
                end;
       end;
     for i := 1 to ord(high(materiaux)) do                                              // On recupère les armes dans le coffre du joueur
       begin
            if (dataJoueur(slot+i) = 1) then
               coffre.armes[i] := True
            else
               coffre.armes[i] := False;
       end;
end;

// On sauvegarde les données du joueur
procedure sauvegarder();
var i : integer;
    j : integer;
    slot : integer = 22;
begin
     modificationDataString(perso.nom);                                                 // On sauvegarde le nom du joueur
     if (dataJoueur(1) = 0) then modificationDataJoueur(1,1);                           // Si le joueur sauvegarde pour la première fois, on lui permet de maintenant de continuer sa partie
     modificationDataJoueur(ord(perso.sexe),2);                                         // On sauvegarde le sexe du joueur
     modificationDataJoueur(perso.taille,3);                                            // On sauvegarde la taille
     for i:=1 to nbObjets do modificationDataJoueur(perso.inventaire[i],3+i);           // On savegarde les potions et les bombes
     for i:=0 to ord(high(TypeMonstre)) do modificationDataJoueur(perso.parties[i],6+i);// On savegarde les parties de monstre
     modificationDataJoueur(ord(perso.arme),8);                                         // On sauvegarde l'arme du joueur
     for i:=0 to 4 do modificationDataJoueur(ord(perso.armures[i]),9+i);                // On sauvegarde l'armure du joueur
     modificationDataJoueur(perso.sante,14);                                            // On sauvegarde la sante du joueur
     modificationDataJoueur(perso.argent,15);                                           // On sauvegarde l'argent du joueur
     modificationDataJoueur(ord(perso.buff),16);                                        // On sauvegarde le buff du joueur
     modificationDataJoueur(perso.exp,17);                                              // On sauvegarde l'exp du joueur
     modificationDataJoueur(perso.lvl,18);                                              // On sauvegarde le niveau du joueur
     for i:= 1 to 3 do modificationDataJoueur(perso.competence[i],18+i);                // On sauvegarde les compétences du joueur
     for i:= 0 to 4 do                                                                  // On sauvegarde les armures dans le coffre du joueur
       begin
            for j := 1 to ord(high(materiaux)) do
                begin
                     if (coffre.armures[i,j] = True) then
                        modificationDataJoueur(1,slot)
                     else
                        modificationDataJoueur(0,slot);
                     slot += 1;
                end;
       end;
     for i := 1 to ord(high(materiaux)) do                                              // On sauvegarde les armes dans le coffre du joueur
       begin
            if (coffre.armes[i] = True) then
               modificationDataJoueur(1,slot+i)
            else
               modificationDataJoueur(0,slot+i);
       end;

end;

// Création des fichiers si ils n'ont pas déjà été créer
procedure verificationFichier();
begin
    if not DirectoryExists('C:\MHNewWorld') then
       begin
            MkDir('C:\MHNewWorld');
            creationDataJoueur(0,40);
       end;
end;

// Creation du fichier
{Principe :
1/ Personnage existe : 0 ou 1
2/ sexe : 1 à 3
3/ taille
4/ InventairePotion
5/ InventaireBombe
6/ PartieJagras
7/ PartiePukei
8/ Arme
9/ Armure Casque
10/ Armure Torse
11/ Armure Gants
12/ Armure Jambieres
13/ Arumure Bottes
14/ Sante
15/ argent
16/ buff
17/ exp
18/ lvl
19/ competence1 : 0 ou 1
20/ competence2 : 0 ou 1
21/ Competence3 : 0 ou 1
Le reste :  armures et arme dans coffre}
procedure creationDataJoueur(val,pos : Integer);
begin
     assign(data, 'C:/MHNewWorld/dataJoueur.bin');
     rewrite(data);
     seek(data,pos);
     write(data,val);
     close(data);
end;


// Modification du fichier
procedure modificationDataJoueur(val,pos : Integer);
begin
     assign(data, 'C:/MHNewWorld/dataJoueur.bin');
     reset(data);
     seek(data,pos);
     write(data,val);
     close(data);
end;

// Modification du fichier pour les strings
procedure modificationDataString(val : string);
begin
     assign(datas, 'C:/MHNewWorld/dataString.txt');
     rewrite(datas);
     write(datas,val);
     close(datas);
end;



// Renvoie une valeur du fichier
function dataJoueur(pos : Integer) : Integer;
var val : Integer;
begin
     assign(data, 'C:/MHNewWorld/dataJoueur.bin');
     reset(data);
     seek(data, pos);
     read(data,val);
     dataJoueur := val;
     close(data);
end;

// Renvoie une valeur du fichier des strings
function dataString() : string;
var val : string;
begin
     assign(datas, 'C:/MHNewWorld/dataString.txt');
     reset(datas);
     read(datas,val);
     dataString := val;
     close(datas);
end;



// Ajoute une quantite d'exp
procedure ajouteExp(valeur : integer);
begin
    perso.exp += valeur;
end;

// Ajoute un lvl au personnage si il a l'exp nécessaire
procedure lvlUp();
begin
     if (getPersonnage.exp >= calculNextLvl) then
        begin
             perso.exp -= calculNextLvl;
             perso.lvl += 1;
        end;
end;

// renvoie l'exp nécessaire pour le niveau suivant
function calculNextLvl() : Integer;
begin
    calculNextLvl := 800+200*(getPersonnage.lvl);
end;

//Initialisation du coffre de la chambre
procedure initialisationCoffre();
var
   mat,slot : integer;
begin
  //Armures (vide)
  for slot:=0 to 4 do
    for mat:=1 to ord(high(materiaux)) do
      coffre.armures[slot,mat] := false;
  //Armes (vide)
  for mat:=1 to ord(high(materiaux)) do
    coffre.armes[mat] := false;

  //Ajoute une épée de fer
  coffre.armes[1] := true;

end;

//Initialisation du joueur
procedure initialisationJoueur();
var
   i:integer;
begin
  //Inventaire vide
  for i:=1 to nbObjets do perso.inventaire[i] := 0;
  //Inventaire de partie vide
  for i := 0 to ord(high(TypeMonstre)) do perso.parties[i] := 0;
  // Pas d'expérience
  perso.exp := 0;
  // Niveau 1
  perso.lvl := 1;
  //En pleine forme
  perso.sante:= calculSanteMax;
  //Pas d'arme
  perso.arme := aucun;
  //Pas d'armure
  for i := 0 to 4 do perso.armures[i] := aucun; 
  //Ajouter 200 PO
  perso.argent:=200;
  // On initialise les compétences à 0
  perso.competence[1] := 0;
  perso.competence[2] := 0;
  perso.competence[3] := 0;
end;

//Renvoie le personnage (lecture seul)
function getPersonnage() : Personnage;
begin
  getPersonnage := perso;
end;

//Renvoie le coffre (lecture seul)
function getCoffre() : TCoffre;
begin
  getCoffre := coffre;
end;

//Transforme un Genre en chaine de caractères
function genreToString(sexe : genre) : string;
begin
  case sexe of
       Masculin : genreToString := 'Masculin';
       Feminin : genreToString := 'Féminin';
       Autre : genreToString := 'Autre';
  end;
end;

//Change le nom du joueur
procedure setNomPersonnage(nom : string);
begin
  perso.nom:=nom;
end;

//Change le genre du joueur
procedure setGenrePersonnage(sexe : genre);
begin
  perso.sexe:=sexe;
end;

//Change la taille du joueur
procedure setTaillePersonnage(taille : integer);
begin
  perso.taille:=taille;
end;

//Ajoute (ou retire) une quantité QTE de l'objet ID dans l'inventaire du joueur
procedure ajoutObjet(id : integer; qte : integer);
begin
     perso.inventaire[id] += qte;
     if(perso.inventaire[id] < 0) then perso.inventaire[id] := 0;
end;

//Dormir dans son lit
procedure dormir();
begin
  perso.sante:=calculSanteMax;
end;

//Change l'arme du joueur
procedure changerArme(mat : integer);
begin
  //Enlève l'arme du coffre
  coffre.armes[mat] := false;
  //Range l'arme dans le coffre (si le joueur en a une)
  if(ord(perso.arme) <> 0) then coffre.armes[ord(perso.arme)] := true;
  //Equipe la nouvelle arme
  perso.arme := materiaux(mat);
end;


//Change l'armure du joueur
procedure changerArmure(slot,mat : integer);
begin
  //Enlève l'armure du coffre
  coffre.armures[slot,mat] := false;
  //Range l'armure dans le coffre (si le joueur en a une)
  if(ord(perso.armures[slot]) <> 0) then coffre.armures[slot,ord(perso.armures[slot])] := true;
  //Equipe la nouvelle armure
  perso.armures[slot] := materiaux(mat);
end;

//Achete un objet du type i
procedure acheterObjet(i : integer);
begin
  perso.argent -= getObjet(i).prixAchat;
  perso.inventaire[i] += 1;
end;

//Vendre un objet du type i
procedure vendreObjet(i : integer);
begin
  perso.argent += getObjet(i).prixVente;
  perso.inventaire[i] -= 1;
end;

//Renvoie le montant de dégats d'une attaque
function degatsAttaque() : integer;
var  coeff : integer = 1;
     seuilProba : Integer = 1;
begin
    randomize;
    if (perso.buff = Critique) then
       seuilProba := 2;
    readln();
    if (random(11)<=seuilProba) then
        coeff :=2;

  degatsAttaque := (3+(1*getPersonnage.lvl)+Random(5))*multiplicateurDegatsArme(perso.arme);
end;

//Renvoie le montant de dégats recu
function degatsRecu() : integer;
begin
  degatsRecu := (2+Random(10))-encaissement(perso.armures);
  perso.sante -= degatsRecu;
  if perso.sante < 0 then perso.sante := 0;
end;

//Ajoute une partie de monstre
procedure ajouterPartie(i : integer);
begin
  perso.parties[i] += 1;
end;

// Calcul la sante maximal du joueur en fonction de son niveau
function calculSanteMax() : Integer;
begin
     calculSanteMax := 90+10*perso.lvl;
end;

//Soigne le personnage de 50pv
procedure soigner();
begin
  perso.sante += 50;
  if(perso.sante > calculSanteMax) then perso.sante := calculSanteMax;
end;

//Soigne le personnage de 1pv
procedure regen();
begin
  perso.sante += 1;
  if(perso.sante > calculSanteMax) then perso.sante := calculSanteMax;
end;

//Supprime 1 objet
procedure utiliserObjet(i : integer);
begin
  perso.inventaire[i] -= 1;
end;

//Récupère une prime pour avoir tué un monstre
procedure recupererPrime(qte : integer);
begin
  perso.argent += qte;
end;

//Renvoie si le joueur possède les ingrédients (et l'or) pour crafter l'objet
function peuxForger(mat : materiaux) : boolean;
begin
     //Test de l'argent
     peuxForger := (perso.argent >= 500);
     //Test des matériaux
     case mat of
          os : peuxForger := peuxForger AND (perso.parties[0]>4);
          Ecaille : peuxForger := peuxForger AND (perso.parties[1]>4);
          Obsidienne : peuxForger := peuxForger AND (perso.parties[1]>49);
     end;
end;

//Forge une arme du matériaux donné
procedure forgerArme(mat : materiaux);
begin
     //retire l'or
     perso.argent -= 500;
     
     //Retire les matériaux
     case mat of
          os : perso.parties[0] -= 5;
          Ecaille : perso.parties[1] -= 5;
          Obsidienne : perso.parties[1] -= 50;
     end;

     //Ajoute l'arme dans le coffre
     coffre.armes[ord(mat)] := true;
end;

//Forge une armure du matériaux donné
procedure forgerArmure(slot : integer; mat : materiaux);
begin
     //retire l'or
     perso.argent -= 500;

     //Retire les matériaux
     case mat of
          os : perso.parties[0] -= 5;
          Ecaille : perso.parties[1] -= 5;
          Obsidienne : perso.parties[1] -= 50;
     end;

     //Ajoute l'armure dans le coffre
     coffre.armures[slot,ord(mat)] := true;
end;

//Converti un bonus en chaine de caractères
function bonusToString(buff : bonus) : String;
begin
  case buff of
       AucunB:bonusToString:='Aucun';
       Force:bonusToString:='Force';
       Regeneration:bonusToString:='Regénération';
  end;
end;

//Change le buff du joueur
procedure setBuff(buff : bonus);
begin
  perso.buff := buff;
end;


//Ajoute une compétence apprise
procedure apprendreCompetence(i : integer);
begin
     perso.competence[i] := 1;
     perso.argent -= getCompetence(i).prix;
end;
//Vérifie si le joueur a une competence
function verifCompetence() : boolean;
begin
     if (getPersonnage.competence[1] = 1) OR (getPersonnage.competence[2] = 1) OR (getPersonnage.competence[3] = 1) then
        verifCompetence := True
     else
        verifCompetence := False;
end;

// Ajoute une arme dans le coffre du joueur
procedure ajouterArme(val : integer);
begin
     coffre.armes[val] := true;
end;

// Ajoute une arme dans le coffre du joueur
procedure ajouterArmure(slot,val : integer);
begin
     coffre.armures[slot][val] := true;
end;

end.

