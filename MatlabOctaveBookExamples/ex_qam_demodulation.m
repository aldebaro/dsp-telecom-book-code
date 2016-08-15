%% QAM modulation and demodulation using only real-valued signals
%% Transmitter: generate QAM signal centered at Fs/4 Hz (pi/2 rad)
M=16; %number of symbols, modulation order
constellation=ak_qamSquareConstellation(M); %QAM constellation
S=1000; %total number of symbols to be simulated
symbolIndicesTx=floor(M*rand(1,S)); %indices at transmitter
symbolsTx=constellation(symbolIndicesTx+1); %random symbols sequence
sym_i=real(symbolsTx); sym_q=imag(symbolsTx); %extract real/imag
L=8; %oversampling factor
xi=zeros(1,S*L); xq=zeros(1,S*L); %pre-allocate space
xi(1:L:end)=sym_i; xq(1:L:end)=sym_q; %complete upsampling operation
p=ones(1,L); %NRZ square wave shaping pulse (there are better pulses)
xi=conv(p,xi); xq=conv(p,xq); %convolve upsampled with shaping pulse
%frequency upconvert by carrier at pi/2 rad that corresponds to Fs/4
n=0:length(xi)-1; %"time" index
s = xi.*(2*cos(pi/2*n)) + xq.*(2*sin(pi/2*n)); %generate QAM signal
%% Channel:
r = s;  %ideal channel: no noise, unlimited band
%% Receiver (runs the demodulation):
ri = r .* cos(pi/2*n); %start recovering in-phase component
rq = r .* sin(pi/2*n); %start recovering quadrature component
b=fir1(length(p)-1,0.5); %FIR with same order of the shaping filter
                         %and use a cutoff frequency of pi/2 rad
ri = conv(b,ri); %filter the two components to eliminate...
rq = conv(b,rq); %the terms at twice the carrier frequency
%skip the transient due to the filters, otherwise it ...
%shows spurious symbol at (0,0) due to filter's transients
firstSample=floor(length(p)/2)+floor(length(b)/2)+1; %first sample
lastSample=firstSample+L*S-1; %last sample to obtain S symbols
yi=ri(firstSample:L:lastSample); %extract S symbols at baud rate
yq=rq(firstSample:L:lastSample); %extract S symbols at baud rate
symbolsRx=yi + 1j*yq; %recompose complex-valued symbols (at baseband)
plot(real(symbolsRx),imag(symbolsRx),'x'); %plot constellation at Rx
symbolIndicesRx=ak_qamdemod(symbolsRx,M); %QAM decoding
SER=ak_calculateSymbolErrorRate(symbolIndicesRx,symbolIndicesTx)
