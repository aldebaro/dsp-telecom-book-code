%This script creates the whole process of upconverting a signal
%and then downconverting with a carrier that has a frequency and
%phase offsets with respect to the transmitter carrier. This requires
%a relatively large oversampling factor (L). It uses QAM.
clear *; close all %clear all but breakpoints, close all figures
%% 0) Define simulation parameters and also check some choices
fc=1e9; %nominal (transmitter's) carrier frequency in Hz (1 GHz)
freqOffset=-500/1e6*fc; %frequency offset (-500 ppm)
worstFreqOffset=(fc/1e6)*800; %worst accuracy is 800 ppm
desiredResolutionHz=1/1e6*fc; %desired max error/FFT resolution,1 ppm
%force freqOffset to coincide with a FFT bin via Rsym => Fs
Rsym=desiredResolutionHz*1e4; %symbol rate in bauds (10 Mbauds)
rollOff=0.5; %roll-off factor for raised cosine filter
BWqam=(Rsym/2)*(1+rollOff); %QAM signal BW (~7.5 MHz if raised cos.)
fIF = 130e6; %chosen intermediate frequency in Hz
P=4; %power the signal will be raised to: x^P(t)
phaseOffset=-0.5; %phase offset (to be imposed to the signal) in rad
%choose a high enough sampling frequency to represent x^P(t):
maxSignal4Freq = (2*P*fc+P*(fIF+worstFreqOffset+BWqam));
L=ceil(2.2*maxSignal4Freq/Rsym); % oversampling factor
Fs=L*Rsym; %sampling frequency in Hz
M=16; % modulation order (cardinality of the set of symbols)
N=500; % number of symbols to be generated
%fIFmin = worstFreqOffset + 4*BWqam; %minimum intermediate frequency
fIFmin = 4*BWqam+3*worstFreqOffset; %min intermediate frequency
fIFmax = fc/3-worstFreqOffset-(4/3)*BWqam; %max intermediate freq.
if fIF > fIFmax || fIF < fIFmin
    error('fIF is out of suggested range!')
end
if freqOffset > worstFreqOffset %based on accuracy of oscillator
    error('freqOffset > worstFreqOffset')
end
if (phaseOffset<-pi/4) || (phaseOffset >= pi/4)
    error('phaseOffset out of range [-pi/4, pi/4[!')
end
%% 1) Transmitter processing
%QAM generation:
rng('default'); %Reset the random number generator
indicesTx = floor(M*rand(1,N))+1; % random indices from [1, M]
constellation = ak_qamSquareConstellation(M); %QAM symbols
m=constellation(indicesTx); % obtain N random symbols
m_upsampled = zeros(1,N*L); %pre-allocate space with zeros
m_upsampled(1:L:end)=m; % symbols with L -1 zeros in - between
Dsym=3; % group delay, at rate Rsym (input symbols rate)
p=ak_rcosine(1,L,'fir/sqrt',rollOff,Dsym); %square-root raised cosine
%p=ak_rcosine(1,L,'fir/normal',rollOff,Dsym); %normal raised cosine
gdelayRC=(length(p)-1)/2; %group delay of this even order RC filter
sbb=conv(m_upsampled,p);%baseband: convolve symbols and shaping pulse
n=0:length(sbb)-1; %discrete-time index
wc=(2*pi*fc)/Fs; %convert fc from Hz to radians
carrierTx=exp(1j*wc*n); %transmitter carrier (assume phase is 0)
s=real(sbb.*carrierTx); %upconvert to carrier frequency
%% 2) First part of the receiver processing
wOffset=(2*pi*freqOffset)/Fs; %convert freqOffset from Hz to radians
wIF=(2*pi*fIF)/Fs; %convert fIF from Hz to radians
%% 3) Estimate and correct offsets using a real-valued carrier:
realCarrierRx=cos((wc+wIF+wOffset)*n+phaseOffset); %real-valued cos()
r_carrierRecovery=(2*s.*realCarrierRx).^P; %raise to power P
%Will use at least desired resolution:
Nfft = max(ceil(Fs/desiredResolutionHz),length(r_carrierRecovery));
if Nfft > 2^25 %avoid too large FFT size. 2^25 is an arbitrary number
    Nfft = 2^25; %Modify according to your computer's RAM
end
if rem(Nfft,2) == 1 %force Nfft to be an even number
    Nfft=Nfft+1;
