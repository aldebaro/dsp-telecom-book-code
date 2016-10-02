%Example of receiver with timing offset, i.e., recovering the symbols
%at wrong time instants
dt_setGlobalConstants %set global variables
% the script dt_setGlobalConstants.m called above, sets the variable
% delayInSamples to 0. Here we add a random perturbation, to mimic
% an error at the receiver.
%showPlots=1; %disable plots
%delayInSamples = L/2; %high BER
delayInSamples = 15; %BER of 0.0402 assuming default parameters

temp=rand(Nbits,1); %random numbers ~[0,1]
txBitStream=temp>0.5; %bits: 0 or 1
[s, symbols]=ak_transmitter(txBitStream); %transmitter
%choose channel:
if useIdealChannel==1
    r=s;
else
    r=dt_channel(s);
end
[rxBitStream, ys]=ak_receiver(r); %receiver
%estimate BER (both vectors must have the same length)
BER=ak_estimateBERFromBits(txBitStream, rxBitStream)
baud = Fs/L  %symbol rate (bauds)
rate_bps = baud*b  %rate (bits per second)

if 1 %plot Tx / Rx symbols, at the baud rate
    nn=100; %number of initial samples to be shown
    clf
    subplot(211),plot(real(ys(1:nn))), hold on
    plot(real(symbols(1:nn)),'xr'); 
    title('Symbols - real part'), grid
    legend('Received','Transmitted');    
    subplot(212),plot(imag(ys(1:nn))), hold on
    plot(imag(symbols(1:nn)),'xr');
    title('Symbols - imag part'), grid
end