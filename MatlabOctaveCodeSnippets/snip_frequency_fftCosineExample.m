function snip_frequency_fftCosineExample()
clf, N=32; A=6; %clear figure, FFT length, cosine amplitude
M=1000; %number of sample points for DTFT visualization
alpha=8.3; %specifies the cosine frequency
Wc=(alpha*2*pi)/N; %cosine frequency in radians
W=linspace(0,2*pi,M); %frequency range
Xw=zeros(1,M); %DTFT values
for i=1:M %loop over frequencies and calculate DTFT values
  Xw(i) = (A/2)*(rect_dtft(W(i)+Wc, N)+rect_dtft(W(i)-Wc, N));
end
n=0:N-1; x=A*cos(Wc*n); %generate N samples of the cosine
Xfft = fft(x); %calculate FFT with N points
disp(['Max(abs(FFT))=' num2str(max(abs(Xfft)))])
disp(['Scalloping loss in DTFT=' num2str(A*N/2-max(abs(Xfft)))])
plot(W/pi,abs(Xw)),hold on, stem((0:N-1)*(2*pi/N)/pi,abs(Xfft),'or')
xlabel('Frequency \Omega (rad) normalized by \pi)')
ylabel('Magnitude'), legend('DTFT','DFT'),grid
end
function dtft_value = rect_dtft(Omega, N) %DTFT of rectangular window
  if Omega == 0
    dtft_value = N; %L'Hospital rule to correct NaN if 0/0
  else
    W_div_2 = Omega/2; %speed up things computing only once
    dtft_value=(sin(N*W_div_2)/sin(W_div_2))*exp(-1j*W_div_2*(N-1));
  end
end
