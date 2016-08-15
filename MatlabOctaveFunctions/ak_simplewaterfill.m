function [powerPerTone,waterlevel,SNR] = ...
    ak_simplewaterfill(g,noisePower,totalPower,gap)
%function [powerPerTone,waterlevel,SNR]=
%          ak_simplewaterfill(g,noisePower,totalPower,gap)
% Inputs:
%  g - squared magnitude of the channel frequency response
%  noisePower - noise power (scalar or per-tone array)
%  totalPower  total power (or energy), not the normalized
%  gap - gap (not in dB, but linear scale). Default value is 1
% Outputs:
%  powerPerTone - optimum power allocation per tone
%  waterlevel - level of the water filling
%  SNR - signal to noise ratio in linear scale (not dB)
% It assumes all the channels are of the same type (e.g.
% PAM or QAM) and have the same dimension (1 or 2)
if nargin < 4
    gap=1; %default value, which corresponds to not using a gap
end
%make sure g is a row vector to be able to use fliplr
g=transpose(g(:));%generates a column vector and transpose
gnormalized=g./noisePower; %normalize
% do waterfilling:
[gn_sorted, Index]=sort(gnormalized);  % sort gain
gn_sorted = fliplr(gn_sorted);% flip to get the largest
Index = fliplr(Index);        % also flip index
currentNumberOfUsedTones = length(g);
%number of zero gain subchannels:
num_zero_gn = length(find(gn_sorted == 0));
% Number of used channels, start from Ntot - num_zero_gn
currentNumberOfUsedTones=currentNumberOfUsedTones - ...
    num_zero_gn;
while(1) %do until break
    waterlevel=1/currentNumberOfUsedTones * (totalPower+...
        gap*sum(1./gn_sorted(1:currentNumberOfUsedTones )));
    % s_min occurs in the worst channel
    s_min=waterlevel-gap/gn_sorted(currentNumberOfUsedTones);
    if (s_min<0)
        % If negative power, continue with less channels
        currentNumberOfUsedTones=currentNumberOfUsedTones-1;
    else
        break; %Finish if all power values are positive
    end
end
%calculate the final power distribution:
S_used_tones = waterlevel-gap./gn_sorted(1:currentNumberOfUsedTones);
%final power distribution, with tones in original ordering
powerPerTone = zeros(size(g));
powerPerTone(Index(1:currentNumberOfUsedTones)) = S_used_tones;
SNR = powerPerTone.*gnormalized;