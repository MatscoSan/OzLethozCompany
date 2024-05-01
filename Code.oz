local 
   % Vous pouvez remplacer ce chemin par celui du dossier qui contient LethOzLib.ozf
   % Please replace this path with your own working directory that contains LethOzLib.ozf

   % Dossier = {Property.condGet cwdir '/home/max/FSAB1402/Projet-2017'} % Unix example
   Dossier = {Property.condGet cwdir '.'}
   % Dossier = {Property.condGet cwdir 'C:\\Users\Thomas\Documents\UCL\Oz\Projet'} % Windows example.
   LethOzLib

   % Les deux fonctions que vous devez implémenter
   % The two function you have to implement
   Next
   DecodeStrategy
   
   % Hauteur et largeur de la grille
   % Width and height of the grid
   % (1 <= x <= W=24, 1 <= y <= H=24)
   W = 24
   H = 24

   Options
in
   % Merci de conserver cette ligne telle qu'elle.
   % Please do NOT change this line.
   [LethOzLib] = {Link [Dossier#'/'#'LethOzLib.ozf']}
   {Browse LethOzLib.play}

%%%%%%%%%%%%%%%%%%%%%%%%
% Your code goes here  %
% Votre code vient ici %
%%%%%%%%%%%%%%%%%%%%%%%%

local
   % Déclarez vos functions ici
   % Declare your functions here
   Change_dir
   Tail_incr
   Mouvement
   Repeat
   IterativeInstr
   Effect
   Scrap
   Reverse
   LastPosInv
   Shrink
   Length
   BigScrap
   Malware
   Incr
in
   % La fonction qui renvoit les nouveaux attributs du serpent après prise
   % en compte des effets qui l'affectent et de son instruction
   % The function that computes the next attributes of the spaceship given the effects
   % affecting him as well as the instruction
   % 
   % instruction ::= forward | turn(left) | turn(right)
   % P ::= <integer x such that 1 <= x <= 24>
   % direction ::= north | south | west | east
   % spaceship ::=  spaceship(
   %               positions: [
   %                  pos(x:<P> y:<P> to:<direction>) % Head
   %                  ...
   %                  pos(x:<P> y:<P> to:<direction>) % Tail
   %               ]
   %               effects: [scrap|revert|wormhole(x:<P> y:<P>)|... ...]
   %            )

   % fun {Next Spaceship Instruction}
   %    {Browse Instruction}
   %    Spaceship
   % end

   %Fonction qui prend en paramètre un record (spaceship) et un atom et qui
   %permet le prochain mouvement du spaceship en fonction de l'instruction
   fun {Next Spaceship Instruction}
      local
         NewPositions
         HeadSpaceship
         SpaceshipEff
         SpaceshipEffn
         NewNewPositions
         NewSpaceship
      in
       %Effects
       SpaceshipEff = {Effect Spaceship Spaceship.effects}
       SpaceshipEffn = {AdjoinAt SpaceshipEff effects nil}
       %Changement de direction en fonction du mouvement de head pourr que le nouveau head et l'ancien aient la meme direction 
       NewPositions = {Change_dir SpaceshipEff.positions.1 Instruction} | nil
       HeadSpaceship = {AdjoinAt SpaceshipEffn positions NewPositions}
 
       %2e head : 
       NewNewPositions = {Change_dir SpaceshipEff.positions.1 Instruction} | nil
 
       NewSpaceship = {Append {Mouvement HeadSpaceship.positions.1}|nil  NewNewPositions}
       %Avancement du head
       %Tail qui reprend exactement les anciennes pos (x,y,direction) mais avec la direction actualisée pr le second Tailincr donne [pos() pos()] alors que Mouvement donne un pos
       {AdjoinAt SpaceshipEffn positions {Append NewSpaceship {Tail_incr SpaceshipEffn.positions.2}}}
      end
    end

   %Fonction qui prend en paramètre une liste de positions et qui
   %parcoure la liste et renvoit tous les éléments sauf le dernier 
   %pour supprimer le dernier wagon du spaceship
   fun {Tail_incr L} 
      case L of nil then nil
      [] H|T then 
         if T == nil then nil
         else H | {Tail_incr T}
         end
      end
   end

   %Fonction qui prend en paramètre une liste de postions et une instruction et 
   % qui change la direction du spaceship en fonction de sa direction actuelle et de l'instruction 
   fun {Change_dir L Instruction}
      if Instruction == turn(right) then
         if L.to == north then {AdjoinAt L to east}
         elseif L.to == east then {AdjoinAt L to south}
         elseif L.to == south then {AdjoinAt L to west}
         else {AdjoinAt L to north}
         end
      elseif Instruction == turn(left) then
         if L.to == north then {AdjoinAt L to west}
         elseif L.to == west then {AdjoinAt L to south}
         elseif L.to == south then {AdjoinAt L to east}
         else {AdjoinAt L to north}
         end
      else 
         L
      end
  end 

  %Fonction qui prend en paramètre une liste de positions et qui
  %permet de bouger la head du spaceship en fonction de sa direction
   fun {Mouvement L}
      if L.to == north then {AdjoinAt L y L.y-1} 
      elseif L.to == east then {AdjoinAt L x L.x+1} 
      elseif L.to == south then {AdjoinAt L y L.y+1} 
      else {AdjoinAt L x L.x-1}
      end
   end

   %Fonction qui prend en paramètre un spaceship et une liste d'effects 
   %et qui permet de gérer tous les effects en prenant le spaceship et en renvoyant le spaceship  
   %avec ses positions actualisées en fonction de l'effect
   fun {Effect Spaceship Effects}
      local 
         Pos 
         NewPos
      in 
         case Effects
         of nil then Spaceship
         []H|T then 
            if {Label H} == scrap then
               {AdjoinAt Spaceship positions {Scrap Spaceship.positions Spaceship.positions}}
            elseif {Label H} == revert then
               {AdjoinAt Spaceship positions {Reverse Spaceship.positions Spaceship.positions}}
            elseif {Label H} == wormhole then
               Pos = {AdjoinAt Spaceship.positions.1 x H.x}
               NewPos = {AdjoinAt Pos y H.y}
               {AdjoinAt Spaceship positions {Append NewPos|nil Spaceship.positions.2}}
            elseif {Label H} == dropSeismicCharge then
               {AdjoinAt Spaceship seismicCharge H.1}
            elseif {Label H} == shrink then
               {AdjoinAt Spaceship positions {Shrink Spaceship.positions Spaceship.positions}}
            elseif {Label H} == bigscrap then
               {AdjoinAt Spaceship positions {BigScrap Spaceship.positions Spaceship.positions}}
	    elseif {Label H} == malware then
               {AdjoinAt Spaceship positions {Malware Spaceship.positions}}
            else
            {Effect Spaceship T}          
            end
         end
      end
   end
  
   %Fonction qui permet d'ajouter 1 wagon à la fin du spaceship
   %Elle doit prendre 2 fois les mêmes positions car en faisant H|T cela modifie en même temps Pos
   %On ajoute un dernier wagon en fonction de la direction du head 
   fun {Scrap Pos Pos2}
      case Pos 
      of H|T then 
          if T == nil then 
              if Pos2.1.to == east then H | pos(x:H.x-1 y:H.y to:H.to) | nil 
              elseif Pos2.1.to == west then H | pos(x:H.x+1 y:H.y to:H.to) | nil 
              elseif Pos2.1.to == south then H | pos(x:H.x y:H.y-1 to:H.to) | nil 
              else H | pos(x:H.x y:H.y+1 to:H.to) | nil 
              end
          else H | {Scrap T Pos2}
          end
      end
   end

   %Fonction qui retire 1 wagon comme {Tail_incr L}, elle doit prendre 2 fois les mêmes positions
   %car en faisant H|T cela modifie en même temps Pos
   fun {Shrink Pos Pos2}
      case Pos 
      of nil then nil
      [] H|nil then nil
      [] H|T then
         H | {Shrink T Pos2}
      end
   end

   %Même fonctionnement que {Scrap} mais on ajoute 3 wagons à la tail
   fun {BigScrap Pos Pos2}
      case Pos 
      of H|T then 
          if T == nil then 
              if Pos2.1.to == east then H | pos(x:H.x-1 y:H.y to:H.to) | pos(x:H.x-2 y:H.y to:H.to) | pos(x:H.x-3 y:H.y to:H.to) | nil 
              elseif Pos2.1.to == west then H | pos(x:H.x+1 y:H.y to:H.to) | pos(x:H.x+2 y:H.y to:H.to) | pos(x:H.x+3 y:H.y to:H.to) | nil 
              elseif Pos2.1.to == south then H | pos(x:H.x y:H.y-1 to:H.to) | pos(x:H.x y:H.y-2 to:H.to) | pos(x:H.x y:H.y-3 to:H.to) | nil 
              else H | pos(x:H.x y:H.y+1 to:H.to) | pos(x:H.x y:H.y+2 to:H.to) | pos(x:H.x y:H.y+3 to:H.to) | nil 
              end
          else H | {BigScrap T Pos2}
          end
      end
   end

   %Fonction qui reverse le spaceship ainsi que sa direction 
   fun {Reverse L L2}
       local 
           fun {ReverseAux L L2 Y}  
               case L
               of nil then Y
               [] H|T then 
                   if T == nil then
                       if H.to == north then {ReverseAux T L2 {AdjoinAt H to south}|Y}
                       elseif H.to == east then {ReverseAux T L2 {AdjoinAt H to west}|Y}
                       elseif H.to == south then {ReverseAux T L2 {AdjoinAt H to north}|Y}
                       else {ReverseAux T L2 {AdjoinAt H to east}|Y}
                       end
                   else 
                       {ReverseAux T L2 H|Y} 
                   end
               end
           end
       in
           {ReverseAux L L2 nil}
       end
   end

   fun {Malware Pos}
       if Pos.1.to == north then {AdjoinAt Pos.1 to east} | {Incr Pos.2} 
       elseif Pos.1.to == east then {AdjoinAt Pos.1 to south} | {Incr Pos.2} 
       elseif Pos.1.to == south then {AdjoinAt Pos.1 to west} | {Incr Pos.2} 
       else {AdjoinAt Pos.1 to north} | {Incr Pos.2} 
       end
   end 
   
   fun {Incr L} 
       case L of nil 
       then nil
       [] H|T then 
          H | {Incr T}
       end
    end
 
   
   % La fonction qui décode la stratégie d'un serpent en une liste de fonctions. Chacune correspond
   % à un instant du jeu et applique l'instruction devant être exécutée à cet instant au spaceship
   % passé en argument
   % The function that decodes the strategy of a spaceship into a list of functions. Each corresponds
   % to an instant in the game and should apply the instruction of that instant to the spaceship
   % passed as argument
   %
   % strategy ::= <instruction> '|' <strategy>
   %            | repeat(<strategy> times:<integer>) '|' <strategy>
   %            | nil

   %Fonction qui prend en paramètre une liste de stratégie et qui 
   %permet de gérer la liste de stratégies.
   %Elle prend soit repeat(instruction) soit une instruction
   %Enfin, elle renvoit une liste de spaceship appelant {Next}
   fun {DecodeStrategy Strategy}
      local
      fun {DecodeStrategyAux Strategy List}
         case Strategy
         of nil then List
         [] H|T then 
            if {Label H} == repeat then 
                  
               {DecodeStrategyAux T {Append List {Repeat H.1.1 H.times}}}
                  
            else 
               {DecodeStrategyAux T {Append List {IterativeInstr H}}}
            end
         end
      end
      in 
         {DecodeStrategyAux Strategy nil}
      end
   end

   %Fonction qui prend en paramètre une instruction et qui renvoit N de fois qu'elle doit être appliquée à {Next}
   fun {Repeat I N} 
      if N == 0 then nil
      else 
          fun {$ Spaceship} {Next Spaceship I} end | {Repeat I N-1}
      end
   end

   fun {IterativeInstr Instruction}
      fun {$ Spaceship} {Next Spaceship Instruction} end | nil
   end

      % Options
      Options = options(
		   % Fichier contenant le scénario (depuis Dossier)
		   % Path of the scenario (relative to Dossier)
		   scenario:'/scenario/Scenario.oz'
		   % Utilisez cette touche pour quitter la fenêtre
		   % Use this key to leave the graphical mode
		   closeKey:'Escape'
		   % Visualisation de la partie
		   % Graphical mode
		   debug: true
		   % Instants par seconde, 0 spécifie une exécution pas à pas. (appuyer sur 'Espace' fait avancer le jeu d'un pas)
		   % Steps per second, 0 for step by step. (press 'Space' to go one step further)
		   frameRate: 0
		)
   end

%%%%%%%%%%%
% The end %
%%%%%%%%%%%
   
   local 
      R = {LethOzLib.play Dossier#'/'#Options.scenario Next DecodeStrategy Options}
   in
      {Browse R}
   end
end
