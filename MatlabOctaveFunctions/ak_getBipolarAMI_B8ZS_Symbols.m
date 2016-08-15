function m = ak_getBipolarAMI_B8ZS_Symbols(bits)
% function m = ak_getBipolarAMI_B8ZS_Symbols(bits)
%Converts bits (0 and 1) into symbols (-1,1 and 0) using the bipolar
%AMI with B8ZS (Bipolar with Eight Zero Substitution).
numBits = length(bits);         % number of bits
m = zeros(1, numBits);          % pre-allocate space for symbols
currentPolarity = 1;            % assumption: positive polarity first
counterOfConsecutiveZeros = 0;  % count zeros to implement B8ZS
%(Bipolar with Eight Zero Substitution): a line code that substitutes
%each sequence of 8 consecutive zeros with 000VP0VP. Where V is a
%pulse of the same polarity (bipolar violation) as the previous pulse
%and P is a pulse with the opposite polarity.
for i = 1:numBits               % loop over bits
    % note that m(i) was already initialized with zeros
    if bits(i) == 1
        m(i) = currentPolarity;
        currentPolarity = -currentPolarity; % invert
        counterOfConsecutiveZeros = 0; %reset counter
    else %increment counter
        counterOfConsecutiveZeros = counterOfConsecutiveZeros+1;
        if counterOfConsecutiveZeros == 8 %last 8 bits are zero
            %substitute with 000VP0VP pattern
            m(i-7:i)=[0 0 0 -currentPolarity currentPolarity ...
                0 currentPolarity -currentPolarity];
            counterOfConsecutiveZeros = 0; %reset counter
        end
    end
end
end
