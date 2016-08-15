sigma2=0.5; %power per component (real and imaginary): 0.5 Watt
N=10000; %number of samples
noise=sqrt(sigma2)*randn(1,N)+1j*sqrt(sigma2)*randn(1,N); %complex
mean(abs(noise).^2) %estimate the noise power (approximately 1 Watt)

