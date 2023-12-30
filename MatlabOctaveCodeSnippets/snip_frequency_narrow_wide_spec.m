[s,Fs,wmode,fidx]=readwav('WeWereAway.wav','r'); %read wav file
numbits = fidx(7); % num of bits per sample (should be 16)
Nfft = 1024; %number of FFT points
figure(1), M=64; %window length in samples for wideband
specgram(s,Nfft,Fs,hann(M),round(3/4*M)); colorbar
figure(2), M=256; %window length in samples for narrowband
specgram(s,Nfft,Fs,hann(M),round(3/4*M)); colorbar

