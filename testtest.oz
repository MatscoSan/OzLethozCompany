declare 

% Liste = forward | nil
% Liste2 = turn | turn | forward | nil
% Liste3 = Liste.1 | Liste2


% fun {IterApp L Listupdt}
%     case L
%     of nil then {Append Listupdt L} %tu rajt t
%     [] H|T then
%         H | {IterApp T Listupdt}
%     end
% end

% {Browse {IterApp Liste Liste2}}
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
 
 

    fun {IterativeInstr Instruction}
        fun{$ Spaceship}  Spaceship end | fun{$ Spaceship} Spaceship end | nil
    end
end

X = {IterativeInstr forward}
{Browse X}
{Browse X.1}

%     Liste = fun {$ Spaceship} {Next Spaceship turn(right)} end | fun {$ Spaceship} {Next Spaceship turn(left)} end | nil
%     {Browse Liste}
% end
