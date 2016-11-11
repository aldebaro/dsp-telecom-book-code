Nx=10; %number of samples of input training sequence
x=randn(Nx,1); %arbitrary input signal, as a column vector
h=transpose(1:5) %arbitrary channel, also as a column vector
X=convmtx(x,length(h)); %prepare for convolution as matrix
y=X*h; %or y=conv(x,h), pass input signal through the channel
y=y+0.2*randn(size(y)); %add some random noise
h_est=pinv(X)*y %LS estimate via M-P pseudoinverse using pinv
h_est2=inv(X'*X)*X'*y %alternative LS estimate via M-P pseudoinverse
MSE=mean(abs(h-h_est).^2) %mean squared error