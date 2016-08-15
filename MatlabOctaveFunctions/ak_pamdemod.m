function [symbolIndex, x_hat]=ak_pamdemod(x,M)
% function [symbolIndex, x_hat]=ak_pamdemod(x,M)
%Inputs: x has the PAM values and M the number of symbols
%Outputs: symbolIndex has the indices from 0 to M-1
%         x_hat contains the nearest symbol(s)
delta = 2; %assume symbols are separated by 2
symbolIndex = (x+M-1) / delta; %quantizer levels
symbolIndex=round(symbolIndex); %nearest integer
symbolIndex(symbolIndex > M-1) = M-1; %impose maximum 
symbolIndex(symbolIndex < 0) = 0; %impose minimum
if nargout > 1 %calculate only if necessary
    x_hat = (symbolIndex * delta)-(M-1);%quantized output
end
