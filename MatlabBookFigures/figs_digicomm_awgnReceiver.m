function figs_digicomm_awgnReceiver %use as function to allow subfunction

clear all
close all
randn('state',0); rand('state',0); %reset both generators
numberOfBytes=200;
oversample = 8; %number of samples per symbol
M=4; %modulation order (number of symbols)
N=40; %number of SNR grid
noisePowers=logspace(-2,4,N); %from 10^-4 to 10^4
BERs = zeros(1,N); SERs = zeros(1,N); SNRdBs = zeros(1,N);
for i=1:N
    [BERs(i), SERs(i), SNRdBs(i)]=ak_waveformSimulationOfPAMInAWGN(numberOfBytes, ...
        oversample, M, noisePowers(i));
end
subplot(121)
plot(SNRdBs,BERs,'x',SNRdBs,SERs,'ro');
xlabel('SNR (dB)'); ylabel('error probability');
legend('BER','SER'); grid
subplot(122)
semilogy(SNRdBs,BERs,'x',SNRdBs,SERs,'ro');
xlabel('SNR (dB)'); ylabel('error probability'); grid
writeEPS('serberWaveformSimulationOfPAMInAWGN');
disp('find SNR in which there are no errors:')
SNRdBs(BERs==0 & SERs==0) %could be SNRdBs(BERs==0)

%%Matched filtering
clear all
close all
randn('state',0); rand('state',0); %reset both generators
numberOfBytes=200;
oversample = 8; %number of samples per symbol
M=4; %modulation order (number of symbols)
N=40; %number of SNR grid
noisePowers=logspace(-2,4,N); %from 10^-4 to 10^4
BERs = zeros(1,N); SERs = zeros(1,N); SNRdBs = zeros(1,N);
for i=1:N
    [BERs(i), SERs(i), SNRdBs(i)]=ak_matchedFilterSimulationOfPAMInAWGN(numberOfBytes, ...
        oversample, M, noisePowers(i));
end
subplot(121)
plot(SNRdBs,BERs,'x',SNRdBs,SERs,'ro');
xlabel('SNR (dB)'); ylabel('error probability');
legend('BER','SER'); grid
subplot(122)
semilogy(SNRdBs,BERs,'x',SNRdBs,SERs,'ro');
xlabel('SNR (dB)'); ylabel('error probability'); grid
writeEPS('serberMatchedFilterSimulationOfPAMInAWGN');
disp('find SNR in which there are no errors:')
SNRdBs(BERs==0 & SERs==0) %could be SNRdBs(BERs==0)


%%Compare matched filtering and single-sample reception
%Use: oversample = 8; %number of samples per symbol
clear all
close all
randn('state',0); rand('state',0); %reset both generators
numberOfBytes=200;
oversample = 8; %number of samples per symbol
M=4; %modulation order (number of symbols)
N=40; %number of SNR grid
noisePowers=logspace(-2,2,N); %from 10^-2 to 10^2
BERs = zeros(1,N); SERs = zeros(1,N); SNRdBs = zeros(1,N);
mfBERs = zeros(1,N); mfSERs = zeros(1,N); mfSNRdBs = zeros(1,N);
for i=1:N
    [BERs(i), SERs(i), SNRdBs(i)]=ak_waveformSimulationOfPAMInAWGN(numberOfBytes, ...
        oversample, M, noisePowers(i));
    [mfBERs(i), mfSERs(i), mfSNRdBs(i)]=ak_matchedFilterSimulationOfPAMInAWGN(numberOfBytes, ...
        oversample, M, noisePowers(i));
end
plot(mfSNRdBs,mfBERs,'x',SNRdBs,BERs,'ro');
xlabel('SNR (dB)'); ylabel('BER');
legend('Matched-filter','Single-sample'); grid
writeEPS('berMFWaveformComparisonOfPAMInAWGN_L8');

%another comparison, now with oversample = 20
oversample = 20; %number of samples per symbol
M=4; %modulation order (number of symbols)
N=40; %number of SNR grid
noisePowers=logspace(-2,2,N); %from 10^-2 to 10^2
BERs = zeros(1,N); SERs = zeros(1,N); SNRdBs = zeros(1,N);
mfBERs = zeros(1,N); mfSERs = zeros(1,N); mfSNRdBs = zeros(1,N);
for i=1:N
    [BERs(i), SERs(i), SNRdBs(i)]=ak_waveformSimulationOfPAMInAWGN(numberOfBytes, ...
        oversample, M, noisePowers(i));
    [mfBERs(i), mfSERs(i), mfSNRdBs(i)]=ak_matchedFilterSimulationOfPAMInAWGN(numberOfBytes, ...
        oversample, M, noisePowers(i));
end
plot(mfSNRdBs,mfBERs,'x',SNRdBs,BERs,'ro');
xlabel('SNR (dB)'); ylabel('BER');
legend('Matched-filter','Single-sample'); grid
writeEPS('berMFWaveformComparisonOfPAMInAWGN_L20');


