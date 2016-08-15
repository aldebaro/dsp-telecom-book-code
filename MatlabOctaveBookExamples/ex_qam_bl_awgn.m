%Generate a QAM and recover its two components
clear all, close all
awgn = 0; %add AWGN noise if 1
useSqrtRaisedCosine = 0; %use a normal or sqrt rcosine
rand('twister',0); %allow reproducing results
M=16; %number of symbols
c=ak_qamSquareConstellation(M); %QAM const.
S=1000; %number of symbols
ind=floor(4*rand(1,S))+1; %number of indices
sym=c(ind); %sequence of random symbols
L=8; %oversampling factor
x=zeros(1,S*L); %pre-allocate space
x(1:L:end)=sym; %complete the upsampling operation
if useSqrtRaisedCosine==1
    p=ak_rcosine(1,L,'fir/sqrt',0.5,10); %square root rcosine
else
    p=ak_rcosine(1,L,'fir/normal',0.5,10); %raised cosine
end
y=conv(p,x); %convolution by shaping pulse
%check if there is zero ISI at this point
 zz=y(1:L:end);
 plot(real(zz),imag(zz),'x','markersize',20); pause
%modulate by carrier at pi/2 rad that corresponds to Fs/4
n=0:length(y)-1;
z=real(y .* exp(j*pi/2*n)); %transmitted signal
if awgn == 1 %impose AWGN
    SNRdB = 10; %desired signal to noise ratio in dB
    SNR=10^(0.1*SNRdB); %SNR in linear scale
    noisePower = mean(abs(z).^2)/SNR; %noise power
    %generate complex noise, note that it is noisePower/2
    complexNoise = sqrt(noisePower/2)*(randn(size(z))+...
        j*randn(size(z)));
    r = z + complexNoise; %add noise
    %estimate SNR
    SNRactual=10*log10(mean(abs(z).^2)/mean(abs(complexNoise).^2))
else
    r = z;  %no noise
end
%now run the demodulation:
ri = r .* (2*cos(pi/2*n)); %in-phase component
rq = -r .* (2*sin(pi/2*n)); %quadrature component
if useSqrtRaisedCosine==1
    %using the shaping filter as the receiver filter
    %in this case, p should be a square-root raised cosine
    b=conj(fliplr(p));
else
    %make a FIR with the same order of the shaping filter
    %and use a cutoff frequency of pi/2 rad
    b=fir1(length(p)-1,0.5);
    %b=conj(fliplr(p)); %should not be used here
end
ri = conv(b,ri); %filter the two components to eliminate
rq = conv(b,rq); %the terms at twice the carrier frequency
ybb=ri + j * rq; %recompose the complex envelope at baseband
%take out the transient due to the filters:
ybb(1:floor(length(p)/2)+floor(length(b)/2))=[];
firstSample = 1; %first sample to start getting the symbols
%ys=ybb(firstSample:L:end); %sample at the symbol rate
ys=ybb(firstSample:L:L*S); %sample S symbols, baud rate

subplot(211)
plot(real(ys),imag(ys),'x'); %transmitted constellation
hold on
plot(real(sym),imag(sym),'or'); %received constellation
%if there is a symbol at (0,0) it is due to the filter's transients
axis equal %make the constellation on a square
title('Constellations');
subplot(212)
ys=ys(1:length(sym)); %make ys of the same size of sym
plot(abs(sym(5:end)-ys(5:end)).^2) %compare the signals
title('Power of the error signal due to filtering')