randn('state',0); rand('state',0);%reset random generators
M=16; %modulation order
numSymbols = 40000; % number of symbols
alphabet = [-(M-1):2:M-1]; %M-PAM constellation
symbolIndicesTx = floor(M*rand(1, numSymbols)); %random indices 0:M-1
s = alphabet(symbolIndicesTx + 1); %transmit symbols (indices 1 to M)
Pn = 2 %noise power (assumed to be in Watts)
n = sqrt(Pn)*randn(size(s)); %white Gaussian noise
r = s+n; %channel with additive white Gaussian noise
symbolIndicesRx = ak_pamdemod (r, M);% demodulate
SER = sum(symbolIndicesTx~=symbolIndicesRx)/numSymbols %symbol errors
Ps = mean(alphabet.^2) %transmit signal power (Watts)
Pr = mean(r.^2) %received signal power (Watts)
SNR = Ps/Pn %SNR in linear scale
N0_s = 10*log10(Ps/pi) %unilateral Tx PSD level in log scale
N0_r = 10*log10(Pr/pi) %unilateral Rx PSD level in log scale
N0_n = 10*log10(Pn/pi)%unilateral PSD noise level in log scale

