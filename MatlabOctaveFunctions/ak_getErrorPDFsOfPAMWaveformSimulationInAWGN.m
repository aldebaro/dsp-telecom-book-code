function [organizedSymbols,numOfExamplesPerSymbol,errorsPerSymbol,...
    confusionMatrix,ber,ser,SNRdB]= ...
    ak_getErrorPDFsOfPAMWaveformSimulationInAWGN(numberOfBytes,...
    oversample, M, noisePower)
%Inputs: 
%numberOfBytes -> number of bytes to be transmitted
%oversample -> oversampling factor
%M -> modulation order (number of symbols)
%noisePower -> noise power
%Outputs:
%organizedSymbols -> matrix with Rx symbols organized based on the
%       respective Tx symbol. Each line corresponds to the received 
%       symbols of a given Tx symbol
%numOfExamplesPerSymbol -> number of occurrences of each Tx symbol
%errorsPerSymbol -> number of errors corresponding to each Tx symbol
%confusionMatrix -> matrix in which the line indicates the Tx and the
%       column the Rx symbol
%ber -> bit error rate
%ser -> symbol error rate
%SNRdB -> signal to noise ratio in dB
b=log2(M);
bytesTx = floor(256*rand(1,numberOfBytes)); %generate random bytes
symbolIndicesTx = ak_sliceBytes(bytesTx, b);
%count how many examples of each symbol were generated
numOfExamplesPerSymbol = zeros(1,M);
for i=1:M
    numOfExamplesPerSymbol(i) = sum(symbolIndicesTx==i-1);
end
%pre-allocate space considering the maximum number
organizedSymbols= zeros(M,max(numOfExamplesPerSymbol));
%constellation = pammod(0:M-1, M); %if want to see constelllation
symbols = pammod(symbolIndicesTx,M); % modulate
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
symbolIndicesRx = pamdemod(receivedSymbols, M);
bytesRx = ak_unsliceBytes(symbolIndicesRx, b);

countPerSymbol=zeros(1,M);
confusionMatrix=zeros(M,M);
for i=1:length(receivedSymbols)
    currentTxSymbol = symbolIndicesTx(i)+1; %sum 1 because symbols are in [0,M-1]
    countPerSymbol(currentTxSymbol)=countPerSymbol(currentTxSymbol)+1;
    organizedSymbols(currentTxSymbol,countPerSymbol(currentTxSymbol))=receivedSymbols(i);
    confusionMatrix(symbolIndicesTx(i)+1,symbolIndicesRx(i)+1)=confusionMatrix(symbolIndicesTx(i)+1,symbolIndicesRx(i)+1)+1;
end

%count the number of errors per symbol. Subtract the number of matches
%that corresponds to the main diagonal of confusionMatrix
errorsPerSymbol=sum(confusionMatrix')-diag(confusionMatrix)';

%ser = ak_calculateSymbolErrorRate(symbolIndicesTx, symbolIndicesRx);
ser = sum(errorsPerSymbol)/length(receivedSymbols)
ber = ak_estimateBERFromBytes(bytesTx, bytesRx);

