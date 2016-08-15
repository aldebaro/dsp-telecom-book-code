%Perform a symbol-based simulation for square M-QAM
M=16;
snr_dB = linspace(0,16,100); %SNR in dB
const=ak_qamSquareConstellation(M); %constellation
Nsymbols=1e7; %number of symbols
txIndices = floor(M*rand(1,Nsymbols)); %0 to M-1
symbols = const(txIndices+1); %transmitted symbols
snr = 10 .^ (0.1*snr_dB); %linear SNR
signalPower = mean(abs(symbols).^2); %must use abs()
%noisePower is the noise power "per dimension". For QAM
%N=2 dimensions and the total noise power is 2*noisePower
noisePower=(signalPower ./ snr)/2; %noise power (sigma^2)
V=length(noisePower); %number of points in grid
ser = zeros(1,V); %pre-allocate space
for i=1:V
    %complex noise
    noise = sqrt(noisePower(i)) * randn(size(symbols))+...
        j * sqrt(noisePower(i)) * randn(size(symbols));    
    receivedSymbols = symbols + noise; %AWGN
    decodedSymbolIndices=ak_qamdemod(receivedSymbols,M);
     %estimate SER
    ser(i)=sum(decodedSymbolIndices~=txIndices)/Nsymbols;
end
%compare with theoretical expression:
qvalues = ak_qfunc(sqrt(3*snr/(M-1)));
temp = (1-1/sqrt(M))*qvalues;
theoreticalSER = 4*(temp  - temp.^2);
clf, semilogy(snr_dB,ser,snr_dB,theoreticalSER,'--');
xlabel('SNR (dB)'); ylabel('SER'); grid;
legend('Simulated','Theoretical');
