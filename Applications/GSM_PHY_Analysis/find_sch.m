function [fch_startViaSCH, crossCorrelation, lags] = ...
    find_sch(r, start, stop)
%function [fch_startViaSCH, crossCorrelation, lags] = ...
%    find_sch(r, start, stop)
%Find SCH burst beginning. Inputs:
% r -> GSM signal
% start -> estimated sample to start the SCH
% stop -> limits the search range

global showPlots syncBits syncSymbols
if isempty(syncSymbols)
    error(['Globals not defined. Run the script' ...
        ' gsm_setGlobalVariables.m'])
end

OSR = 4; %oversampling ratio
%limit the search range to 610 samples
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

%Make a correction to point to the beginning of the FB
%Because OSR=4, 42 symbols correspond to 168 samples
fch_startViaSCH = start + location - OSR*42;
lags = 1:N; %define lags