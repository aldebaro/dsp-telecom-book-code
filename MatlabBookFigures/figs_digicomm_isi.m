function figs_digicomm_isi

clf
h=fir1(10,0.8);
epsName = 'compensatingFIRChannel';
exampleOfISI(h, 1, epsName)

[B,A]=butter(5,0.8);
epsName = 'compensatingButterworthChannel';
exampleOfISI(B, A, epsName)

exampleOfISIForSimpleFilter;

matchedFilterWithISI

h=[0.3 -0.4 0.5 0.8 0.5 -0.4 0.3];
epsName='groupDelayLinearPhase';
ak_plotGroupDelay(h,1)
writeEPS(epsName)

h=[0.3 -0.4 0.5 0.8 -0.2 0.1 0.5];
epsName='groupDelayNonLinearPhase';
ak_plotGroupDelay(h,1)
writeEPS(epsName)

end

function matchedFilterWithISI
close all, clear all
%show details of the MF operation
randn('state',0); rand('state',0); %reset both generators
numberOfSymbols=10; %number of symbols to be transmitted
M = 4; %modulation order (number of symbols)
noisePower=0; %noise power
oversampling=8; %oversampling factor
p = ones(1,oversampling); %shaping pulse
Ep = sum(p.^2); %pulse energy, needed for normalizing at Rx
h_mf = fliplr(p); %matched filter (MF) impulse response
constellation=[-3 -1 1 3]; %4-PAM constellation with energy 5
symbolIndicesTx = floor(4*rand(1,numberOfSymbols)); %random indices
transmittedSymbols=constellation(symbolIndicesTx+1); %symbols
s = zeros(1,oversampling*numberOfSymbols); %pre-allocate space
s(1:oversampling:end) = transmittedSymbols; %get upsampled s
s = filter(p,1,s); %PAM signal
n = sqrt(noisePower)*randn(size(s)); %Gaussian noise
%channel with ISI
befor=sum(s.^2)
h=[2 -1];
%[B,A]=butter(3,0.1);
Eh = sum(h.^2);
r = filter(h,1,s);
after=sum(r.^2)
r = r + n; %add noise
rfiltered = filter(h_mf,1,r); %matched filtering operation
rfiltered = rfiltered/Ep/sum(h); %normalize (symbols are multiplied by p[n] twice)
initialSample = oversampling; %get convolution output after a symbol period
receivedSymbols=rfiltered(oversampling:oversampling:end); %sample MF output
symbolIndicesRx = pamdemod(receivedSymbols, M); %demodulate noisy symbols
SER=sum(symbolIndicesTx ~= symbolIndicesRx)/numberOfSymbols %Pe
clf; stem(rfiltered); hold; stem(s,'rx')
sampleInstants=[initialSample:oversampling:length(rfiltered)];
stem(sampleInstants,rfiltered(sampleInstants),'k+','markersize',14)
xlabel('n'); ylabel('amplitudes');
legend('MF output','Tx signal','MF sampling'); grid
%stem(n,'g')
SNRdB=10*log10(mean(s.^2)/mean(n.^2));
disp(['SNR at the input of the matched filter: ' num2str(SNRdB) ' dB'])
hold off

end

%Example of ISI
function exampleOfISIForSimpleFilter
h=[1 -0.5]; %example of a dispersive channel
epsName = 'exampleOfISI';
symbols = [1 -1 1 1 -1 -1]; %binary symbols
L = 4; %oversampling
N = L * length(symbols); %number of samples
x=zeros(N,1); %allocate space
x(1:L:end) = symbols; %create upsampled signal
p=ones(1,L); %shaping pulse
x=filter(p,1,x); %convolve p and x
y=filter(h,1,x); %pass x through the channel
myAxis = [0 N -1.5 1.5];
subplot(311), stem(0:N-1,x), axis(myAxis), ylabel('x[n]')
subplot(312), stem(0:N,0.5*[0; x]), axis(myAxis),  ylabel('0.5 x[n-1]')
subplot(313), stem(0:N-1,y), axis(myAxis),  ylabel('y[n]')
xlabel('n');
writeEPS(epsName);
end

function exampleOfISI(B, A, epsName)
symbols = [1 -1 1 1 -1 -1]; %binary symbols
L = 4; %oversampling
N = L * length(symbols); %number of samples
x=zeros(N,1); %allocate space
x(1:L:end) = symbols; %create upsampled signal
p=ones(1,L); %shaping pulse
x=filter(p,1,x); %convolve p and x

Px=mean(x.^2)

y = filter(B,A,x); %pass x through the channel
Py=mean(y.^2)
%mimic perfect automatic gain control (AGC) and scale output
factor = sqrt(Px/Py);
y = factor*y;
Py=mean(y.^2)

myAxis = [0 N -1.5 1.5];
subplot(411), stem(0:N-1,x), axis(myAxis), ylabel('x[n]')
subplot(412), stem(0:N-1,y), axis(myAxis),  ylabel('y[n]')
subplot(413), impz(B,A), ylabel('h[n]'), title([])
subplot(414), grpdelay(B,A)
writeEPS(epsName);
end