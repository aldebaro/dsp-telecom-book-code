%Example of digital transmission (part of application QamSynchronous)
dt_setGlobalConstants %set global variables, script in companion code
temp=rand(Nbits,1); %random numbers ~[0,1]
txBitStream=temp>0.5; %bits (0 or 1) as a column vector
s=ak_transmitter(txBitStream); %transmitter
%choose channel:
if useIdealChannel==1
    r=s;
else
    r=dt_channel(s);
end
%rxBitStream=ak_receiver(r, phaseCorrection); %receiver
rxBitStream=ak_receiver(r); %receiver
%estimate BER (both vectors must have the same length)
BER=ak_estimateBERFromBits(txBitStream, rxBitStream)
baud = Fs/L
rate_bps = baud*b

