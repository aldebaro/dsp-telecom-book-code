%Perform a symbol-based simulation for binary PAM / PSK
d=20; %Distance between symbols
A=d/2; %Amplitude A=d/2 Volts
Nbits = 1000; %Number of transmitted bits
bits = rand(1,Nbits)>0.5; %bits (0 or 1)
symbols = A*2*(bits-0.5); %symbols (-A or A)
snr_dB = linspace(0,10,100); %SNR in dB
snr = 10 .^ (0.1*snr_dB); %linear SNR
noisePower = A^2 ./ snr; %noise power (sigma^2)
V=length(noisePower); %number of points in grid
ber = zeros(1,V); %pre-allocate space
for i=1:V
    %generate noise
    noise = sqrt(noisePower(i)) * randn(size(symbols));
    %AWGN
    receivedSymbols = symbols + noise;
    %recover bits using ML threshold equal to 0
    decodedBits = receivedSymbols > 0;
    ber(i) = sum(decodedBits ~= bits)/Nbits; %estimate BER
end
%compare with theoretical expression:
if 1 %first option
    theoreticalBER = ak_qfunc(d ./ (2*sqrt(noisePower)) );
else %second option
    theoreticalBER = ak_qfunc(sqrt(snr));
end
clf, semilogy(snr_dB,ber,snr_dB,theoreticalBER,'--');
xlabel('SNR (dB)'); ylabel('BER'); grid;
legend('Simulated','Theoretical');
