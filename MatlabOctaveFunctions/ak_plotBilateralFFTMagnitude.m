function [maxFFTValue,maxFreq]=ak_plotBilateralFFTMagnitude(x,Fs)
% function ak_plotBilateralFFTMagnitude(x,Fs)
%Plot the FFT magnitude of x using a bilateral spectrum. Normalize
%the FFT by the FFT length, such that the output corresponds to
%the DTFS. Fs is the sampling frequency, used to plot the abscissa.
%The default value for Fs is 1 Hz. It returns the FFT value 
%corresponding to the largest magnitude and its frequency in Hz.
if nargin < 2
    Fs=1; %default value
end 
X=fft(x); %calculate FFT
Nfft = length(X); %get FFT length
deltaF = Fs/Nfft;  %the unit circle was divided in Nfft slices
%For N=4, the FFT angles are: 0, pi/2, pi and 3*pi/2
%For N=3, the FFT angles are: 0, 2*pi/3 and 4*pi/3
%In general, the FFT angles are: 0, 2*pi*k/N, ..., 2*pi*(N-1)/N
if rem(Nfft,2)==0
    %Nfft is even and the negative frequencies start at -Fs/2
    f = -Fs/2:deltaF:Fs/2-deltaF;
else
    %Nfft is odd: negative frequencies start at -Fs/2+(deltaF/2)
    f = -Fs/2+(deltaF/2):deltaF:Fs/2-(deltaF/2);
end
X=fftshift(X); %move negative frequencies to the left part
Xmag=20*log10(abs(X)/Nfft); %magnitude in dB
h=plot(f,Xmag); %plot graph
maxIndex=find(Xmag==max(Xmag),1,'last'); %find maximum magnitude
maxFFTValue=X(maxIndex); %return value, FFT value (complex-valued)
maxFreq=f(maxIndex); %return value, frequency in Hertz
%makedatatip(h,maxIndex) %if running Matlab, this makes a data tip
myaxis=axis; axis([f(1),f(end),myaxis(3), myaxis(4)])
xlabel('frequency (Hz)'); ylabel('20 log10(abs(X)/Nfft)  (dBW)');