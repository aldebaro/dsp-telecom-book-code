Nx=10; %number of samples of input training sequence
x=randn(Nx,1); %arbitrary input signal, as a column vector
h=[1;0.4;0.3;-0.2;0.1]; %arbitrary channel, also as a column vector
X=convmtx(x,length(h)); %prepare for convolution as matrix
y=X*h; %or y=conv(x,h), pass input signal through the channel
y=y+0.3*randn(size(y)); %add some random noise
h_est=pinv(X)*y %LS estimate via M-P pseudoinverse using pinv
h_est2=inv(X'*X)*X'*y %alternative LS estimate via M-P pseudoinverse
MSE=mean(abs(h-h_est).^2) %mean squared error with pinv
MSE2=mean(abs(h-h_est2).^2) %mean squared error via property
NMSE=10*log10(MSE/mean(abs(h).^2)) %normalized MSE in dB