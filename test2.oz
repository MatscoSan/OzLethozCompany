declare
Pos = pos(x:4 y:2 to:east)
Spaceship = spaceship(positions:[pos(x:4 y:2 to:east) pos(x:3 y:2 to:east) pos(x:2 y:2 to:east)] effects:nil)

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

% {Browse {Change_dir Pos turn(left)}}

NewPositions = {Change_dir Spaceship.positions.1 turn(left)} | nil
{Browse NewPositions}
{Browse {AdjoinAt Spaceship positions NewPositions}}
