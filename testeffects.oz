declare
%effects: [scrap|revert|wormhole(x:<P> y:<P>)|... ...]

local 
    L 
in
    fun {Effect Spaceship Effects}
        case Effects
        of nil then nil 
        []H|T then 
            if {Label H} == scrap then
                L = {Scrap Spaceship.positions Spaceship.positions}
                {Effect {AdjoinAt Spaceship positions L} T}
            elseif {Label H} == revert then
                {Effect {Revert Effects} T}
            else
                {Effect {AdjoinAt Spaceship positions pos(x:H.x y:H.y to:Spaceship.positions.1.to)} | {Tail_incr Spaceship} T}
                % {AdjoinAt Spaceship.positions.1 y H.y}
                % {AdjoinAt Spaceship.positions.1 x H.x}
            end
        end
    end

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


    fun {Revert Pos}
        1
    end

    fun {Tail_incr L}
        case L of nil then nil
        [] H|T then 
           if T == nil then nil
           else H | {Tail_incr T}
           end
        end
     end
end

% effect:wormhole(x:17 y:17)

Head = [pos(x:4 y:2 to:east)]
Spaceship = spaceship(positions:[pos(x:4 y:2 to:east) pos(x:3 y:2 to:east) pos(x:2 y:2 to:south)] effects:nil)
{Browse {Effect Spaceship wormhole(x:17 y:17)|nil}}