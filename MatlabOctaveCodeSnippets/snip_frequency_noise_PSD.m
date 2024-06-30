N = 300; % number of samples and FFT size
A=10; x=A*cos((2*pi/64)*n); %generate cosine with period 64
power_x = 600; %desired noise power in Watts
Fs = 1; %sampling frequency = BW = 1
x=sqrt(power_x) * randn(1,N); %Gaussian white noise
actualPower = mean(x.^2) %the actual obtained power 
[Sk,F]=periodogram(x,[],[],Fs,'twosided'); %periodogram 
subplot(211), plot(2*pi*F,Sk); %plot periodogram
Sx_th=power_x*ones(1,length(F)); %theoretical PSD
mean(Sk) %in this case, it coincides with actualPower
disp(['Periodogram standard deviation=' num2str(std(Sk))])
hold on; h=plot(2*pi*F,Sx_th,'r:','lineWidth',3);