%% This code demonstrates DMT using convolution in matrix notation.
debugMe=0; %enable for debugging
useSimplifiedConvolution=1; %if enabled, convolution is calculated
%only for valid samples. Otherwise, the complete conv matrix is used
%
%The samples contained in the vectors below are ordered from the
%least recent to the most recent, the samples x[0], x[1], x[2]
%become the column vector [x[0];x[1];x[2]].
%For simplicity, all tones transmit the same QAM constellation.
M=32; %modulation order, number of symbols in alphabet
Nfft=16; %must be even
numDMTSymbols=50; %number of DMT symbols to be transmitted
h=[8.4 -2 -2.8 2 -2.8 2 -2.8 -2]; %longer example
%h=[1 0.9 0.8]; %impulse response using typical h=[h[0] h[1] h[2]]
if debugMe==1
    M=4; %modulation order, number of symbols in alphabet
    Nfft=6; %must be even, 6 will lead to only 2 tones carrying info.
    numDMTSymbols=5; %number of DMT symbols to be transmitted
    h=[1 0.9 0.8]; %impulse response using typical h=[h[0] h[1] h[2]]
end
%% Pre-processing / initialization
constellation=ak_qamSquareConstellation(M); %QAM constellation
numOfTones=(Nfft-2)/2; %chose not to use tones at DC and Nyquist
D=length(h)-1; %channel dispersion
CP=D; %cyclic prefix
if Nfft <= CP
    error('Nfft must be increased');
end
hmatrix = convmtx(transpose(h),Nfft+CP);
symbolIndicesTx=1+floor(M*rand(numOfTones,numDMTSymbols)); %randomize
if debugMe==1 %create indices 1,2,3...M,1,2,3...,M up to the end
    tempInteger = floor(numOfTones*numDMTSymbols/M);
    tempRemainder = numOfTones*numDMTSymbols-tempInteger*M;
    symbolIndicesTx = [repmat(1:M,1,tempInteger) 1:tempRemainder];
    %symbolIndicesTx=reshape(tempSequence,numOfTones,numDMTSymbols);
end
symbolsTx=constellation(symbolIndicesTx); %random QAM symbols
X=reshape(symbolsTx,numOfTones,numDMTSymbols); %QAM symbols as matrix
Xk=[zeros(1,numDMTSymbols) %DC level is assumed zero
    X
    zeros(1,numDMTSymbols) %Nyquist level is assumed zero
    conj(flipud(X))]; %Xk has Hermitian symmetry
x=ifft(Xk)*sqrt(Nfft); %adopt orthonormal FFT
P=[zeros(CP,Nfft-CP) eye(CP,CP) %permutation matrix
    eye(Nfft,Nfft)];
xp=P*x; %add cyclic prefix using permutation matrix
if useSimplifiedConvolution==1
    %take out CP and convolution tail. The convolution tail of
    %current block will affect only the CP samples of the next block. 
    %Because the CP samples are discarded, both CP samples and tails
    %can be ignored unless the complete convolution is desired.
    hmatrixValid = hmatrix(CP+1:CP+Nfft,:);
    yvalid=hmatrixValid*xp; %convolve with the channel
else
    y=hmatrix*xp; %convolve with the channel
    yvalid = y(CP+1:CP+Nfft,:); %extract only valid samples
end
if debugMe==1
    A=flipud(xp);
    xp2=A(:);
    y2=conv(xp2,h);
    y2=y2(1:(Nfft+CP)*numDMTSymbols);
    y2valid=reshape(y2,Nfft+CP,numDMTSymbols);
    y2valid(1:CP,:)=[]; %take out CP
    discrepancy=yvalid - flipud(y2valid);
    plot(discrepancy(:));
end
%% Receiver
H = fft(h,Nfft); %channel frequency response
H = H(2:Nfft/2); %only positive frequencies, no DC nor Nyquist
H = H(:); %make it a column vector
G = 1./H; %design the frequency equalizer (FEQ)
Y=fft(yvalid)/sqrt(Nfft); %an orthonormal FFT has been adopted
Y=Y(2:Nfft/2,:); %only positive frequencies, without DC and Nyquist
Yeq = repmat(G,1,numDMTSymbols).*Y; %perform equalization
[symbolIndicesRx, symbolsRx]=ak_qamdemod(Yeq,M); %demodulate
symbolIndicesRx=symbolIndicesRx+1; %make first index to be 1, not 0
if debugMe==1 %plot constellations
    clf, plot(real(symbolsTx),imag(symbolsTx),'xb'); hold on
    plot(real(Yeq),imag(Yeq),'or');
end
disp(['SER=' num2str(mean(symbolIndicesTx(:)~=symbolIndicesRx(:)))])