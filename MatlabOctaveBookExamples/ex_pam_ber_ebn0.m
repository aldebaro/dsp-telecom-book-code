%Perform a symbol-based simulation for binary PAM / PSK
d=20; %Distance between symbols
A=d/2; %Amplitude A=d/2 Volts
R = 200; %rate in bps
Fs = R; %sampling rate in Hz
Nbits = 1e6; %Number of transmitted bits
bits = rand(1,Nbits)>0.5; %bits (0 or 1)
symbols = A*2*(bits-0.5); %symbols (-A or A)
ebN0_dB = linspace(0,10,100); %Eb/N0 in dB
ebN0 = 10 .^ (0.1*ebN0_dB); %linear Eb/N0
Eb = A^2/R; %energy per bit, or Eb=mean(symbols.^2)/R
N0 = Eb ./ ebN0; %one-sided AWGN PSD
noisePower = N0*Fs/2; %noise power (sigma^2)
V=length(noisePower); %number of points in grid
ber = zeros(1,V); %pre-allocate space
for i=1:V
    %generate noise
    noise = sqrt(noisePower(i)) * randn(size(symbols));    
    receivedSymbols = symbols + noise; %AWGN
    %recover bits using ML threshold equal to 0
    decodedBits = receivedSymbols > 0;
    ber(i) = sum(decodedBits ~= bits)/Nbits; %estimate BER
end
%compare with theoretical expression:
theoreticalBER = ak_qfunc(sqrt(2*ebN0));
clf,semilogy(ebN0_dB,ber,ebN0_dB,theoreticalBER,'--');
xlabel('E_b / N_0 (dB)'); ylabel('BER'); grid;
legend('Simulated','Theoretical');

