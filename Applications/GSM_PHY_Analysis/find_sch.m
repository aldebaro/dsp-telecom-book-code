function [sch_startViaSCH, crossCorrelation, lags]=find_sch(r, start)
%function [sch_startViaSCH, crossCorrelation, lags]=find_sch(r,start)
%Find SCH burst beginning. Inputs:
% r -> GSM signal
% start -> estimated sample to start the SCH
%Recall that the SCH burst has
%3 tail bits | 39 coded bits | 64 bits training seq. | 39 coded ...
%bits | 3 tail bits | 8.25 guard period bits
%Assumes signal is oversampled by 4 times the symbol rate.

global syncSymbols
if isempty(syncSymbols)
    error(['Globals not defined. Run the script' ...
        ' gsm_setGlobalVariables.m'])
end

OSR = 4; %oversampling ratio
%limit the search range to 610 samples
if start + 610 > length(r)
    sch_startViaSCH=-1;
    crossCorrelation=-1;
    lags=-1;
    warning('find_sch: not enough samples!')
    return
end
a = r(start:start+610);
%plotframe2(a); pause%plot mag, phase and phase difference
numSyncSamples = OSR*length(syncSymbols);
%number of samples of a that can be used in correlation:
N = length(a)-numSyncSamples;
crossCorrelation = zeros(1,N); %pre-allocate space
for lag = 1:N
    %extract segment of vector a with size equal to 
    %the size of syncSymbols and also same symbol rate
    segment = a(lag:OSR:lag+numSyncSamples-OSR);
    %crosscorrelation at lag is an inner product
    %(syncSymbols is a row vector and segment a column):
    crossCorrelation(lag)= syncSymbols * conj(segment);
end
%find the crosscorrelation peak
[maxCorrelation, location] = max(abs(crossCorrelation));

%Make a correction to point to the beginning of the SCH
%Recall that the SCH burst has
%3 tail bits | 39 coded bits | 64 bits training seq. | 39 coded ...
%bits | 3 tail bits | 8.25 guard period bits
%so, there are 42 = 39 + 3 bits before the training sequence
%Because OSR=4, 42 symbols correspond to 168 samples
sch_startViaSCH = start-1 + location - OSR*42;
lags = 1:N; %define lags that is part of the output