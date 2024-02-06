sigma = -0.3; w = 2*pi*5; %frequency of 5 Hz
z=-sigma+1j*w; %define a complex variable z
t=linspace(0,3,1000); %interval from [0, 3] sec.
x=exp(z*t); %the Laplace basis function
envelope = exp(-sigma*t); %the signal envelope
subplot(121);plot(t,real(x));hold on,plot(t,envelope,':r')


