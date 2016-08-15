N=1024; n=(0:N-1)'; %number N of samples and column vector n
A=10; x=A*cos((2*pi/64)*n); %generate cosine with period 64
[H,w] = periodogram(x,[],[],500); %Unilateral periodogram
[H2,w2] = periodogram(x,[],[],500,'twosided'); %Bilateral periodogram
Power = sum(H)*w(end)/length(H) %Power for unilateral periodograma
Power2 = sum(H2)*w2(end)/length(H2) %Power for bilateral periodograma
Power = Power*(1+2/N) %use correction factor to get average power
Power2 = Power2*(N/(N-1)) %use correction factor to get average power
