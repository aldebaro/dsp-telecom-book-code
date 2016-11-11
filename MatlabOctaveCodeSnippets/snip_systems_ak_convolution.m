x1=1:3; %define sequence x1
x2=5:8; %define sequence x2
nx1=-3:-1; %define abscissa for x1
nx2=2:5; %define abscissa for x2
subplot(311); stem(nx1,x1)
subplot(312); stem(nx2,x2)
[y,n]=ak_convolution2(x1,x2,-3,2); %calculate convolution
subplot(313); stem(n,y) %show result with proper time axis

