declare
%{Browse {AdjoinAt Spaceship positions pos(x:)}}
fun {Effect Space Eff}
    case Eff
    of nil then nil
    []H|T then 
        {Browse H.x}
        {AdjoinAt Spaceship.positions.1 y H.y}
        {AdjoinAt Spaceship.positions.1 x H.x}
    end
end

Pos = [pos(x:4 y:2 to:east) pos(x:3 y:2 to:east) pos(x:2 y:2 to:south)]
Spaceship = spaceship(positions:[pos(x:4 y:2 to:east) pos(x:3 y:2 to:east) pos(x:2 y:2 to:south)] effects:nil)
Effect = [wormhole(x:17 y:17) wormhole(x:13 y:17)]

{Browse {Effect Spaceship Effect}}
% {Browse Spaceship.positions.1}
% {Browse Effect.1.x}

% {Browse {AdjoinAt Spaceship.positions.1 y Effect.1.y}}
% {Browse {AdjoinAt Spaceship.positions.1 x Effect.1.x}}



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

{Browse Spaceship.positions}
{Browse {Scrap [pos(x:4 y:2 to:east) pos(x:3 y:2 to:east) pos(x:2 y:2 to:south)] [pos(x:4 y:2 to:east) pos(x:3 y:2 to:east) pos(x:2 y:2 to:south)]}}
{Browse Pos.1.to}

%{Browse {AdjoinAt Spaceship positions Pos.x+1}}



