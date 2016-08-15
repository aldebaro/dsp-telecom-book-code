Script ak_svd_partitioning.m
%example of partitioning through SVD. Design the matrices and 
%send two SVD symbols to test the effect of the channel memory
clear all, close all
showPlots = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Problem-specific information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 1
    N=6 %number of subchannels
    h=10^(-6)*[1 1 0 0 1]; %channel
    L=4 %guard interval    
    %N=4
    %h=[1 2]
    %L=1
else
    %example 4.5.1 in Cioffi, page 338
    h=[0.9 1] %channel
    L=1 %guard interval
    N=8 %number of subchannels
end

gap_dB = 6;
gap = 10^(gap_dB/10) %convert from dB to linear

noisePSD_dBm = -110;
N0d2 = 1e-3 * 10^(noisePSD_dBm/10) %convert from dBm to Watts

totalPower_dBm = 20.4;
totalPower = 1e-3 * 10^(totalPower_dBm/10) %convert from dBm to Watts

bauds = 4000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Design the SVD-based system: find the modulator e demodulator matrices
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Eq. (4.181), page 336, from Cioffi:
%the channel matrix has dimension N x (N+L) and has the impulse response
%filled with N-1 zeros on its rows
numZeros = N-1
h_withzeros = [h zeros(1,numZeros)]
P = transp(circulant(h_withzeros));  %creates a (N+L) x (N+L) matrix
P = P(1:N,:)  %want to keep only the first N rows

%    [U,S,V] = SVD(X) produces a diagonal matrix S, of the same 
%    dimension as X and with nonnegative diagonal elements in
%    decreasing order, and unitary matrices U and V so that X = U*S*V'.
% note: http://mathworld.wolfram.com/UnitaryMatrix.html
[F,S,Mhermitian] = svd(P);
lambdas = diag(S);
M=Mhermitian';

%check SVD decomposition for numerical errors
P2 = F*S*M;
error = max(abs(P(:)-P2(:)))

%check if the matrices can "partition" the channel
%because the matrices are unitary F*F'=I and M*M'=I
% P=F*S*M => F'*P*M' = S
S2 = F'*P*M';
error = max(abs(S(:)-S2(:)))

%get the magnitude (gains) of each subchannel
g = lambdas.^2;

%now do waterfilling: all subchannels are submitted to the same noise
[txPower,waterlevel,SNR]= ...
    simplewaterfill(g,N0d2,gap,totalPower);

SNRdB = 10*log10(SNR)

bitsPerDimension=0.5*log2(1 + SNR/gap)

rate = bauds*sum(bitsPerDimension)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Transmit two SVD symbols over the channel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%initialize filter memory with zeros. The length is the order of the
%filter, that is, its number of coefficients minus 1
ch_memory = zeros(1, length(h)-1);

%First symbol:
%say we want to transmit a vector with N real symbols
X = [1:N zeros(1,L)] %zero-pad with L zeros to create Eq (4.184) of Cioffi
X = transp(X); %make it a column vector

%modulate 1st SVD symbol
x = M'*X  %x has size N+L. It already includes the guard interval
%to save computation, given that X has L zeros, this is equivalent to:
Mtemp = M';
x2 = Mtemp(:,1:N) * X(1:N); %use only the N first columns of M'

%pass through channel, which is equivalent to r=P*x, because:
% r = P*x = (F*S*M)*x = (F*S*M)*(M'*X) = F*S*X
%but we are using the filter function, to take the channel memory in
%account explicitly
x_orderedInTime = flipud(x);  %note the order in time of elements in (4.181) of Cioffi
%convolve and update channel memory:
[r, ch_memory]=filter(h,1,x_orderedInTime,ch_memory) 

%check via matrix multiplication whether or not r is equal to r2
r2 = P*x;

%discard the samples in the guard interval and organize column vector such
%that the samples in the bottom are the first ones in time
y = flipud(r(L+1:L+N))

%demodulate
% Y = F' * y = F'* F*S*X = S*X
Y = F' * y;

%normalize by the SVD values, it is the equivalent of a FEQ in DMT
Xp = Y ./ lambdas

disp('Check the error between input and output of first symbol')
sum(abs(X(1:N)-Xp))

%transmit second symbol
X = [-(1:N) zeros(1,L)] %zero-pad with L zeros to create Eq (4.184) of Cioffi
X = transp(X); %make it a column vector

%modulate 1st SVD symbol
x = M'*X  %x has size N+L. It already includes the guard interval

%pass through channel, which is equivalent to y=P*x, because:
% r = P*x = (F*S*M)*x = (F*S*M)*(M'*X) = F*S*X
%but we are using the filter function, to take the channel memory in
%account explicitly
x_orderedInTime = flipud(x);
%convolve and update channel memory:
[r, ch_memory]=filter(h,1,x_orderedInTime,ch_memory);

%check via matrix multiplication
r2 = P*x;

%discard the samples in the guard interval and organize column vector such
%that the samples in the bottom are the first ones in time
y = flipud(r(L+1:L+N))

%demodulate
% Y = F' * y = F'* F*S*X = S*X
Y = F' * y;

%normalize by the SVD values, it is the equivalent of a FEQ in DMT
Xp = Y ./ lambdas

disp('Check the error between input and output of second symbol')
sum(abs(X(1:N)-Xp))
