function Y = ak_upsampleRandomShift(X, upsamplingFactor, Nperiod)
% function Y = ak_upsampleRandomShift(X, upsamplingFactor, Nperiod)
%Inputs:    X -> input random process (columns are the realizations)
%           upsamplingFactor -> upsampling-1 zeros are inserted
%           Nperiod -> period (use 1 for aperiodic signals)
%Outputs:   Y -> an upsampled version of X with random shift
%
%Understanding the function behavior via examples:
%Example, X(:,1)=[a b c ...] is the first realization of the process
%for non-periodic signals, the idea is to upsample the signal:
%a 0 0 b 0 0 c ... (for upsamplingFactor=3)
%and then select the firstSample from a range [1, upsamplingFactor]
%for example, the above realization would be shifted to
%a 0 0 b 0 0 c ...    if firstSample == 1
%0 0 b 0 0 c ...      if firstSample == 2
%0 b 0 0 c ...        if firstSample == 3
%Because the first samples of X can be lost, X needs to have an extra
%samples.
%
%For periodic signals, the firstSample should vary from
%[1,upsamplingFactor*Nperiod]
%Example: X(:,1)=[a b c a b c a b c ...] has Nperiod=3
%a 0 0 b 0 0 c 0 0 a 0 0 b 0 0 c 0 0 a ... (for upsamplingFactor=3)
%in this case we need to be able to generate shifts such as
%a 0 0 b 0 0 c 0 0 a 0 0 b 0 0 c 0 0 a ... if firstSample == 1
%0 0 c 0 0 a 0 0 b 0 0 c 0 0 a ...         if firstSample == 5
%0 a 0 0 b 0 0 c 0 0 a ...                 if firstSample == 9
%Because Nperiod samples can be lost, X needs to have Nperiod extra samples
%
%Obs: When dealing with aperiodic signals, Nperiod is considered to be 1.
if nargin < 2 || nargin > 3
    error('Need to specify 2 or 3 parameters!');
end
if nargin==2
    Nperiod=1; %Nperiod is considered to be 1 for aperiodic signals
end
if upsamplingFactor==1
    Y=X; %there is nothing to be done
    return;
end

[lengthX, numRealizations] = size(X);
numSamples = lengthX-Nperiod; %effective number of samples that can be used
if  numSamples < 0
    error('Input random process X does not have enough samples in each realization');
end

maxShift = Nperiod * upsamplingFactor;
%find a random value for the first sample: [1, maxShift]
firstSample = 1+floor((maxShift)*rand(1,numRealizations)); 

Y=zeros(upsamplingFactor*numSamples,numRealizations); %pre-allocate 
for i=1:numRealizations
    %First upsample using an auxiliary vector Xup
    Xup = zeros(upsamplingFactor*lengthX,1); %initialize with zeros
    Xup(1:upsamplingFactor:end)=X(:,i); %effectively upsample
    %Random shift:
    lastSample = numSamples*upsamplingFactor+firstSample(i)-1;
    Y(:,i) = Xup(firstSample(i):lastSample);
end
