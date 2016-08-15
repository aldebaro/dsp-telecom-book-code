%adapted from script snip_digi_comm_correlative_decoding.m
clear all, close all
rand('seed',1); %make sure all simulations are the same
randn('seed',1);
S=100000; %number of symbols to be generated
L=16; %space dimension, equivalent to oversampling factor
x=[ones(1,L) %define all possible transmit signal as row vectors
    -ones(1,L)
    ones(1,L/2) zeros(1,L/2)
    zeros(1,L/2) ones(1,L/2)];
[M, temp] = size(x); %M is the number of input vectors, obs: temp = D
%M is also the modulation order (cardinality of the set of symbols)
[Ah,A]=ak_gram_schmidt(x,1e-12); %basis functions are columns of A
[D, temp] = size(Ah); %N is the number of basis functions (temp = D)
% Receiver via convolution: case 'conv'
rxSymbols = zeros(D,S); %pre-allocate space
innerProductViaConv = zeros(D,S*L+L-1); %pre-allocate space
%... (preceded by some code)
noisePower = 20; %AWGN power in Watts
noise=sqrt(noisePower)*randn(S*L,1); %generate AWGN noise
for n=1:D %loop over all basis functions    
    innerProductViaConv(n,:)=transpose(conv(noise,fliplr(A(:,n)')));
    rxSymbols(n,:)=innerProductViaConv(n,L:L:end); %decimate
end
[R1,lags]=xcorr(innerProductViaConv(1,:),30); %without decimation
[R2,lags]=xcorr(innerProductViaConv(2,:),30); %without decimation
[R1d,lags]=xcorr(rxSymbols(1,:),30); %decimation 16:1 (D=16)
[R2d,lags]=xcorr(rxSymbols(2,:),30); %decimation 16:1 (D=16)
P=floor(S/L); %num. of vectors for estimating covariances (P <= S/D)
C=cov(transpose(innerProductViaConv(:,L:P))) %covariance
Cd=cov(transpose(rxSymbols(:,1:P-L+1))) %use sequences with P values
%... (followed by some code)
C_outdiag = C-diag(diag(C)); %check the values out of diagonal
Cd_outdiag = Cd-diag(diag(Cd));
sum(C_outdiag(:).^2)
sum(Cd_outdiag(:).^2)

%% Plots
subplot(211)
stem(lags,R1)
hold on
stem(lags,R2,'r','Marker','x','MarkerSize',12)
title('No decimation (T_{sym} = T_s)')
ylabel('Autocorrelation R[k]');
legend('Basis 1','Basis 2');
subplot(212)
stem(lags,R1d)
hold on
stem(lags,R2d,'r','Marker','x','MarkerSize',12)
xlabel('lag k');
ylabel('Autocorrelation R[k]');
title('With decimation (T_{sym}=16)')
writeEPS('wgnExpansion','font12Only')

clf
subplot(311), [H,w]=freqz(A(:,1)); plot(w/pi,20*log10(abs(H))), grid
ylabel('|H_1(e^{j\Omega}| (dB)'); axis([0 1 -40 13])%axis tight 
subplot(312), psd(innerProductViaConv(1,:)), xlabel(''); 
ylabel('no decimation'); axis tight
subplot(313), psd(rxSymbols(1,:));  ylabel('decimation');
xlabel('Normalized frequency \Omega/\pi'); axis tight
writeEPS('wgnExpansionFrequency','font12Only')

%ak_hist2d(innerProductViaConv(1,:),innerProductViaConv(2,:),30,30)
clf
ak_hist2d(rxSymbols(1,:),rxSymbols(2,:),30,30);
xlabel('N_1'), ylabel('N_2'), zlabel('Occurrences')
axis tight
writeEPS('wgnExpansionHistogram','font12Only')
%plot(decimatedInnerProductViaConv1,decimatedInnerProductViaConv2,'x')
%plot(innerProductViaConv1,innerProductViaConv2,'x')