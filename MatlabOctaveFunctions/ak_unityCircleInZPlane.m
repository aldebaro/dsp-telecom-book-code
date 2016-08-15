function ak_unityCircleInZPlane(Hz_num, Hz_den)
N=200; %number of points to sample the unity circle
z_circle=exp(j*linspace(0,2*pi,N)); %z values in unity circle
Hz_circle=polyval(Hz_num,z_circle)./polyval(Hz_den,z_circle);
hold on
plot3(real(z_circle),imag(z_circle),...
    20*log10(abs(Hz_circle)),'k','linewidth',2); %plot in dB
hold off