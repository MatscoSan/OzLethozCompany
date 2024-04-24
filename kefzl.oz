declare

% [
%     fun{$ Spaceship}
%         {Next Spaceship turn(right)}
%     end 
%     fun{$ Spaceship}
%         {Next Spaceship turn(left)}
%     end
% ] 

%strategy: [forward forward turn(right) repeat([forward] times:3) turn(right) forward turn(right) forward turn(left) repeat([forward] times:24)]
local 
    List 
    Next
in
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

    fun {IterApp L Listupdt}
        case L
        of nil then {Append Listupdt L} %tu rajt ta liste en nil
        [] H|T then
            H | {IterApp T Listupdt}
        end
    end
end
Liststrat = [forward forward turn(right) repeat([forward] times:3)]
% Pos = pos(1)

%{Browse Liststrat}
{Browse {DecodeStrategy Liststrat}}

% {Browse {Label Liststrat.1} == repeat}