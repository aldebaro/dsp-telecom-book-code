%Perform a symbol-based simulation for square M-QAM
M=16; %number of symbols
ebN0_dB = linspace(0,14,20); %SNR in dB
Nsymbols=1e5; %number of symbols
b=log2(M); %number of bits per symbol
const=ak_qamSquareConstellation(M); %constellation
Rsym = 400; %symbol rate (bauds)
R = Rsym*b; %rate in bps
Fs = Rsym; %sampling rate in Hz
Nbits = Nsymbols*log2(M); %Number of transmitted bits
txIndices = floor(M*rand(1,Nsymbols)); %0 to M-1
symbols = const(txIndices+1);
ebN0 = 10 .^ (0.1*ebN0_dB); %linear Eb/N0
snr = ebN0 * R / Fs; %linear SNR
Eb=mean(abs(symbols).^2)/R; %energy per bit, note abs(.)
N0 = Eb ./ ebN0; %one-sided AWGN PSD
%noisePower is the noise power "per dimension". For QAM
%N=2 dimensions and the total noise power is 2*noisePower
noisePower = (N0*Fs)/2; %noise power (sigma^2)
V=length(noisePower); %number of points in grid
ser = zeros(1,V); %pre-allocate space
for i=1:V
    %generate complex noise
    noise = sqrt(noisePower(i)) * randn(size(symbols))+...
        j * sqrt(noisePower(i)) * randn(size(symbols));
    %AWGN
    receivedSymbols = symbols + noise;
    decodedSymbolIndices=ak_qamdemod(receivedSymbols,M);
     %estimate SER
    ser(i)=sum(decodedSymbolIndices~=txIndices)/Nsymbols;
end
%compare with theoretical expression:
qvalues = ak_qfunc(sqrt(3*snr/(M-1)));
temp = (1-1/sqrt(M))*qvalues;
theoreticalSER = 4*(temp  - temp.^2);
clf,semilogy(ebN0_dB,ser,'x',ebN0_dB,theoreticalSER,'--');
xlabel('E_b / N_0 (dB)'); ylabel('SER'); grid;

%using Matlab:
[berm, serm] = berawgn(ebN0_dB, 'QAM', M);
hold on
semilogy(ebN0_dB,serm,'or');

legend('Simulated','Theoretical','Matlab theo');
