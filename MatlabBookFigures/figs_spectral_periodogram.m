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
snip_frequency_cosines_psd
writeEPS('twocosinesPeriodogram','font12Only')

clear all, close all
N=128; n=(0:N-1)'; %number of samples and column vector
Fs=2000; %bandwidth in Hertz, equivalent to sampling frequency
dW=(2*pi)/N; %FFT bin width in radians, to define cosines
k1=N/4; k2=N/8; W1=k1*dW; W2=k2*dW;%define frequencies in radians
x=10*cos(W1*n) + 1*cos(W2*n); %create sum of bin-centered cosines
Sdef = (abs(fft(x)).^2)/(N*Fs); %periodogram via its definition
Sdef = [Sdef(1); 2*Sdef(2:N/2); Sdef(N/2+1)]; %convert to unilateral
[S,w] = periodogram(x,hamming(N),N,Fs); %using periodogram function
Power_freq=(Fs/N)*sum(S) %estimate power (watts) in frequency domain
Power_time=mean(x.^2) %estimate power (watts) in time domain
h=plot(w,10*log10(Sdef),'-x'); hold on
h2=plot(w,10*log10(S),'-ro'); %Periodogram (dB scale)
xlabel('f (Hz)'), ylabel('S(f) (dBW/Hz)')
%use w=W Fs to convert to f in Hz and show datatips (f=W*Fs/(2*pi))
f1=W1*Fs/(2*pi); f2=W2*Fs/(2*pi); %frequencies in Hz
datatip(h,f1,Sdef(k1)); datatip(h,f2,Sdef(k2));
df=Fs/N; %bin width in Hz
plot([f2 f1], [10*log10(0.5/df) 10*log10(50/df)], 'kx', 'MarkerSize', 12)
legend('Rectangular','Hamming','True values')
writeEPS('hamming_periodogram','font12Only')

clear all, close all
N=128; n=(0:N-1)'; %number of samples and column vector
Fs=2000; %bandwidth in Hertz, equivalent to sampling frequency
dW=(2*pi)/N; %FFT bin width in radians, to define cosines
k1=N/4+0.5; k2=N/8+0.5; W1=k1*dW; W2=k2*dW;%define frequencies in radians
x=10*cos(W1*n) + 1*cos(W2*n); %create sum of bin-centered cosines
Sdef = (abs(fft(x)).^2)/(N*Fs); %periodogram via its definition
Sdef = [Sdef(1); 2*Sdef(2:N/2); Sdef(N/2+1)]; %convert to unilateral
[S,w] = periodogram(x,hamming(N),N,Fs); %using periodogram function
Power_freq=(Fs/N)*sum(S) %estimate power (watts) in frequency domain
Power_time=mean(x.^2) %estimate power (watts) in time domain
h=plot(w,10*log10(Sdef),'-x'); hold on
h2=plot(w,10*log10(S),'-ro'); %Periodogram (dB scale)
xlabel('f (Hz)'), ylabel('S(f) (dBW/Hz)')
%use w=W Fs to convert to f in Hz and show datatips (f=W*Fs/(2*pi))
%use w=W Fs to convert to f in Hz and show datatips (f=W*Fs/(2*pi))
f1=W1*Fs/(2*pi); f2=W2*Fs/(2*pi); %frequencies in Hz
datatip(h,f1,Sdef(floor(k1))); datatip(h,f2,Sdef(floor(k2)));
df=Fs/N; %bin width in Hz
plot([f2 f1], [10*log10(0.5/df) 10*log10(50/df)], 'kx', 'MarkerSize', 12)
legend('Rectangular','Hamming','True values')
writeEPS('hamming_nonbincenter','font12Only')

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