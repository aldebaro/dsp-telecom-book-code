M=16; %modulation order
numberOfSymbols = 40000; % number of symbols
alphabet = [-(M-1):2:M-1]; %M-PAM constellation
symbolIndicesTx = floor(M*rand (1, numberOfSymbols ));
s = alphabet(symbolIndicesTx +1); %transmit signal
r = s; %no channel: received = transmit signal
symbolIndicesRx = ak_pamdemod(r, M);% demodulate
numberOfErrors = sum(symbolIndicesTx ~= symbolIndicesRx)

