function [ber, ser, SNRdB]=ex_simulatePAMInAWGN(numberOfBytes, oversample, M, noisePower)
b=log2(M);
bytesTx = floor(256*rand(1,numberOfBytes)); %generate random bytes
symbolIndicesTx = ak_sliceBytes(bytesTx, b);
%it is the modulator who will set the bauds (signaling rate)
constellation = pammod(0:M-1, M);
symbols = pammod(symbolIndicesTx,M); % Modulate
%convert symbols into a waveform
%define a simple shaping pulse
p = ones(1,oversample);
%make sure pulse has unitary power
p = p / (mean(p.^2));
numSymbols = length(symbols); %number of symbols
waveform = zeros(1,numSymbols*oversample); %pre-allocate space
waveform(1:oversample:end) = symbols;
waveform = filter(p,1,waveform); % Pulse shaping filtering
%send waveform through the channel
n = sqrt(noisePower)*randn(size(waveform));
r = waveform + n;
SNRdB=10*log10(mean(waveform.^2)/mean(n.^2));
%implement receiver
%find proper initial sample to start sampling
initialSample = oversample/2; %take sample in the middle of symbol
receivedSymbols = r(initialSample:oversample:end); %sample
%power = mean(receivedSymbols.^2);
%receivedSymbols = receivedSymbols * sqrt(constellationEnergy/power);
symbolIndicesRx = pamdemod(receivedSymbols, M);
if 0
    figure
    plot(receivedSymbols,zeros(size(receivedSymbols)),'x');
    hold on
    plot(constellation,zeros(size(constellation)),'or');
    title('received symbols');
    figure
    N=length(r);
    plot(1:N,r,[initialSample:oversample:N],r([initialSample:oversample:N]),'kx');
    title('received waveform and sampling instants');
end
bytesRx = ak_unsliceBytes(symbolIndicesRx, b);
ser = ak_calculateSymbolErrorRate(symbolIndicesTx, symbolIndicesRx);
ber = ak_estimateBERFromBytes(bytesTx, bytesRx);
%disp(['SER (symbol error rate) = ' num2str(100*ser) ' %']);
%disp(['BER (bit error rate) = ' num2str(100*ber) ' %']);
end