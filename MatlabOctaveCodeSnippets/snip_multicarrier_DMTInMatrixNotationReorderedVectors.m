%% This code demonstrates DMT using the convention in [Ginis,2006]:
%The samples contained in these vectors are ordered from the most
%recent to the least recent x[0], x[1], x[2] becomes [x[2];x[1];x[0]]
%The code snip_multicarrier_DMTInMatrixNotation.m uses another order.
debugMe=1; %enable for debugging
useSimplifiedConvolution=1; %if enabled, convolution is calculated
%only for valid samples. Otherwise, the complete conv matrix is used
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
hmatrix = convmtx(transpose(fliplr(h)),Nfft+CP); %most recent first
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
P=[eye(Nfft,Nfft) %permutation matrix
    eye(CP,CP) zeros(CP,Nfft-CP)];
xp=P*x; %add cyclic prefix using permutation matrix
if useSimplifiedConvolution==1
    hmatrixValid = hmatrix;
    hmatrixValid(end-CP+1:end,:)=[]; %take out CP
    hmatrixValid=hmatrixValid(end-Nfft+1:end,:); %take out conv. tail
    yvalid=hmatrixValid*xp; %convolve with the channel
else
    y=hmatrix*xp; %convolve with the channel
    yvalid=y; %prepare to extract only valid samples
    yvalid(end-CP+1:end,:)=[]; %take out CP
    yvalid=yvalid(end-Nfft+1:end,:); %take out convolution tail
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
H=conj(H(:)); %because time was reversed, use complex conjugate
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