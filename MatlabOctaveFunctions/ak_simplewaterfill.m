function [powerPerTone,powerWaterlevel,SNR] = ...
    ak_simplewaterfill(g,noisePowerPerTone,totalPower,gap)
%function [powerPerTone,powerWaterlevel,SNR]=
%   ak_simplewaterfill(g,noisePowerPerTone,totalPower,gap)
% Inputs:
%  g - squared magnitude of the channel frequency response
%  noisePowerPerTone - noise power per tone (scalar array
%                     with the same dimension of g)
%  totalPower  total power (or energy)
%  gap - gap (not in dB, but linear scale). Default value is 1
% Outputs:
%  powerPerTone - optimum power allocation per tone
%  waterlevel - power (not PSD) level of the water filling
%  SNR - signal to noise ratio in linear scale (not dB)
% It assumes all the channels are of the same type (e.g.
% PAM or QAM) and have the same dimension (1 or 2)
%Example:
%N0 = 1e-3;  %W/Hz, unilateral noise PSD
%deltaF = 5; %subchannel BW in Hz
%noisePowerPerTone = N0*deltaF; %noise power (in W) per tone
%totalPower = 240e-3; %total power in Watts to be allocated
%K=4; %number of subchannels
%magResponse=0.5; %assume a flat fading channel
%g = (magResponse^2)*ones(1,K); %channel squared magnitudes
%[powerPerTone,powerWaterlevel,SNRk]= ...
%    ak_simplewaterfill(g,noisePowerPerTone,totalPower)
if nargin < 4
    gap=1; %default value, which corresponds to not using a gap
end
%make sure g is a row vector to be able to use fliplr
g=transpose(g(:));%generates a column vector and transpose
gnormalized=g./noisePowerPerTone; %normalize
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
    powerWaterlevel=1/currentNumberOfUsedTones * (totalPower+...
        gap*sum(1./gn_sorted(1:currentNumberOfUsedTones )));
    % s_min occurs in the worst channel
    s_min=powerWaterlevel-gap/gn_sorted(currentNumberOfUsedTones);
    if (s_min<0)
        % If negative power, continue with less channels
        currentNumberOfUsedTones=currentNumberOfUsedTones-1;
    else
        break; %Finish if all power values are positive
    end
end
%calculate the final power distribution:
S_used_tones = powerWaterlevel-gap./gn_sorted(1:currentNumberOfUsedTones);
%final power distribution, with tones in original ordering
powerPerTone = zeros(size(g));
powerPerTone(Index(1:currentNumberOfUsedTones)) = S_used_tones;
SNR = powerPerTone.*gnormalized;