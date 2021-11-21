%Transmit a single DMT symbol with the channel relaxed
N=4 %number of FFT points
h=[0.6 1.2 0.3] %channel impulse response
Hk = fft(h,N) %find the channel freq. response at tone frequencies
Gk = 1 ./ Hk %frequency equalizer (FEQ): assume a perfect estimate
Xk=[-1 -1-1j 3 -1+1j] %DMT symbol, transmitted information
xn=ifft(Xk)*sqrt(N)  %adopt orthonormal FFT (Parseval applies)
xp=[xn(N-1) xn(N) xn]  %add cyclic prefix with Lcp=2 samples
r=conv(xp,h) %transmit over channel via linear convolution
yn=r(3:6)    %take cyclic prefix out
Yk=fft(yn)/sqrt(N)  %an orthonormal FFT has been adopted
Zk = Yk .* Gk  %estimated symbols, after FEQ, compare with Xk
