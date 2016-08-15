x=[1 2 3 4 5 6] %define an arbitrary test vector
X=fft(x); N=length(x); %calculate FFT and its length
Xu=[X(1) 2*X(2:(N/2)) X((N/2)+1)]; %Xu = 2 u(f) X(f)
x2 = real(ifft(Xu,N)) %use ifft zero-padding. find x2=x

