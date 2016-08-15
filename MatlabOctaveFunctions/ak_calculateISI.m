function [isi, parcelsMatrix] = ak_calculateISI(symbols, p, oversample, start)
numSymbols = length(symbols); %number of symbols
waveform = zeros(1,numSymbols*oversample); %pre-allocate space
waveform(1:oversample:end) = symbols;
r = conv(p,waveform);
%r = filter(p,1,waveform);
outSymbols = r(start:oversample:end);
isi = symbols - outSymbols(1:length(symbols));

parcelsMatrix = zeros(numSymbols, length(r));
Np = length(p);
for i=1:numSymbols
    firstSample = 1+(i-1)*oversample;
    lastSample = firstSample + Np - 1;
    parcelsMatrix(i,firstSample:lastSample) = symbols(i) * p;
end

%if you check, then the commands below show that r=r2
%r2 = sum(parcelsMatrix)
%plot(r - r2)