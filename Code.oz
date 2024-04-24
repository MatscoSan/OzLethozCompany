local 
   % Vous pouvez remplacer ce chemin par celui du dossier qui contient LethOzLib.ozf
   % Please replace this path with your own working directory that contains LethOzLib.ozf

   % Dossier = {Property.condGet cwdir '/home/max/FSAB1402/Projet-2017'} % Unix example
   Dossier = {Property.condGet cwdir '/Users/matfr/Desktop/Cours/SINF/SINF2/Q2/Programmation_paradigme/Projet/Project'}
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
   NewSpaceship
   Change_dir
   Next
   Tail_incr
   Mouvement
   NewPositions
   HeadSpaceship
   NewNewPositions
   List
   Repeat
   IterativeInstr
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

   fun {Next Spaceship Instruction}
      %Changement de direction en fonction du mouv de head pr que le nouveau head et l'ancien aient la meme dir
      NewPositions = {Change_dir Spaceship.positions.1 Instruction} | nil
      HeadSpaceship = {AdjoinAt Spaceship positions NewPositions}

      %2e head : 
      NewNewPositions = {Change_dir Spaceship.positions.1 Instruction} | nil
      % SecondSpaceship = {AdjoinAt Spaceship positions NewPositions}

      NewSpaceship = {Append {Mouvement HeadSpaceship.positions.1}|nil  NewNewPositions}
      %Avancement du head
      %Tail qui reprend exactement les anciennes pos (x,y,direction) mais avec la direction actualisée pr le second Tailincr donne [pos() pos()] alors que Mouvement donne un pos
      {AdjoinAt Spaceship positions {Append NewSpaceship {Tail_incr Spaceship.positions.2}}}
   end

   fun {Tail_incr L}
      case L of nil then nil
      [] H|T then 
         if T == nil then nil
         else H | {Tail_incr T}
         end
      end
   end

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

   fun {Mouvement L}
      if L.to == north then {AdjoinAt L y L.y-1} 
      elseif L.to == east then {AdjoinAt L x L.x+1} 
      elseif L.to == south then {AdjoinAt L y L.y+1} 
      else {AdjoinAt L x L.x-1}
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

   fun {DecodeStrategy Strategy}
      local
      fun {DecodeStrategyAux Strategy List}
         case Strategy
         of nil then List
         [] H|T then 
            if {Label H} == repeat then % .1 car nil dcp faire une fction 
                  
               {DecodeStrategyAux T {Append List {Repeat H.1.1 H.times}}}
                  
            else 
               {DecodeStrategyAux T {Append List {IterativeInstr H}}}
               % {DecodeStrategyAux T {Append List {IterativeInstr H}.1}} %pas sur .1
               % % {DecodeStrategyAux T X}
            end
         end
      end
      in 
         {DecodeStrategyAux Strategy nil}
      end
   end

   fun {Repeat I N} %L = [turn(right)] N = times:2
      if N == 0 then nil
      else 
          fun {$ Spaceship} {Next Spaceship I} end | {Repeat I N-1}
      end
   end

   fun {IterativeInstr Instruction}
      fun {$ Spaceship} {Next Spaceship instruction} end | nil
   end

      % Options
      Options = options(
		   % Fichier contenant le scénario (depuis Dossier)
		   % Path of the scenario (relative to Dossier)
		   scenario:'scenario/scenario_crazy.oz'
		   % Utilisez cette touche pour quitter la fenêtre
		   % Use this key to leave the graphical mode
		   closeKey:'Escape'
		   % Visualisation de la partie
		   % Graphical mode
		   debug: true
		   % Instants par seconde, 0 spécifie une exécution pas à pas. (appuyer sur 'Espace' fait avancer le jeu d'un pas)
		   % Steps per second, 0 for step by step. (press 'Space' to go one step further)
		   frameRate: 5
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
