%% Example of QAM demodulation using complex-valued signals and
%% lowpass filter.
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
r = z;  %ideal channel: no noise (z already defined). Run QAM demod.:
n=0:length(r)-1; %integer indices that represent time evolution
wc=pi/2; %carrier frequency in radians
carrier=2*exp(-1j*wc*n); %generate complex carrier. Note factor = 2
rbb=r.*carrier; %shift one QAM replica to the baseband
b=fir1(length(p)-1,0.5); %FIR with same order of the shaping filter
ybb=conv(b,rbb); %filter out replica at twice the carrier frequency
ybb(1:floor(length(p)/2)+floor(length(b)/2))=[];%discard group delays
ys=ybb(1:L:L*S); %sample S symbols, at baud rate
symbolIndicesRx=ak_qamdemod(ys,M); %QAM demodulation
SER=ak_calculateSymbolErrorRate(symbolIndicesRx,ind)