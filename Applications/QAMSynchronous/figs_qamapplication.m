%generates all figures of interest with example
%of digital transmission
dt_setGlobalConstants %set global variables
showPlots=0; %it show plots and pause at each one
shouldWriteEPS=1; %it will write a EPS file with each plot
temp=rand(Nbits,1); %random numbers ~[0,1]
txBitStream=temp>0.5; %bits: 0 or 1
s=ak_transmitter(txBitStream); %transmitter
r=dt_channel(s);
rxBitStream=ak_receiver(r); %receiver
%estimate BER (both vectors must have the same length)
BER=ak_estimateBERFromBits(txBitStream, rxBitStream)
baud = Fs/L %symbol rate in bauds
rate_bps = baud*b %bit rate in bps