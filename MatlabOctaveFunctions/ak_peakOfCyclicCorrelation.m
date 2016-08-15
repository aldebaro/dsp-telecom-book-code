function [peakValue,peakAlpha,peakLag] = ...
    ak_peakOfCyclicCorrelation(Cxx,alphas,lags,exclude0Alpha, ...
    onlyPositiveCycles)
if nargin < 5
    onlyPositiveCycles=0; %include negative cycles
end
if nargin < 4
    exclude0Alpha=0; %do not exclude alpha=0 when seeking peak
end
[numOfCycles,numOfLags]=size(Cxx);

%unwrap phase (not working)
%Cphase=unwrap(angle(Cxx2));
%Cphase=transpose(unwrap(transpose(angle(Cxx2))));
%Cphase=angle(Cxx);

if exclude0Alpha==1 || onlyPositiveCycles==1 %find alpha=0, will need
    zeroIndex = find(alphas==0);
    if isempty(zeroIndex) %try harder
        zeroIndex = find(abs(alphas)<1e-13);
        if isempty(zeroIndex) || length(zeroIndex)~=1
            error('Could not find alpha = 0');
        end
    end
end
if exclude0Alpha==1
    Cxx(zeroIndex,:)=0; %now discard values for alpha=0
end
if onlyPositiveCycles==1 %eliminate negative cycles:
    Cxx=Cxx(zeroIndex:end,:); %keep only positive cycles
    alphas=alphas(zeroIndex:end); %adjust alpha
end
Cmag=abs(Cxx); %get peak based on maximum magnitude value
[maxRow,maxCol]=find(Cmag==max(max(Cmag)),1); %,'first');
peakValue=Cxx(maxRow,maxCol);
peakAlpha=alphas(maxRow);
peakLag=lags(maxCol);