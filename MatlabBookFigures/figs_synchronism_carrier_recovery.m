function figs_synchronism_carrier_recovery()
% Repeatedly invokes part of script ex_fftBasedQAMCarrierRecovery.m
% to plot a figure.
N=6; %number of points to be calculated minus 3
zz=linspace(-pi/4,pi/4-(1e-2),N); %range [-pi/4, pi/4[
zz=sort([zz -1e-2 1e-2 0]); %add points close to singularity at zero
N=N+3; %update N
estimatorOutput=zeros(1,N);
offsets=zeros(1,N);
for i=1:N
    phaseOffset=zz(i);
    fftPeakPhase=runPartOf_ex_fftBasedQAMCarrierRecovery(phaseOffset);
    if fftPeakPhase > 0
        estimatedPhaseOffset = (fftPeakPhase-pi)/4;
    elseif fftPeakPhase < 0
        estimatedPhaseOffset = (fftPeakPhase+pi)/4;
    else
        estimatedPhaseOffset = 0;
    end
    estimatorOutput(i)=fftPeakPhase;
    offsets(i)=estimatedPhaseOffset;
end
subplot(211)
plot(zz/pi,estimatorOutput/pi);
ylabel('fftPeakPhase')
axis tight
subplot(212)
plot(zz/pi,(zz-offsets)/pi);
ylabel('Estimation error')
xlabel('phaseOffset / pi');
axis tight
writeEPS('fftBasedQAMCarrierRecovery','font12Only');

%least squares:
%est=unwrap(out);
%coeffs = polyfit(zz, est, 1);
end

function fftPeakPhase=runPartOf_ex_fftBasedQAMCarrierRecovery(phaseOffset)
%This script creates the whole process of upconverting a signal
%and then downconverting with a carrier that has a frequency and
%phase offsets with respect to the transmitter carrier. This requires
%a relatively large oversampling factor (L). It uses QAM.
%clear *; close all %clear all but breakpoints, close all figures
%% 0) Define simulation parameters and also check some choices
fc=1e9; %nominal (transmitter's) carrier frequency in Hz (1 GHz)
freqOffset=50/1e6*fc; %frequency offset (-500 ppm)
worstFreqOffset=(fc/1e6)*800; %worst accuracy is 800 ppm
desiredResolutionHz=1/1e6*fc; %desired max error/FFT resolution,1 ppm
%force freqOffset to coincide with a FFT bin via Rsym => Fs
Rsym=desiredResolutionHz*1e4; %symbol rate in bauds (100 Mbauds)
rollOff=0.5; %roll-off factor for raised cosine filter
BWqam=(Rsym/2)*(1+rollOff); %QAM signal BW (~7.5 MHz if raised cos.)
fIF = 130e6; %chosen intermediate frequency in Hz
P=4; %power the signal will be raised to: x^P(t)
%phaseOffset=1.4; %phase offset (to be imposed to the signal) in rad
%choose a high enough sampling frequency to represent x^P(t):
maxSignal4Freq = (2*P*fc+P*(fIF+worstFreqOffset+BWqam));
L=ceil(2.2*maxSignal4Freq/Rsym); % oversampling factor
Fs=L*Rsym; %sampling frequency in Hz
M=4; % modulation order (cardinality of the set of symbols)
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
%gdelayRC=(length(p)-1)/2; %group delay of this even order RC filter
sbb=conv(m_upsampled,p);%baseband: convolve symbols and shaping pulse
n=0:length(sbb)-1; %discrete-time index
wc=(2*pi*fc)/Fs; %convert fc from Hz to radians
carrierTx=exp(1j*wc*n); %transmitter carrier (assume phase is 0)
s=real(sbb.*carrierTx); %upconvert to carrier frequency
%% 2) First part of the receiver processing
wOffset=(2*pi*freqOffset)/Fs; %convert freqOffset from Hz to radians
wIF=(2*pi*fIF)/Fs; %convert fIF from Hz to radians
carrierRx=cos((wc+wIF+wOffset)*n+phaseOffset);%Rx carrier w/ offsets
r=2*s.*carrierRx; %downconvert to approximately baseband
%% 3) Estimate and correct offsets:
r_carrierRecovery = r.^P; %raise to power P
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
fftPeakPhase=angle(R(indexMaxPeak));
end