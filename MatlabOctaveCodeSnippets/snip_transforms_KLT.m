N=100; %number of vectors
K=4;   %vector dimension
line=1:N*K; %straight line
noisePower=2; %noise power in Watts
temp=transpose(reshape(line,K,N)); %block signal
x=temp + sqrt(noisePower) * randn(size(temp)); %add (AWGN) noise
z=transpose(x); plot(z(:)) %prepare for plot

