function [ber,ser,SNRdB] = ...
    ak_waveformSimulationOfPAMInAWGN(numberOfBytes,...
    oversample, M, noisePower)
%[ber,ser,SNRdB] = ...
%    ak_waveformSimulationOfPAMInAWGN(numberOfBytes,...
%    oversample, M, noisePower)
%Inputs: 
%numberOfBytes -> number of bytes to be transmitted
%oversample -> oversampling factor
%M -> modulation order (number of constellation symbols)
%noisePower -> noise power
%Outputs:
%ber -> bit error rate
%ser -> symbol error rate
%SNRdB -> signal to noise ratio in dB
b=log2(M); %number of bits per symbol
bytesTx = floor(256*rand(1,numberOfBytes)); %random bytes
symbolIndicesTx = ak_sliceBytes(bytesTx, b);
%constellation = pammod(0:M-1, M); %see the constelllation
symbols = pammod(symbolIndicesTx,M); % modulate
%% 1) Convert symbols into a waveform:
p = ones(1,oversample); %define a simple shaping pulse
p = p / (mean(p.^2)); %make sure pulse has unitary power
numSymbols = length(symbols); %number of symbols
waveform = zeros(1,numSymbols*oversample); %pre-allocate 
waveform(1:oversample:end) = symbols;
waveform = filter(p,1,waveform); % Pulse shaping filtering
%% 2) Send waveform through AWGN channel
n = sqrt(noisePower)*randn(size(waveform));%generate noise
r = waveform + n; %add transmitted signal and noise
SNRdB=10*log10(mean(waveform.^2)/mean(n.^2));%estimate SNR
%% 3) Implement simple receiver:
initialSample = oversample/2; %sample in middle of symbol
receivedSymbols = r(initialSample:oversample:end); %sample
symbolIndicesRx = pamdemod(receivedSymbols, M);
bytesRx = ak_unsliceBytes(symbolIndicesRx, b);
ser = ak_calculateSymbolErrorRate(symbolIndicesTx, ...
    symbolIndicesRx); %estimate SER
ber = ak_estimateBERFromBytes(bytesTx, bytesRx); % BER