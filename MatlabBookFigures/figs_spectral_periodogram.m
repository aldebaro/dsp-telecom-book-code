clear all, close all
snip_frequency_not_bin_cent_cos
subplot(211), makedatatip(h,round([k1;k2]+1))
xlabel('Tone index k')
ylabel('Sms[k]'), %then plot in dB scale:
axis([0 N-1 -50 50]), %title('MS Spectrum')
subplot(212), makedatatip(h2,round([k1;k2]+1))
xlabel('\Omega (rad)'), ylabel('S[k]')
%title('Periodogram');
axis([0 pi -40 40])
writeEPS('sumOfCosinesPeriodogramMSS')

clear all, close all
snip_frequency_periodogram %generate the signals
clf %do the plot again
subplot(211),h=stem(Sk); grid, 
output_txt = {['X: ',num2str(5,4)],...
    ['Y: ',num2str(254.6,4)]};
text(8,250,output_txt)
%makedatatip(h,5) %linear scale
ylabel('S[k]'), %then plot in dB scale:
title('Bilateral periodogram. FFT length=64')
subplot(212),h2=stem(Smatlab); grid, 
output_txt = {['X: ',num2str(17,4)],...
    ['Y: ',num2str(Smatlab(17),4)]};
text(19,Smatlab(17),output_txt)
%makedatatip(h2,17) %linear scale
xlabel('k'), ylabel('S[k]'), %then plot in dB scale:
title('Unilateral periodogram. FFT length=256')
writeEPS('cosinePeriodograms','font12Only')

clear all, close all
snip_frequency_normalized_periodogram %execute script
%N=1024; A=10; x=A*cos(2*pi/64*(0:N-1));%generate cosine
%Fs=8000; %sampling frequency
%rectWindow=rectwin(N); %rectangular window
%df = Fs/N; %FFT bin width
%[P,f]=periodogram(x,rectWindow,N,Fs); %periodogram 
%Power=sum(P)*df %calculate again, to compare with Power
clf, %redo figure
h=plot(f/1000,10*log10(P)); grid, makedatatip(h,17) %linear scale
xlabel('Frequency (kHz)'), ylabel('S(f) (dBW/Hz)'), %graph in Hz
writeEPS('cosinePeriodogramFs8000','font12Only')

clear all, close all
randn('state',0); % reset seed for randn generator
N=1024; A=4; %# of samples and cosine amplitude of A Volts
Fs=8000; Ts=1/Fs; %sampling frequency (Hz) and period (s)
f0=915; %cosine frequency in Hz
noisePower=16; %noise power in Watts
noise=sqrt(noisePower)*randn(1,N);
t=0:Ts:(N-1)*Ts; %N time instants separated by Ts
x=A*cos(2*pi*f0*t) + noise;%generate cosine with AWGN
rectWindow=rectwin(N); %rectangular window
df = Fs/N; %FFT bin width
[P,f]=periodogram(x,rectWindow,N,Fs); %periodogram 
Power=sum(P)*df %calculate again, to compare with Power
subplot(211);
h=plot(f,10*log10(P)); makedatatip(h,[118; 400]) %linear scale
grid, 
axis([0 4000 -50 15])
%xlabel('f (Hz)'), 
ylabel('S(f) (dBW/Hz)'), %in Hz
title('1024-points FFT')
%% 
N=2*8192; A=4; %# of samples and cosine amplitude of A Volts
Fs=8000; Ts=1/Fs; %sampling frequency (Hz) and period (s)
f0=915; %cosine frequency in Hz
noisePower=16; %noise power in Watts
noise=sqrt(noisePower)*randn(1,N);
t=0:Ts:(N-1)*Ts; %N time instants separated by Ts
x=A*cos(2*pi*f0*t) + noise;%generate cosine with AWGN
rectWindow=rectwin(N); %rectangular window
df = Fs/N; %FFT bin width
[P,f]=periodogram(x,rectWindow,N,Fs); %periodogram 
Power=sum(P)*df %calculate again, to compare with Power
subplot(212);
h=plot(f,10*log10(P)); makedatatip(h,[2*(8*118-8+2)-1;2*3200+2]) %linear scale
grid, xlabel('f (Hz)'), ylabel('S(f) (dBW/Hz)'), %in Hz
axis([0 4000 -50 15])
title('16384-points FFT')
writeEPS('cosineOnAWGN','font12Only')

clf
N=3000; %total number of samples
n=0:N-1; %abscissa
x1=100*cos(2*pi/30*n); %first cosine
x2=1*cos(2*pi/7*n); %second cosine
x=[x1 x2]; %concatenation of 2 cosines
%plot(0:2*N-1,x)
subplot(211), pwelch(x), title('')
ylabel('PSD');
subplot(212), specgram(x), colorbar
xlabel('time (samples)');
writeEPS('cosinesSpectrogram','font12Only')