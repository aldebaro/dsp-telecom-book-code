N=4; %number of FFT points
x=[6 0 0 0]; %signal truncated in N samples
X=fft(x)/sqrt(N); %orthonormal FFT, conserve power
G=abs(X).^2; %energy spectral density (ESD)
Sms=G/N %the mean-square spectrum, its sum is the power
Shat=G %PSD estimate via the periodogram
Shat2=N*Sms %Alternative: obtain PSD from MS spectrum
Power=sum(Sms) %power in frequency domain (obeys Parseval)

