function [newb,f,newt]=ak_specgramOriginalSyntax(x,nfft,...
    samplingFrequency,HanningWindowLength,noverlap,thresholdIndB,...
    preemphasisCoefficient, verbosity)
%function [newb,f,newt]=ak_specgramOriginalSyntax(x,nfft,...
%    samplingFrequency,HanningWindowLength,noverlap,thresholdIndB,...
%    preemphasisCoefficient, verbosity)
%suggested threshold=120; maximum - threshold is floor value.
%If x is complex-valued, use frequency range from -Fs/2 to Fs/2-df
%instead of 0 to Fs-df as in Matlab's.
%Example:
% x=randn(1,1000); %white noise
%or
% x=exp(-1j*pi/4*(0:9999)); %complex tone at -2000 Hz
% [b,f,t]=ak_specgramOriginalSyntax(x,512,16000,30,10,120,0,1);
% imagesc(t,f,b);axis xy; colormap(jet)
% xlabel('seconds'); ylabel('Hz');
%
%Aldebaro Klautau - Dec. 2017

if nargin == 1
    disp('Assuming default values.');
    HanningWindowLength=round(max(100,length(x)/5000));
    nfft=2^nextpow2(HanningWindowLength);
    samplingFrequency=2;
    noverlap=max([1 length(HanningWindowLength)/2]);
    thresholdIndB=120;
end
if nargin < 6
    preemphasisCoefficient = 0; %0.9 is good for speech signals
end
if nargin < 7
    verbosity=1; %be verbose by default and print information
end

%use preemphasisCoefficient=0 in case do not want this boosting in
%higher frequencies
y=filter([1 -preemphasisCoefficient],1,x);

if verbosity > 0    
    disp(['samplingFrequency=' num2str(samplingFrequency)]);
    disp(['thresholdIndB=' num2str(thresholdIndB)]);
    disp(['preemphasisCoefficient=' num2str(preemphasisCoefficient)]);
    disp(['fft size=' num2str(nfft)]);
    disp(['FFT frequency resolution (Hz)=' num2str(samplingFrequency/...
        nfft)]);
    disp(['HanningWindowLength=' num2str(HanningWindowLength)]);
    disp(['1/(window duration) (Hz), related to freq. resolution=' ...
        num2str(samplingFrequency/HanningWindowLength)]);
    disp(['Window length in ms=' ...
        num2str(1e3*HanningWindowLength/samplingFrequency)]);
    disp(['Num. samples that overlap=' num2str(noverlap)]);
    windowShift = HanningWindowLength-noverlap;
    disp(['windowShiftInms=' num2str(1e3*windowShift/samplingFrequency)]);
    disp(['Window shift in samples =' num2str(windowShift)]);    
    estimatedNumFrames=floor((length(y)-HanningWindowLength) / ...
    windowShift)+1;
    estimatedRAMMemoryInMBytes=estimatedNumFrames*nfft*8/(1024)^2;
    disp(['Estimating, this spectrogram is a ' num2str(nfft) ' x ' ...
        num2str(estimatedNumFrames) ' matrix']);    
    disp(['and consumes ' num2str(estimatedRAMMemoryInMBytes) ' MBytes']);
end

if estimatedRAMMemoryInMBytes >  60
    error(['estimatedRAMMemoryInMBytes = ' ... 
        num2str(estimatedRAMMemoryInMBytes) ...
        ' while maximum is 60 MB. Change parameters!'])
end

[b,f,t]=specgram(y,nfft,samplingFrequency,HanningWindowLength,noverlap);
if ~isreal(x) %it is complex, use frequency from -Fs/2 to Fs/2-df
    df=samplingFrequency/nfft; %or df=f(2)-f(1)
    f=-samplingFrequency/2:df:samplingFrequency/2-df;
    b=fftshift(b);
end

if verbosity > 0
    disp(['Total number of windows=' num2str(length(t))]);
    disp(['This spectrogram is a ' num2str(nfft) ' x ' ...
        num2str(length(t)) ' matrix']);
end

b=20*log10(abs(b));
maximum = max(b(:));
minimum = maximum - thresholdIndB;
%Matlab takes care of -Inf also
b(b<minimum)=minimum;
%imagesc(b');

%find a slightly different time axis. the new axis adds the amount
%(HanningWindowLength/2)/samplingFrequency
%to the t vector found by specgram. This is just for better
%positioning.
nshift = HanningWindowLength - noverlap;
t0 = HanningWindowLength / 2;
t1 = t0 + (length(t) - 1) * nshift;
newt = linspace(t0/samplingFrequency,t1/samplingFrequency,length(t));
%make it a column vector to have the same dimension of t:
newt = transpose(newt);

if (nargout == 0)
    imagesc(newt,f,b);axis xy; colormap(jet)
    xlabel('seconds'); ylabel('Hz');
else
    %if nargout is 0, avoid having newb printed out because it is
    %undefined but in this case newb has to be passed to the caller
    newb = b;
end