end
minFreqOffset=P*(fIF-worstFreqOffset); %range for search using ...
maxFreqOffset=P*(fIF+worstFreqOffset); %the FFT (in Hz)
resolutionHz = Fs/Nfft; %FFT analysis resolution
minIndexOfInterestInFFT = floor(minFreqOffset/resolutionHz);%min ind.
maxIndexOfInterestInFFT = ceil(maxFreqOffset/resolutionHz);%max ind.
R=fft(r_carrierRecovery,Nfft); %calculate FFT of the squared signal
R(1:minIndexOfInterestInFFT-1)=0; %eliminate values at the left (DC)
%strongest peak within the range of interest (start from index 1):
[maxPeak,indexMaxPeak]=max(abs(R(1:maxIndexOfInterestInFFT)));
fftPeakPhase=angle(R(indexMaxPeak)); %extract the phase at FFT peak
if fftPeakPhase > 0 %deal with phase ambiguity assume offset is ...
    estPhaseOffset = (fftPeakPhase-pi)/4; %in range [-pi/4, pi/4[
elseif fftPeakPhase < 0
    estPhaseOffset = (fftPeakPhase+pi)/4;
else
    estPhaseOffset = 0; %avoid discontinuity at zero
end
%R=[]; %maybe useful, to discard R (invite for freeing memory)
estDigitalFreqOffset=(2*pi/Nfft*(indexMaxPeak-1))/P; %frequen. in rad
estDigitalFreqOffset=estDigitalFreqOffset-wIF; %deduct IF
estFrequencyOffset = estDigitalFreqOffset*Fs/(2*pi); %from rad to Hz
%% 4) Demodulate (with complex carrier) and estimate SER
carrierRx=exp(1j*((-wc+wIF+wOffset)*n+phaseOffset)); %with offsets
r=2*s.*carrierRx; %downconvert to approximately baseband
%correct carrier offsets (taking in account the imposed wIF):
carOffSet=exp(-1j*((estDigitalFreqOffset+wIF)*n+estPhaseOffset));
rc=r.*carOffSet; %complex signal with compensated carrier offsets
rf=conv(p,rc); %uses matched filter (note p is symmetric and real)
startSample=2*gdelayRC+1; %take in account the filtering processes
symbolsRx = rf(startSample:L:startSample+L*(N-1)); %extract symbols
gain=sqrt(mean(abs(constellation).^2)/mean(abs(symbolsRx).^2));
symbolsRx = gain*symbolsRx; %normalize average energy of Rx symbols
indicesRx=1+ak_qamdemod(symbolsRx,M); %add one to make 1,...,M
disp(['SER = ' num2str(100*sum(indicesRx~=indicesTx)/N) '%']) %SER
disp(['EVM = ' num2str(ak_evm(m, symbolsRx, 1)) '%'])
%% 5) Evaluate results
%Information about the simulation
disp(['Symbol rate = ' num2str(Rsym/1e6) ' Mbauds'])
disp(['Product of freq. offset by Tsym = ' num2str(freqOffset/Rsym)])
disp(['(this product above varies from 0.001 to 0.2 in papers)'])
disp(['Searched freq. offset in range: [' num2str(minFreqOffset ...
    /1e3) ', ' num2str(maxFreqOffset/1e3) '] kHz']);
disp(['Desired FFT resolution=' num2str(desiredResolutionHz) ' Hz'])
disp(['Used FFT resolution = ' num2str(resolutionHz) ' Hz'])
%Compare with correct values:
phaseError = phaseOffset-estPhaseOffset; %check error in phase
freqError = freqOffset-estFrequencyOffset; %check freq. error
disp(['IF=' num2str(fIF/1e6) '. Allowed range=[' ...
    num2str(fIFmin/1e6) ', ' num2str(fIFmax/1e6) '] (all in MHz)']);
disp(['Imposed phase offset=' num2str(phaseOffset) ' rad'])
disp(['Estimat. phase offset=' num2str(estPhaseOffset) ' rad'])
disp(['Phase error = ' num2str(phaseError) ' rad'])
disp(['Imposed frequency offset = ' num2str(freqOffset/1e3) ' kHz'])
disp(['Estimated frequency offset = ' ...
    num2str(estFrequencyOffset/1e3) ' kHz'])
disp(['Frequency error = ' num2str(freqError) ' Hz'])
disp(['Error in frequency is ' num2str(freqError*1e6/fc) ' ppm ' ...
    'of carrier = ' num2str(fc/1e3) ' kHz'])