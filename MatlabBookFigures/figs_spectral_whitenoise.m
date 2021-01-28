clf
power=8; %Watts
N=10000; %number of samples
x=sqrt(power)*randn(1,N);
Fs=40;

maxLag=100;
[R,l]=xcorr(x,x,maxLag,'biased');
stem(l,R); xlabel('lag l'); ylabel('autocorrelation R[l]');
writeEPS('autocorrelationWhiteNoise');

%[Pxx,f] = pwelch(x,window,noverlap,f,fs)
subplot(211); pwelch(x,[],[],[],Fs);
ylabel('PSD (dB/Hz)')  
title('')
subplot(212); pwelch(x); title('')
ylabel('PSD (dB/rad)')
writeEPS('psdsWhiteNoise');

close all, clear all
%% generate some H(z) - case 1 - AR model (IIR)
snip_frequency_PSD_estimation
legend1 = legend('Welch''s','theoretical','AR estimate')
set(legend1,'Position',[0.1515 0.7456 0.2321 0.1444]);
xlabel('f (Hz)'); ylabel('PSDs (dB/Hz)')
%writeEPS('arSpectrumMatched','font12Only');
writeEPS('arSpectrumMatched');

%% generate some H(z) - case 2 - MA model (FIR)
clf, clear all
f=[0 0.25 0.3 0.55 0.6 0.85 0.9 1]; %frequencies
Amp=[1 1 0 0 1 1 0 0]; %amplitudes
M=10; %filter order
Bsystem=firls(M,f,Amp); %design FIR with LS algorithm
Asystem = 1; %the FIR filter has denominator equal to 1
h=Bsystem; %impulse response of a FIR coincides with B(z)
%Eh=sum(Bsystem.^2); %Normalize filter: new impulse response...
%Bsystem=Bsystem/sqrt(Eh); %should have energy Eh=1
%Eh=sum(Bsystem.^2); %new impulse response energy (equals 1)

%% generate x[n] and y[n]
Fs=8000; %sampling frequency
Py_desired = 3; %power in Watts for the random signal y[n]
S=10000; %number of samples for y[n]
Eh=sum(h.^2); %energy of the system's impulse response
Px=Py_desired/Eh; %input power to reach Py_desired
x=sqrt(Px)*randn(1,S); %white Gaussian with power Px Watts
y=filter(Bsystem,Asystem,x); %finally, generate y[n]
Py=mean(y.^2); %get power, to check if close to Py_desired
disp(['Power (Watts): simulated=' num2str(Py) ...
    ', desired=' num2str(Py_desired)])
%% LPC analysis for estimating the PSD of y[n]
P=20;%we do not know correct order of A(z). Use high value
[A,Perror]=aryule(y,P); %use Yule-Walker to estimate H(z)
N0over2 = Perror/Fs; %value for the bilateral PSD Sx(w)
N0=2*N0over2; %assume a unilateral PSD Sy(w)=N0/|A(z)|^2
Nfft=1024; %number of FFT points for all spectra
[Hw,f]=freqz(1,A,Nfft,Fs); %frequency response H(w)
Sy=N0.*(abs(Hw).^2); %PSD estimated via AR modeling
[Py,f2]=pwelch(y,hamming(Nfft),[],Nfft,Fs); %Welch's
[Hsystem,f3]=freqz(Bsystem,Asystem,Nfft,Fs); %DTFT
Sy_theoretical=(Px/(Fs/2)).*(abs(Hsystem).^2);%theoretical
plot(f2,10*log10(Py),f3,10*log10(Sy_theoretical),...
    f,10*log10(Sy));
legend1 = legend('Welch''s','theoretical','AR estimate')
set(legend1,'Position',[0.1461 0.1384 0.2571 0.1587]);
xlabel('f (Hz)'); ylabel('PSDs (dB/Hz)')
%writeEPS('arSpectrumUnmatched','font12Only');
writeEPS('arSpectrumUnmatched');

%% Zero-padding does not alleviate leakage
clf
N=256; %number of samples available of x1 and x2
n=0:N-1; %abscissa
kweak=32; %FFT bin where the weak cosine is located
kstrong1=38; %FFT bin for strong cosine in x1
weakSigal = 1*cos((2*pi*kweak/N)*n+pi/3); %common parcel
x1=100*cos((2*pi*kstrong1/N)*n+pi/4) + weakSigal; %x1[n]
kstrong2=37.5; %location for strong cosine in x2
x2=100*cos((2*pi*kstrong2/N)*n+pi/4) + weakSigal; %x2[n]
%x=x2.*hamming(N)'; %perform windowing
x=x2.*kaiser(N,7.85)'; %perform windowing
factor=max(abs(fft(x))); %normalization factor
subplot(211)
w=-pi:2*pi/N:pi-2*pi/N;
plot(w,fftshift(20*log10(abs(fft(x)/factor))));
axis([-pi pi -100 0])
w=-pi:2*pi/(8*N):pi-2*pi/(8*N);
ylabel('|Y(e^{j \Omega})| (dB)');
subplot(212)
plot(w,fftshift(20*log10(abs(fft(x,8*N)/factor))));
axis([-pi pi -100 0])
xlabel('\Omega (radians)');
ylabel('|Z(e^{j \Omega})| (dB)');
writeEPS('zeroPaddingAndLeakage','font12Only');



clf
subplot(211)
w=-pi:2*pi/N:pi-2*pi/N;
plot(w,fftshift(20*log10(abs(fft(x)/factor))));
axis([-pi pi -100 0])
w=-pi:2*pi/(8*N):pi-2*pi/(8*N);
ylabel('|Y(e^{j \Omega})| (dB)')
title('Window of 256 samples');


%% Zero-padding does not, but increasing the number of samples does improve
%% resolution
N=256; %number of samples available of x1 and x2
%Mimic the effect of keeping the same sampling rate, but
%incrasing the number of samples available for analysis
w_weak=32*2*pi/N; %frequency in rads
w_strong2=37.5*2*pi/N; %frequency in rads
%from now on, use a larger N
factor=8;
N=N*factor;
n=0:N-1; %abscissa
newFFTresolution = 2*pi/N;
kweak=w_weak/newFFTresolution; %FFT bin where the weak cosine is now located
kstrong2=w_strong2/newFFTresolution; %new FFT bin for strong cosine in x2
weakSigal = 1*cos(w_weak*n+pi/3); %common parcel
x2=100*cos(w_strong2*n+pi/4) + weakSigal; %x2[n]
%x=x2.*hamming(N)'; %perform windowing
x=x2.*kaiser(N,7.85)'; %perform windowing
factor=max(abs(fft(x))); %normalization factor
subplot(212)
w=-pi:2*pi/N:pi-2*pi/N;
plot(w,fftshift(20*log10(abs(fft(x)/factor))));
axis([-pi pi -100 0])
w=-pi:2*pi/(8*N):pi-2*pi/(8*N);
ylabel('|Y(e^{j \Omega})| (dB)');
title('Window of 2048 samples');
xlabel('\Omega (radians)');
writeEPS('moreSamplesForLessLeakage','font12Only');