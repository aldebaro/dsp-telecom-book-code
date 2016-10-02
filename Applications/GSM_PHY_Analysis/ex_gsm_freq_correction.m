const=[1 j -1 -j]*exp(j*pi/2); %QPSK constellation
wc=2*pi/3; %carrier frequency
N=40; %number of symbols
n=0:N-1; %discrete-time index
%picking symbols counterclockwise to generate FB
s=const( rem(n,4) + 1 );
txcarrier=exp(-j*wc*n); %carrier at transmitter
x=s.*txcarrier; %modulated signal, oversampling = 1
%simulate a demodulation with frequency error
dw = 0.1 %error (frequency offset) in rad
rxcarrier=exp(j*(wc+dw)*n); %carrier at receiver
sq=x.*rxcarrier; %demodulated signal
%trick to find the angle differences between samples:
angleDiff=angle(sq(1:N-1).*conj(sq(2:N)));
%estimate frequency offset:
dw_estimated = -pi/2 - mean(angleDiff) %in rad
sq_corrected = sq .* exp(-j*dw*n); %compensate freq offset
