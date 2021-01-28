%% generate some H(z) - case 1 - AR model (IIR)
p1=0.5; p2=0.3+1j*0.2; p3=0.3-1j*0.2; %defining the poles...
p4=0.9*exp(1j*2);p5=0.9*exp(-1j*2); %as complex conjugates
Asystem=poly([p1 p2 p3 p4 p5]); %find H(z) denominator
Asystem=real(Asystem); %get rid of numerical errors
Bsystem=1; %H(z) numerator given that H(z) is all-poles
h = impz(Bsystem,Asystem,200); %H(z) impulse response
%% generate x[n] and y[n]
Fs=8000; %sampling frequency
Py_desired = 3; %power in Watts for the random signal y[n]
S=100000; %number of samples for y[n]
Eh=sum(h.^2) %energy of the system's impulse response
x=sqrt(Py_desired/Eh)*randn(S,1); %white Gaussian with given power
y=filter(Bsystem,Asystem,x); %finally, generate y[n]
Px=mean(x.^2) %get power, to check if close to Py_desired/Eh
Py=mean(y.^2) %get power, to check if close to Py_desired
%% LPC analysis for estimating the PSD of y[n]
P = 5; %assume we know the correct order of A(z) (matched condition)
%if using Matlab, it is possible to adopt lpc instead of aryule
%[A,Perror]=lpc(y,P); %lpc solves Yule-Walker to estimate H(z)
[A,Perror]=aryule(y,P); %solves Yule-Walker, both Matlab and Octave
%note that Perror is approximately Py_desired/Eh, the power of x
N0over2 = Perror/Fs; %value for the bilateral PSD Sx(w)
N0=2*N0over2; %assumes a unilateral PSD Sy(w)=N0/|A(z)|^2
Nfft=1024; %number of FFT points for all spectra
[Hw,f]=freqz(1,A,Nfft,Fs); %frequency response H(w) from 1/A(z)
Sy=N0*(abs(Hw).^2); %unilateral PSD estimated via AR modeling
[Swelch,f2]=pwelch(y,hamming(Nfft),[],Nfft,Fs); %Welch's PSD
[Hsystem,f3]=freqz(Bsystem,Asystem,Nfft,Fs); %DTFT of assumed system
Sy_theoretical=(Px/(Fs/2)).*(abs(Hsystem).^2);%theoretical PSD
plot(f2,10*log10(Swelch),f3,10*log10(Sy_theoretical),...
    f,10*log10(Sy));%compare PSD from Welch, AR and theoretical