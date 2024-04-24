declare

local
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
   Liststrat = [repeat([turn(right)] times:2) forward]
   Spaceship = spaceship(positions:[pos(x:4 y:2 to:east) pos(x:3 y:2 to:east) pos(x:2 y:2 to:south)] effects:nil)
   {Browse {Next {Next Spaceship turn(right)} turn(right)}}
end


%1 = spaceship(positions:[pos(x:4 y:3 to:south) pos(x:4 y:2 to:south) pos(x:3 y:2 to:east)] effects:nil)
%2 = spaceship(positions:[pos(x:3 y:3 to:west) pos(x:4 y:3 to:west) pos(x:4 y:2 to:south)] effects:nil)
%3 = spaceship(positions:[pos(x:2 y:3 to:west) pos(x:3 y:3 to:west) pos(x:4 y:3 to:west)] effects:nil)

% X = {DecodeStrategy Liststrat}
% {Browse {DecodeStrategy Liststrat}}
% {Browse {X.1 Spaceship}}


