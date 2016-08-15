%% Illustrates channel partitioning via SVD
%h=[1 0.9]; %Impulse response of a simple channel H(z) = 1 + .9 z^-1
h=[1+3j 0.9+4j 0.5+0.j 0.3]; %Example of a complex channel
h=transpose(h); %force all vectors to be column vectors
N=5; %chosen number of independent channels. Number of columns of H
%X=transpose([1:N]);  %An example of real transmit symbols
X=transpose((1:N)+i*(N:-1:1));  %example of complex transmit symbols
H=convmtx(h,N); %matrix to implement convolution
[F,S,Mhermitian] = svd(H); %SVD decomposition
M=Mhermitian'; %obs: ' obtains the Hermitian (conjugate transpose)
x=M'*X %"modulate": x is the transmit signal
y=conv(h,x); %pass x through channel
Y=F' * y; %"demodulate" the channel output
lambdas = diag(S); %lambdas are the singular values of H
Y=Y(1:length(lambdas)); %ignore singular values that are zero
Xp = Y ./ lambdas; %equivalent to "equalization" (FEQ) in DMT
disp('Compare the received Xp with the transmitted symbols X'); X, Xp