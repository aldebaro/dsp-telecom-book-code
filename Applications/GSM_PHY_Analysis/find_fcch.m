function [bestFCCH, fcchStartCandidates] = find_fcch(s,start,stop,...
    showPlots, thresholdForDetectionInRad)
%function [bestFCCH, fcchStartCandidates] = find_fcch(s,start,stop,...
%    showPlots, thresholdForDetectionInRad)
%Inputs: s->signal, start and stop->first and last samples
%if showPlots is 1, show a graph
%It assumes s has oversampling = 1 (is sampled at symbol rate).
%Recall that a frequency burst has
%3 tail bits | 142 fixed bits 0 | 3 tail bits | 8.25 bits guard period
%and the multiframe is
%FSBBBBCCCCFSCCCCCCCCFSCCCCCCCCFSCCCCCCCCFSCCCCCCCCI

if nargin < 5
    thresholdForDetectionInRad = 1; %threshold, 1 radians
end

r = s(start:stop); %extract segment of interest

OSR = 1; %oversampling
syncBitsLength = 142*OSR; %number of samples in 142 bits of burst
tailingBitsInSamples = 3*OSR; %3 Tailing Bits at each side of the burst
%FL = 2 * TB + BL; %148
%PLOTEXTRA = 25;

L = length(r); %number of samples of interest
da = angle(r(1:L-1) .* conj(r(2:L))); %angles difference
%equivalent to
%da2 = - filter([1 -1],1,angle(r));
%da2(1)=[];
%this second method has problems with the 360 degrees wrap
%one would need to unwrap the phase after using angle:
%da3 = - filter([1 -1],1,unwrap(angle(r)));
%da3(1)=[]; %this gives the same result as original 'da'

%from the start to the end of the segment of interest,
%search the sample that better matches the begin of a FB
df=NaN * ones(1,L-syncBitsLength-1); %pre-allocate space
for i = 1 : (L-syncBitsLength-1)
    %extract a sub-segment with 142 bits: da(i:i+BL-1)
    low  = min(da(i:i+syncBitsLength-1)); %minimum angle difference
    high = max(da(i:i+syncBitsLength-1)); %maximum angle difference
    df(i) = high - low;
end

%all phases are the same for a FB burst, so the difference
%should be zero.
[minDynamicRange, index_minDynamicRange] = min(df);

%the threshold for minDynamicRange
if minDynamicRange < thresholdForDetectionInRad
    bestFCCH = index_minDynamicRange + start - 1 - tailingBitsInSamples;
    if bestFCCH < 1
        bestFCCH = 1; % Do not allow negative index
    end
else
    bestFCCH = -1; %could not find
    minDynamicRange
    error('Could not find any FCCH!');
end

%find other candidates, which may be necessary to find the start
%of the multiframe. Assuming oversampling=1, the FCCH are separated
%by 10 frames, each with 156.25*8=1250 symbols, i.e. 12500 samples
allCandidates = find(df < thresholdForDetectionInRad);
groupLimits=find(diff(allCandidates) > 6000);
numberOfFBGroups=length(groupLimits)+1;
fcchStartCandidates=zeros(1,numberOfFBGroups);
groupStart=allCandidates(1);
for i=1:numberOfFBGroups
    if i==numberOfFBGroups %last iteration is exception
        groupEnd=allCandidates(end);
    else
        groupEnd=allCandidates(groupLimits(i));
    end
    if 0 %use the minimum value
        [minDynamicRange, index_minDynamicRange] = min(df(groupStart:groupEnd));    
        fcchStartCandidates(i)= index_minDynamicRange+groupStart+start-1-TB;
    else %use median value given tail bits are also zero and influence here
        index_minDynamicRange=floor(median(groupStart:groupEnd))-1; %this minus 1 is empirical
        fcchStartCandidates(i)= index_minDynamicRange+start-1-tailingBitsInSamples;
    end    
    if i~=numberOfFBGroups %last iteration is exception
        groupStart=allCandidates(groupLimits(i)+1);
    end    
end

%% Do not allow negative indices
fcchStartCandidates(fcchStartCandidates < 1)=1;

if showPlots == 1
    clf
    %Fs = 270833; %sampling frequency    
    N=3; %number of bursts to the left and right
    startSample = (index_minDynamicRange-tailingBitsInSamples) - N*syncBitsLength; 
    endSample = index_minDynamicRange + (N+1)*syncBitsLength;
    if (startSample < 1)
        startSample = 1;
    end
    if endSample > length(df)
        endSample = length(df);
    end
    n=startSample:endSample;
    sa = cumsum(da); %would give the phase back    
    %sa is phase unwrapped, use trick to map to -pi to pi
    sa = angle(exp(1j*sa));
    subplot(311);    
    plot(start+n,sa(n)/pi*180); ylabel('Phase')
    axis tight
    subplot(312);    
    plot(start+n,da(n)/pi*180); ylabel('Difference')   
    hold on
    plot(start+n,-90*ones(size(n)),'r--');
    axis tight
    subplot(313);    
    plot(start+n,df(n)/pi*180);    
    hold on;
    plot(index_minDynamicRange,minDynamicRange/pi*180,'kx','markersize',20);
    %title('Location of a burst for frequency correction');
    xlabel('sample (n)');
    ylabel('max-min');
    axis tight    
end
