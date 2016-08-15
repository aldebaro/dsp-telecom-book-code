%% Example of QAM demodulation using complex-valued signals
%% and the hilbert.m function
%generate QAM signal centered at Fs/4
M=16; %number of symbols
constellat=ak_qamSquareConstellation(M); %QAM const.
S=1000; %number of symbols
ind=floor(M*rand(1,S)); %indices
qamSymbols=constellat(ind+1); %sequence of random symbols
L=8; %oversampling factor
x=zeros(1,S*L); %pre-allocate space
x(1:L:end)=qamSymbols; %complete upsampling operation
p=ak_rcosine(1,L,'fir/normal',0.5,10); %raised cosine r=0.5
yce=conv(p,x); %complex env.: convolution by shaping pulse
%modulate by carrier at pi/2 rad that corresponds to Fs/4
n=0:length(yce)-1; %"time" axis
z=real(yce .* exp(j*pi/2*n)); %transmitted signal
r = z;  %ideal channel: no noise, unlimited band (z was defined)
%run the demodulation using complex signals
ya = hilbert(r); %get analytic signal
ybb = ya .* exp(-j*pi/2*n); %downconversion
ybb(1:floor(length(p)/2))=[]; %take out transient
firstSample = 1; %first sample to start getting symbols
ys=ybb(firstSample:L:L*S); %sample S symbols, baud rate
symbolIndicesRx=ak_qamdemod(ys,M); %QAM demodulation
SER=ak_calculateSymbolErrorRate(symbolIndicesRx,ind)
