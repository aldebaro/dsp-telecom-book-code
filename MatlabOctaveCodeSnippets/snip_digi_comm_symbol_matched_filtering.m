numberOfSymbols=400; %number of symbols to be transmitted
noisePower=4; %noise power
constellation=[-3 -1 1 3]; %4-PAM constellation, energy=5
L=8; p=ones(1,L); %define a pulse 
Ep = sum(p.^2); %pulse energy
symbolIndicesTx=floor(4*rand(1,numberOfSymbols));%indices
transmittedSymbols=constellation(symbolIndicesTx+1);%symb.
%Gaussian noise:
n = sqrt(noisePower/Ep)*randn(size(transmittedSymbols));
receivedSymbols = transmittedSymbols + n; %add noise
symbolIndicesRx = pamdemod(receivedSymbols, M);%demodulate
SER=sum(symbolIndicesTx~=symbolIndicesRx)/numberOfSymbols

