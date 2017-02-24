function x=ak_amDemodulator(rx,Fs,fcarrier)
% function x=ak_amDemodulator(rx,Fs,fcarrier)
%This function performs AM demodulation on multiplexed signal x with
%sampling frequency Fs (Hz) and assuming the carrier frequency is
%fcarrier (Hz). The bandwidth (BW) is assumed to be 3 kHz for the
%AM signal ("station") to be demultiplexed.
if Fs > 200e3
    warning('Sampling frequency may be too large for filtering')
end
Foff=3.0e3; %lowpass filter cutoff frequency (BW=3 kHz)
Norder=100; %filter order
B=fir1(Norder,Foff/(Fs/2)); %design lowpass FIR filter
w_digital=(2*pi*fcarrier)/Fs; %digital carrier frequency (rad)
carrier = cos(w_digital*[0:length(rx)-1]); %generate carrier
rbb = rx.*carrier(:); %rbb has a signal replica at baseband
rbb = conv(B,rbb); %filter signal
numTransientSamples=floor(Norder/2); %number of samples in transient
mx = rbb(numTransientSamples:end); %take out transient
mx = abs(mx); %process only the magnitude: envelope detection
mx = mx-mean(mx); %subtract mean
x=filter(B,1,mx); %filter signal again for improved result
x = x(numTransientSamples:end); %take out transient
x = x(1:length(rx)); %force output to have same size of input rx
