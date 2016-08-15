M=16; %modulation order
snrsdB=-3:30; %specified SNR range (in dB)
snrs=10.^(0.1*(snrsdB)); %conversion from dB to linear
numberOfSymbols = 40000; %number of symbols
alphabet = [-(M-1):2:M-1]; %symbols of a M-PAM
symbolIndicesTx = floor(M*rand(1, numberOfSymbols)); %randomly
s = alphabet( symbolIndicesTx +1); %transmitted signal
signalPower = mean(alphabet.^2); %signal power (Watts)
for i=1:length(snrs) %loop over all SNR of interest
    noisePower = signalPower/snrs(i); %noise power (Watts)
    n = sqrt(noisePower)*randn(size(s));%white Gaus. noise
    r = s + n; %add noise to the transmitted signal
    symbolIndicesRx = ak_pamdemod ( r, M); %decision
    SER_empirical(i) = sum(symbolIndicesTx ~= ...
        symbolIndicesRx)/numberOfSymbols%Symbol error rate
end
%Compare empirical and theoretical values of SER:
SER_theoretical=2*(1-1/M)*qfunc(sqrt(3*snrs/(M^2-1)));
semilogy(snrsdB,SER_theoretical,snrsdB,SER_empirical,'x');

