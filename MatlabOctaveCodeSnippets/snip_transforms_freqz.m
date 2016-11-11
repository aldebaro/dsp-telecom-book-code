N1=5; %num. non-zero samples in the (aperiodic) pulse
x=[ones(1,N1) zeros(1,2)]; %signal x[n]
halfN=512; N=2*halfN; %half of the DFT dimension and N
k=0:N-1; %indices of freq. components
wk = k*2*pi/N; %angular frequencies
Xk_fft=fft(x,N);%use 2N-DFT to get N positive freqs.
Xk_fft=Xk_fft(1:halfN);%discard negative freqs.
wk=(0:halfN-1)*(2*pi/N); %positive freq. grid
subplot(211); plot(wk,20*log10(abs(Xk_fft))); %in dB
subplot(212); plot(wk,angle(Xk_fft)*180/pi); %in degrees

