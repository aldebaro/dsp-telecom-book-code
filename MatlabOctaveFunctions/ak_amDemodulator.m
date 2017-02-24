function x=ak_amDemodulator(rx,Fs,fcarrier)
% function y=ak_amDemodulator(x,Fs,fcarrier)
%This function performs AM demodulation on multiplexed signal x with
%sampling frequency Fs (Hz) and assuming the carrier frequency is
%fcarrier (Hz). The bandwidth (BW) is assumed to be 3 kHz for the
%AM signal ("station") to be demultiplexed.
Foff=3.0e3; %lowpass filter cutoff frequency (BW=3 kHz)
Norder=100; %filter order
B=fir1(Norder,Foff/(Fs/2)); %design FIR filter for Fs
%% Envelope detection and lowpass filtering
w_digital=(2*pi*fcarrier)/Fs; %digital carrier frequency (rad)
carrier = cos(w_digital*[0:length(rx)-1]); %generate carrier
rbb = rx.*carrier(:); %rbb is a signal replica at baseband
rbb = filter(B,1,rbb); %filter received signal using B at Fs
mx=abs(rbb); %process only the magnitude of rbb
mx=mx-mean(mx); %subtract mean
x=filter(B,1,mx); %filter received signal using B at Fs