%%show conditional PDFs
randn('state',0); rand('state',0); %reset both generators
numberOfBytes=100;
noisePower=0.5;
[organizedSymbols,numOfExamplesPerSymbol,...
    errorsPerSymbol,confusionMatrix,ber,ser,snr]=...
    ak_getErrorPDFsOfPAMWaveformSimulationInAWGN(numberOfBytes, oversample, M, noisePower)
clf;
marks=['xo+.'];
colors=['bgrk'];
subplot(211); hold on;
for i=1:M
    n=1:numOfExamplesPerSymbol(i);
    plot(n,organizedSymbols(i,n),[marks(i) '-' colors(i)]);
end
xlabel('n-th symbol'); ylabel('r[n]');
axis([1 max(numOfExamplesPerSymbol) -5 5])

subplot(212); hold on;
for i=1:M
    n=1:numOfExamplesPerSymbol(i);
    [occ,bins]=hist(organizedSymbols(i,n),20);
    plot1=plot(bins,occ,[marks(i) '-' colors(i)]);
    %makedatatip(plot1,1);  %too large
end
xlabel('r[n]'); ylabel('occurrences');
legend('-3','-1','1','3')
grid
set(gca,'xtick',[-2 0 2]);
writeEPS('awgnReceivedSymbolsHistogram');
%plot(organizedSymbols')
%hist(organizedSymbols',100)

%%show Gaussians
clf
N=1000;
x=linspace(-12,12,N);
subplot(211)
plot(x,octave_normpdf(x,0,sqrt(0.5)))
xlabel('noise N'); ylabel('f_N(N)')
axis([-6 6 0 0.6])
set(gca,'xtick',[-6:2:0, 1, 2:2:6])
grid
subplot(212)
plot(x-3,octave_normpdf(x-3,-3,sqrt(0.5)))
xlabel('received symbol R'); ylabel('f_R(R)')
axis([-6 6 0 0.6])
%set(gca,'xtick',[-6:2:0, 1, 2:2:6])
grid
writeEPS('noiseReceivedGaussians');

clear all
close all
randn('state',0); rand('state',0); %reset both generators
noisePower=0.0; plotMFWaveform(noisePower,0)
writeEPS('mfWaveformsNoNoise','font12Only')
%I am not using the plot below anymore (it is too redundant)
%noisePower=6; plotMFWaveform(noisePower,0)
%writeEPS('mfWaveformsNoisy','font12Only')

randn('state',0); rand('state',0); %reset both generators
noisePower=0.0; plotMFWaveform(noisePower,1)
writeEPS('mfWaveformsNoNoiseWithReceivedSignal','font12Only')
noisePower=6; plotMFWaveform(noisePower,1)
writeEPS('mfWaveformsNoisyWithReceivedSignal','font12Only')


%% Show example matched filter
clf
N=1000;
p1=linspace(3,2,N);
p2=ones(1,N);
p=[0 p2 p1 2*p2 zeros(1,5*N)];
t=(0:length(p)-1)/1000;
subplot(121), plot(t,p)
xlabel('t (s)')
ylabel('p(t)')
axis tight
%for Tsym=5;
pmatched=[zeros(1,2*N) fliplr([0 p2 p1 2*p2]) zeros(1,3*N)];
subplot(122), plot(t,pmatched)
xlabel('t (s)')
ylabel('p^*(5-t)')
axis tight
%To resize and make a figura shorter:
x=get(gcf, 'Position'); %get figure's position on screen
x(4)=floor(x(4)*0.6); %adjust the size making it "taller"
set(gcf, 'Position',x);
writeEPS('matchedFilterExample')

end


function plotMFWaveform(noisePower,shouldPlotReceivedSignal)
%show details of the MF operation
randn('state',0); rand('state',0); %reset both generators
numberOfSymbols=10; %number of symbols to be transmitted
M = 4; %modulation order (number of symbols)
%noisePower=0.5; %noise power
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
r = s + n; %add noise
rfiltered = filter(h_mf,1,r); %matched filtering operation
rfiltered = rfiltered/Ep; %normalize (symbols are multiplied by p[n] twice)
initialSample = oversampling; %get convolution output after a symbol period
receivedSymbols=rfiltered(oversampling:oversampling:end); %sample MF output
symbolIndicesRx = pamdemod(receivedSymbols, M); %demodulate noisy symbols
SER=sum(symbolIndicesTx ~= symbolIndicesRx)/numberOfSymbols %Pe
clf; stem(rfiltered); hold; 
plot(s,'rx')
if shouldPlotReceivedSignal==1
    stem(r,'g+') %plot received signal
end
sampleInstants=[initialSample:oversampling:length(rfiltered)]; %indicate sampling instants
stem(sampleInstants,rfiltered(sampleInstants),'kd','markersize',14)
xlabel('n'); ylabel('amplitudes');
if shouldPlotReceivedSignal==1
    legend('MF output','Tx signal','Rx signal','MF sampling'); 
else
    legend('MF output','Tx signal','MF sampling'); 
end
grid
%stem(n,'g')
SNRdB=10*log10(mean(s.^2)/mean(n.^2));
disp(['SNR at the input of the matched filter: ' num2str(SNRdB) ' dB'])
hold off
end