function [symbolIndex, x_hat]=ak_genericDemod(x,constel)
% function [symbolIndex, x_hat]=ak_genericDemod(x,constel)
%Finds the nearest-neighbor symbol for any constellation.
%Inputs:  x the symbols (PAM, QAM or 3d-vectors, etc) to be
%         "demodulated", one per column (PAM and QAM can be vectors
%         with real and complex numbers, respectively).
%         constel - constellation with a symbol per column
%Outputs: symbolIndex has the indices from 0 to M-1, where
%         x_hat has the nearest symbol(s) and same dimension as x
%Usage:
%x=[2,2+4j,-1,-1,-j], c=[1,j,-1,-j], [s,x_hat]=ak_genericDemod(x,c)
%x=rand(3,5); c=[1 0;0 1;1 1]; [s,x_hat]=ak_genericDemod(x,c)
if isvector(x)
    S=length(x); %number of symbols (PAM or QAM) in x
    if ~isvector(constel)
        error('Constellation must be a vector if input is a vector');
    end
    M=length(constel); %number M of symbols in constellation
    D=1; %assume dimension is 1
else
    [D,S]=size(x); %S symbols of dimension D are organized in columns
    [D2,M]=size(constel); %get number M of symbols in constellation
    if D ~= D2
        error('Dimension (number of rows) must be same for inputs');
    end
end
symbolIndex=zeros(1,S); %pre-allocate space for S indices
x_hat=zeros(D,S); %pre-allocate space for S symbols of dimension D
for i=1:S %loop over all S input vectors in x
    bestSymbolIndex = 1; %temporarily assume first symbol as closest
    minDistance=norm(x(:,i)-constel(:,bestSymbolIndex),2);%initialize 
    for j=2:M %search all other symbols in constellation
        distance = norm(x(:,i)-constel(:,j),2); %Euclidean distance
        if distance < minDistance %update best symbol if true
            minDistance = distance; %update minimum distance
            bestSymbolIndex = j; %store best symbol index
        end
    end
    symbolIndex(i)=bestSymbolIndex-1; %store best symbol index
    x_hat(:,i)=constel(:,bestSymbolIndex); %and corresponding symbol
end