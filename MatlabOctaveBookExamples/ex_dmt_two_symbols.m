%transmit two DMT symbols (first with the channel relaxed)
N=4 %number of FFT points
h=[0.2 0.3 0.9] %channel impulse response
D=length(h)-1; %channel dispersion
L=D; %cyclic prefix length (minimum recommended value)
Hk = fft(h,N) %channel freq. response
Gk = 1 ./ Hk %frequency equalizer (FEQ): perfect estimate
ch_memory = zeros(1,D);  %initial channel memory zeroed
%Transmit 1st DMT symbol
Xk=[-1 -1-j 3 -1+j] %DMT symbol, transmitted information
xn=ifft(Xk)*sqrt(N)  %adopt orthonormal FFT
xp=[xn(N-L+1:end) xn]  %add cyclic prefix with L samples
[r,ch_memory]=filter(h,1,xp,ch_memory)%update channel mem.
yn=r(L+1:end)    %take CP out
Yk=fft(yn)/sqrt(N)  %an orthonormal FFT has been adopted
Zk = Yk .* Gk  %estimated symbols, after FEQ
ErrorInSymbols1 = Xk-Zk %check if symbols were recovered
%Transmit 2nd DMT symbol
Xk=[3 2-j 7 2+j] %info to be transmitted at 2nd symbol
xn=ifft(Xk)*sqrt(N)  %adopt orthonormal FFT
xp=[xn(N-L+1:end) xn]  %add cyclic prefix with L samples
[r,ch_memory]=filter(h,1,xp,ch_memory)%update channel mem.
yn=r(L+1:end)    %take CP out
Yk=fft(yn)/sqrt(N)  %an orthonormal FFT has been adopted
Zk = Yk .* Gk  %estimated symbols, after FEQ
ErrorInSymbols2 = Xk-Zk %check if symbols were recovered