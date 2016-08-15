function [ber,ser,SNRdB,snrOutMF]=ak_matchedFilterSimulationOfPAMWithISI(numberOfBytes,...
    oversample, M, noisePower)
%Inputs:
%numberOfBytes -> number of bytes to be transmitted
%oversample -> oversampling factor
%M -> modulation order (number of symbols)
%noisePower -> noise power
%Outputs:
%ber -> bit error rate
%ser -> symbol error rate
%SNRdB -> signal to noise ratio in dB before matched filtering
%snrOutMF -> signal to noise ratio in dB after matched filtering
b=log2(M);
bytesTx = floor(256*rand(1,numberOfBytes)); %generate random bytes
symbolIndicesTx = ak_sliceBytes(bytesTx, b);
%constellation = pammod(0:M-1, M); %if want to see constelllation
symbols = pammod(symbolIndicesTx,M); % modulate
%convert symbols into a waveform
%define a simple shaping pulse
p = ones(1,oversample);
%make sure pulse has unitary power
%p = p / (mean(p.^2));
numSymbols = length(symbols); %number of symbols
waveform = zeros(1,numSymbols*oversample); %pre-allocate space
waveform(1:oversample:end) = symbols;
waveform = filter(p,1,waveform); % Pulse shaping filtering
%send waveform through the channel
n = sqrt(noisePower)*randn(size(waveform));
r = waveform + n;
SNRdB=10*log10(mean(waveform.^2)/mean(n.^2));
disp(['SNR at the input of the matched filter: ' num2str(SNRdB) ' dB'])
%implement receiver
rf = filter(p,1,r);
%normalize
mean(waveform.^2)
mean(n.^2)
Ep = sum(p.^2) %energy of shaping pulse
rf = rf / Ep;

%find proper initial sample to start sampling
initialSample = oversample;
receivedSymbols = rf(initialSample:oversample:end); %sample

%split the noise and signal processing for the sake of studying
nf = filter(p,1,n);
waveformf = filter(p,1,waveform);
%sample each one
noiseInSymbols = nf(initialSample:oversample:end); 
signalInSymbols = waveformf(initialSample:oversample:end); 
snrOutMF=10*log10(mean(signalInSymbols.^2)/mean(noiseInSymbols.^2));
disp(['SNR at the output of the matched filter: ' num2str(snrOutMF) ' dB'])
mean(signalInSymbols.^2)
mean(noiseInSymbols.^2)

symbolIndicesRx = pamdemod(receivedSymbols, M);
bytesRx = ak_unsliceBytes(symbolIndicesRx, b);
ser = ak_calculateSymbolErrorRate(symbolIndicesTx, symbolIndicesRx);
ber = ak_estimateBERFromBytes(bytesTx, bytesRx);