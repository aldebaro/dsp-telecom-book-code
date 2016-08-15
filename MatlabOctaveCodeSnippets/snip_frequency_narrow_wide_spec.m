[s,Fs,numbits]=wavread('WeWereAway.wav'); %read wav file
Nfft = 1024; %number of FFT points
M=64; %window length
specgram(s,Nfft,Fs,hann(M),round(3/4*M)); colorbar, pause
M=256;specgram(s,Nfft,Fs,hann(M),round(3/4*M));colorbar

