h=transpose([-4+j -3 -2-j]) %channel, column vector
Nh=length(h); %channel impulse response length
Nx=4095; %number of samples of training sequence
x=mseq(2,log2(Nx+1)); %training sequence (a maximum length sequence)
alpha=1/sum(x.^2); %1/alpha is the value of autocorrelation R(0)
y=conv(h,x); %input signal passes through the channel
%% Channel estimation and synchronization
z=conv(y,flipud(x)); %use convolution to mimic correlation, or
%alternatively, one could use z=xcorr(y,conj(x)); and to make exactly
%equivalent to conv extract part of result: z=z(end-2*Nx-Nh+3:end);
[maxOutput, maxIndex] = max(abs(z)); %find peak of output (R)
h_est=alpha*z(maxIndex:maxIndex+Nh-1) %estimated channel (postcursor)
MSE=mean(abs(h-h_est).^2) %estimation error
%% Compare with theoretical values
[R,lag]=xcorr(x); %autocorrelation. Obs: use stem(lag,R) to plot it
z2=conv(R,h); %conceptually, this is what we are doing to get z
z_error=max(abs(z-z2)) %note that z is equal to z2