demodulationMethod='conv' %choose among: 'inner', 'xcorr' or 'conv'
SNRdB = 30; %AWGN SNR in dB
S=10000; %number of symbols to be generated
D=16; %space dimension, equivalent to oversampling factor
x=[ones(1,D) %define all possible transmit signal as row vectors
    -ones(1,D)
    ones(1,D/2) zeros(1,D/2)
    zeros(1,D/2) ones(1,D/2)];
[M, temp] = size(x); %M is the number of input vectors, obs: temp = D
%M is also the modulation order (cardinality of the set of symbols)
[Ah,A]=ak_gram_schmidt(x,1e-12); %basis functions are columns of A
[N, temp] = size(Ah); %N is the number of basis functions (temp = D)
constellation=Ah*transpose(x); %find the constellation symbols
%% Transmitter
txIndices=floor(M*rand(1,S)); %random indices from [1, M]
m=constellation(:,txIndices+1); %obtain N random symbols
s=A*m; %obtain the signal to be transmitted (one column per symbol)
s=s(:); %concatenate all columns to create a one-dimensional signal
%% Channel
noise=sqrt(mean(abs(s).^2)/10^(0.1*SNRdB))*randn(S*D,1); %AWGN noise
r=s+noise; %add noise with specified SNR
rxSamples = reshape(r,D,S); %reorganize the samples as D x S matrix
%% Receiver
rxSymbols = zeros(N,S); %pre-allocate space
switch demodulationMethod %choose the demodulation "architecture"
    case 'inner' % Receiver via inner product (transform)
        rxSymbols = Ah*rxSamples; %symbols that represent signal
    case 'xcorr' % Receiver via cross-correlation
        for n=1:N %loop over all basis functions
            [R,lags]=xcorr(r,A(:,n)); %n-th basis function
            rxSymbols(n,:)=R(find(lags==0,1):D:end); %decimate
        end
    case 'conv' % Receiver via convolution
        for n=1:N %loop over all basis functions
            innerProductViaConv=conv(r,fliplr(A(:,n)'));%could use Ah
            rxSymbols(n,:)=innerProductViaConv(D:D:end); %decimate
        end
end
[rxIndices,m_hat]=ak_genericDemod(rxSymbols,constellation); %Decision
SER=sum(rxIndices ~= txIndices)/S %estimate the symbol error rate