numberOfSymbols=400; %number of symbols to be transmitted
noisePower=0.5; %noise power
constellation=[-3 -1 1 3]; %4-PAM constellation, energy=5
symbolIndicesTx=floor(4*rand(1,numberOfSymbols)); %indices
transmittedSymbols=constellation(symbolIndicesTx+1);%symb.
n=sqrt(noisePower)*randn(size(transmittedSymbols)); %noise
receivedSymbols = transmittedSymbols + n; %add noise
symbolIndicesRx = pamdemod(receivedSymbols, M);%demodulate
SER=sum(symbolIndicesTx~=symbolIndicesRx)/numberOfSymbols

