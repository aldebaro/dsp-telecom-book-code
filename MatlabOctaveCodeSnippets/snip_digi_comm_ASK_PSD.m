N=100000; %number of bits
bits=floor(2*rand(1,N)); %generate N random bits
%pwelch parameters (3rd has different syntax in Matlab and Octave)
window=8192;fftsize=window;fs=16000; 
s=ak_simpleBinaryModulation('ASK', bits); %get waveform
pwelch(s,window,[],fftsize,fs); %estimate PSD

