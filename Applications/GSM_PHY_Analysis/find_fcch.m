function bcch_start = find_fcch(s, start, stop, showPlots)
% function bcch_start=find_fcch(s, start, stop, showPlots)
%Inputs: s->signal, start and stop->first and last samples
%if showPlots is 1, show a graph

r = s(start:stop); %extract segment of interest

OSR = 1; %oversampling
BL = 142*OSR; %number of samples in 142 bits of burst
TB = 3*OSR; %3 Tailing Bits at each side of the burst
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
df=NaN * ones(1,L-BL-1); %pre-allocate space
for i = 1 : (L-BL-1)
    %extract a sub-segment with 142 bits: da(i:i+BL-1)
    low  = min(da(i:i+BL-1)); %minimum angle difference
    high = max(da(i:i+BL-1)); %maximum angle difference
    df(i) = high - low;
end

%all phases are the same for a FB burst, so the difference
%should be zero.
[minDynamicRange, index_minDynamicRange] = min(df)

%the threshold for minDynamicRange is 1 rad
if minDynamicRange < 1 
    %find the sample index considering the whole input
    %vector, not only its segment (sum to start)
    bcch_start = index_minDynamicRange + start - TB;
else
    bcch_start = -1; %could not find
    warning('Could not find BCCH!');
    return;
end

if showPlots == 1
    clf
    %Fs = 270833; %sampling frequency    
    N=3; %number of bursts to the left and right
    startSample = (index_minDynamicRange-TB) - N*BL; 
    endSample = index_minDynamicRange + (N+1)*BL;
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
