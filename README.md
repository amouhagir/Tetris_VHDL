# Tetris_VHDL
##	Introduction
Le Tetris est un jeu auquel nous avons beaucoup joué quand nous étions enfants, qui était prenant par sa simplicité de prise en main. Selon le journaliste Bill Kunkel, « Tetris répond parfaitement à la définition du meilleur en matière de jeu : une minute pour l'apprendre, une vie entière pour le maîtriser ». 
Le jeu est devenu un jeu connu mondialement et nous nous réjouissons
d’avoir réussi, non sans quelques difficultés passagères, à coder un jeu
aussi renommé.

Notre choix s’est établi après avoir créé une liste des projets possibles à réaliser : nous voulions sélectionner en premier lieu un jeu interactif, ce qui permettait d’avoir un bon engouement à travailler dessus. Le Tetris fut choisi car c’était le jeu auquel nous avions le plus joué dans notre enfance. Il s’est révélé pour nous tel un défi.

Les règles du jeu étant connues de tous, nous les rappellerons tout de même dans la première partie de ce document.
Dans un premier temps, nous étudierons les différentes étapes que le jeu allait devoir réaliser, puis nous présenterons l’architecture choisi pour réussir le codage du jeu. Nous détaillerons ensuite chaque bloc et son fonctionnalité.

Nous conclurons ce rapport par présenter les difficultés que nous avons rencontré ainsi que leur résolution, puis l’apport personnel qu’a permis la réalisation de ce jeu de Tetris.

## Présentation du jeu

On appelle chacune des formes de Tetris, un Tetramino (du terme grec 'tetra', signifiant 'quatre'). Chaque tetramino se compose de quatre carrés assemblés de différentes manières. Il existe sept différentes formes.
Chaque forme qui tombe du haut de l'écran est choisie au hasard parmi l'un des sept types. Le joueur doit faire tourner les blocs durant leur chute et les assembler de façon à ce qu'ils forment des lignes horizontales qui une fois complètes disparaissent de l'écran. Si vous échouez à faire disparaître des lignes, les blocs ne tarderont pas à s'accumuler et s'ils parviennent jusqu'en haut de l'écran, c'est la fin du jeu (Game Over). Le score du joueur se calcule en fonction des lignes complètes.
La vitesse de la descente des pièces sera constante durant la période du jeu, mais on pourra accélérer cette descente en appuyant sur le bouton bas et on maintient cette vitesse accélérée jusqu’à ce qu’on réappuie sur le bouton bas ou la pièce arrive en bas (descente d’une nouvelle pièce).

**Commandes du jeu**
Le jeu sera contrôlé à l’aide des boutons de la carte Nexys4 comme suit :
***Bouton Bas*** : changer la vitesse de la descente de la pièce.
***Bouton Droit*** : Déplacement de la pièce à droite.
***Bouton Gauche*** : Déplacement de la pièce à gauche.
***Bouton Centre*** : Faire tourner la pièce
***Bouton Haut*** : Play-Pause du jeu.
***Bouton Reset CPU*** : Recommencer le jeu
<p align="center">
  <img src="SRC/nexys4.png"
       title="FPGA Artix 7 embarqué sur la NEXYS4">
</p>

## Architecture
La première chose à réaliser avant de commencer le codage sur Vivado était l’architecture globale de notre projet sur laquelle on se base durant toute la période du travail (avec des choses à modifier au fur et à mesure). En plus, en tant que binômes, pour qu’on puisse travailler sur deux choses différentes en même temps, le fait d’avoir une même architecture et surtout la même définition des 7 différentes pièces de Tetris et la table du jeu est indispensable. Toutes ces définitions et d’autres constantes ont été ranger dans une bibliothèque nommée `Tetris_biblio.vhd`.

La dernière version de l’architecture global du jeu est donnée dans la figure ci-dessous :
<p align="center">
  <img src="SRC/archi.png">
</p>

**Utilité de chaque bloc :**

* ***Gestion du temps et générateur aléatoire***
Ce bloc gère tout ce qui concerne la gestion de temps de l'affichage et la vitesse de descente des pièces. En plus, il gère le changement aléatoire de la forme des pièces.
* ***Contrôleur***
Il permet de gérer les entrées de l’utilisateur, ces dernières seront mappées dans des commandes. En plus, ce bloc permet de supprimer les lignes qui sont complètes au niveau du jeu et calculer le score du joueur.

* ***Board Controller***
C’est le cœur du jeu là où on a défini la table du jeu!
Il gère un ensemble de données venant d’autres blocs et permet de faire la
mise à jour de la table du jeu à chaque changement de statut.

* ***Affichage***
Il gère l’affichage des données sur l’écran par le port VGA.

## Déroulement du jeu
<p align="center">
  <img src="SRC/jeu.png">
</p>

## Difficultés et améliorations

Durant toute la période de la réalisation de ce projet, nous avons rencontré des difficultés :
  * La première difficulté était la façon de définir les pièces et la table du jeu.
  * Comme la table du jeu représente une matrice d’un tel nombre de lignes et colonnes, elle pose des problèmes dans la           performance du FPGA si on voulait la mettre en sortie/entrée d’un module. C’est pour cela, la table était définie dans un seul    module (Board Controller) et les autres modules peuvent accéder à ses données à travers des signaux intermédiaires.
  * Au niveau de l’affichage, chaque case de la table du jeu est associée à un pixel sur l’écran. Alors, les pièces étaient petites sur l’écran. 
        Pour résoudre ce problème, nous avons proposé dans un premier temps d’augmenter le nombre de blocs pour chaque pièce, c’est-à-dire au lieu de 4 blocs on met 16 (4x4) blocs. Cette solution marchait mais elle a posé des problèmes au niveau de la performance (un grand nombre de LUTs et mauvais rapport du temps). 
        Alors, nous étions menés à trouver une autre solution qui consiste à conserver les 4 blocs de chaque pièce pour le traitement et les faire agrandir au moment de l’affichage c’est-à-dire chaque case de la table du jeu sera affichée sur 4 pixels. Cette solution nous a permis d’avoir des performances avec moindre ressources.

Le jeu en totalité marchait parfaitement même il y’avait d’autres choses que nous aurions aimé ajouter pour l’améliorer encore plus, mais malheureusement nous n’avions pas assez du temps pour les mettre en place. Parmi ces améliorations on cite :

    * Ajouter la musique du jeu pour une meilleure appréciation.
    * Ajouter plusieurs niveaux de difficulté au jeu (chaque niveau détermine la fréquence de chute de pièces). Puis, calculer le score selon le niveau de difficulté.


## Conclusion
Ce travail nous a apporté une méthode de réalisation d’un tel projet. De plus, il nous a permis de mieux maitriser certaines fonctionnalités du VHDL. Nous remercions notre professeur encadrant ainsi que les autres différents professeurs qui ont répondu à nos questions.
