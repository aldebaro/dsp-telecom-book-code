%Script learn_conversion_discrete_continuous.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Discrete-time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%frequency is an angle theta
%to have a periodic signal (see a DSP textbook): theta/(2*pi) = m/N
%example of periodic signal with period N=8
m=1; N=8; theta = m*2*pi/N;
L=10*N; %length of our example: use 10 periods
n=0:L-1;
x=cos(theta * n);
stem(n,x); title('x[n] - Abscissa shows the sample index')
pause

%Show the spectrum
X=fft(x);
Xmag = abs(X);
stem(fftshift(Xmag)); title('X(e^{j \Omega}) - Abscissa shows the sample index')
pause

%Improve the plot showing abscissa as an angle approximately from -pi to pi
%To find out how I came up with the logic below, think about Nfft = 4 and 3
%For N=4, the FFT angles are: 0, pi/2, pi and 3*pi/2
%For N=3, the FFT angles are: 0, 2*pi/3 and 4*pi/3
%In general, the FFT angles are: 0, 2*pi*k/N, ..., 2*pi*(N-1)/N
%for all N. The logic below is needed to find the most negative frequency
%and match the vector w with the result of the fftshift routine
Nfft = length(X);
deltaTheta = 2*pi/Nfft;  %the circle was divided in Nfft slices
if rem(Nfft,2)==0
    %Nfft is even and the negative frequencies start at -pi
    w = -pi:deltaTheta:pi-deltaTheta;
else
    %Nfft is odd and the negative frequencies start at -pi+(deltaTheta/2)
    w = -pi+(deltaTheta/2):deltaTheta:pi-(deltaTheta/2);
end
stem(w,fftshift(Xmag)); title('X(e^{j \Omega})'); xlabel('radians')
pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Continuous-time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%now the matter is to create the notion of time in seconds. We assume the
%sampling frequency is Fs and the sampling period Ts=1/Fs.
Ts = 1e-3; %1 milisecond
t = Ts * n;
stem(t,x);
pause

%the solution above simply scaled the n array by Ts, creating the t array
%this is also done in frequency domain
%the wc array is in radians/s while array w is in radians
Fs = 1/ Ts;
wc = Fs * w;
stem(wc,fftshift(Xmag)); title('X(wc)'); xlabel('radians/s')
pause

%if you look at the plot above, what is the frequency in Hz of the cosine
%located in theta radians? The answer follows below
f = wc / (2*pi);
stem(f,fftshift(Xmag));
title('X(wc) - Fs=1kHz and plot is from -500 to 500 Hz'); xlabel('Hz')
pause
%An angle tetha corresponds to 2*pi as each frequency fc corresponds to Fs
fc = Fs*theta/(2*pi);
disp(['Cosine frequency = ' num2str(fc)]);
%Note that Fs/fc = N (when m=1)

%Alteratively, instead of writing:
%x=cos(theta * n);
%one can write the signal in terms of the frequency fc in Hz:
x2 = cos(2*pi*fc/Fs*n);
%or yet, using t explicitly by using t = Ts * n and noting that Ts*Fs=1
%x3 = cos(2*pi*fc*t/(Ts*Fs));
x3 = cos(2*pi*fc*t);
%Conclusion: if one wants to use n then fc/Fs (adimensional), if t is used,
%then fc (in Hz)