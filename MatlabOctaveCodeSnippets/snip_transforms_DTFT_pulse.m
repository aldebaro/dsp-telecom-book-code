N=20; %DFT size
N1=5; %num. non-zero samples in the (aperiodic) pulse
x=[ones(1,N1) zeros(1,N-N1)]; %signal x[n]
N2=512; %num. samples of the DTFT theoretical expression
k=0:N2-1; %indices of freq. components
wk = k*2*pi/N2; %angular frequencies
Xk_fft = fft(x); %use N-point DFT to sample DTFT
Xk_theory=(sin(wk*N1/2)./sin(wk/2)).*exp(-j*wk*(N1-1)/2);
Xk_theory(1) = N1; %take care of 0/0 (NaN) at k=0
subplot(211); stem(2*pi*(0:N-1)/N,abs(Xk_fft));
hold on, plot(wk,abs(Xk_theory),'r');
subplot(212); stem(2*pi*(0:N-1)/N,angle(Xk_fft));
hold on, plot(wk,angle(Xk_theory),'r');

