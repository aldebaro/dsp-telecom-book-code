%Example of digital transmission
dt_setGlobalConstants %set global variables
temp=rand(Nbits,1); %random numbers ~[0,1[
txBitStream=temp>0.5; %bits: 0 or 1
s=ak_transmitter(txBitStream); %transmitter
%choose channel:
if useIdealChannel==1
    r=s;
else
    r=dt_channel(s);
end
rxBitStream=ak_receiver(r); %receiver
%estimate BER (both vectors must have the same length)
BER=ak_estimateBERFromBits(txBitStream, rxBitStream)
baud = Fs/L  %symbol rate (bauds)
rate_bps = baud*b  %rate (bits per second)