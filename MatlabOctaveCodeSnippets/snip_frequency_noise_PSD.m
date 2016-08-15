N = 300; % number of samples and FFT size
power_x = 600; %desired noise power in Watts
x=sqrt(power_x) * randn(1,N); %Gaussian white noise
actualPower = mean(x.^2) %the actual obtained power 
[Sk,w]=periodogram(x); %Periodogram (unilateral) calculation
subplot(211), plot(w,2*pi*Sk); %plot scaled periodogram
Sx_th=power_x*ones(1,length(w)); %theoretical PSD
hold on; h=plot(w,Sx_th,'r:'); %plot the theoretical PSD