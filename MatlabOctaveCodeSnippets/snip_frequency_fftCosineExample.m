clf, N=32; A=6; %clear figure, FFT length and cosine amplitude 
wc=linspace(0,pi,1000); %cosine frequency
Xw0=A*(sin((N/2)*wc)./sin(wc/2)).*cos(wc*(N-1)/2); %FFT value at DC
Xw0(1)=A*N; %use L'Hospital to correct NaN in first element (wc=0)
plot(wc/pi,Xw0),hold on,plot([0:2*pi/N:pi]/pi,zeros(1,N/2+1),'or')
xlabel('Normalized cosine frequency \Omega_c (rad / \pi)')
ylabel('FFT DC value Xw[0]'), legend('FFT values','FFT bins'),grid