% {DecodeStrategy [repeat([turn(right)] times:2) forward]}
declare
local
    NewSpaceship
    X
    A
    NewPositions
    HeadSpaceship
    NewNewPositions
    NewSpaceshipPos
    DecodeStrategy
in
    Spaceship = spaceship(positions:[pos(x:4 y:2 to:east) pos(x:3 y:2 to:east) pos(x:2 y:2 to:south)] effects:nil)
    List = [repeat([turn(right)] times:2) forward]
    %{Browse List.1.times}


    %NEXT
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

    % strategy ::= <instruction> '|' <strategy>
    %            | repeat(<strategy> times:<integer>) '|' <strategy>
    %            | nil
    fun {DecodeStrategy Strategy}
        if {Label Strategy.1} == repeat then {Browse 1}
        end
    end

    % % Repeat
    % fun {Repeat I N} %L = [turn(right)] N = times:2
    %     if N == 0 then nil
    %     else 
    %         fun {$ Spaceship}
    %             {Next Spaceship I}
    %         end
    %         {Repeat I N-1}
    %     end
    % end
end

% Spaceship = spaceship(positions:[pos(x:4 y:2 to:east) pos(x:3 y:2 to:east) pos(x:2 y:2 to:east)] effects:nil)
% declare 
Liststrat = [repeat([turn(right)] times:2) forward]
% {Browse {DecodeStrategy Liststrat}}
% {Browse Liststrat.1}
{Browse Liststrat.1.1.1}
% {Browse Liststrat.1.times}
% {Browse {Repeat List.1.1.1 List.1.times}}
{Browse Spaceship}
% {Browse List.1.times}
% {Browse {Next Spaceship turn(right)}}

% [
%     fun{$ Spaceship}
%         {Next Spaceship turn(right)}
%     end 
%     fun{$ Spaceship}
%         {Next Spaceship turn(left)}
%     end
% ] 

% {Repeat L N}
% liste 

% {L.1 Spaceship} 