%Obtains the frame-by-frame spectral distortion (SD) between
%two speech waveforms
target_filePointer=fopen('speech_ara11_eight_target.raw','rb');
synthetic_filePointer=fopen('speech_ara11_eight_synthetic.raw','rb');
Fs=11025; %sampling frequency (Hz)
target=fread(target_filePointer,Inf,'int16'); %target/original speech
synthetic=fread(synthetic_filePointer,Inf,'int16'); %synthetic speech
fclose(target_filePointer);
fclose(synthetic_filePointer);
if 0
    plot(x), hold on, plot(y, 'r')
    soundsc(x,Fs); pause
    soundsc(y,Fs);
end
Nfft=2048; %number of FFT points (must be the same for both SD)
L=200; %window length, i.e., number of samples per window (frame)
S=71; %window shift (in samples)
M=ceil((length(target)-L)/S); %number of frames discarding last one
sd_all=NaN*ones(M,1); %initialize with NaN
sdAR_all=NaN*ones(M,1);
sdARp_all=NaN*ones(M,1);
silenceThresholddB=30; %obtained using plots from endpointsDetector.m
isNotSilence=endpointsDetector(target,L,S,silenceThresholddB);
%isNotSilence=ones(size(isNotSilence)); %to disable the detector
disp(['Valid frames = ' num2str(sum(isNotSilence))]);
for i=1:M %do not use last frame, because it may use zero padding
    if isNotSilence(i)==0
        continue; %skip because this is a silence frame
    end
    firstSample = 1+(i-1)*S;
    lastSample = firstSample + L - 1;
    x=target(firstSample:lastSample); %frame from target signal
    y=synthetic(firstSample:lastSample); %frame from the other signal
    sd_all(i)=ak_spectralDistortion(x,y);
    sdAR_all(i)=ak_ARSpectralDistortion(x,y,10,Nfft);
    sdARp_all(i)=ak_ARSpectralDistortion(x,y,10,Nfft,60,1);
    disp(['#' num2str(i) ': SD=' num2str(sd_all(i)) ', AR SD=' ...
        num2str(sdAR_all(i)) ' and AR SD (power)= ' ...
        num2str(sdARp_all(i))]);
end
sd_all=sd_all(isNotSilence); %eliminate silence frames
sdAR_all=sdAR_all(isNotSilence);
sdARp_all=sdARp_all(isNotSilence);
SDmean = mean(sd_all); %get mean values
SDARmean = mean(sdAR_all);
SDARpmean = mean(sdARp_all);
disp(['Averages: SD=' num2str(SDmean) ', AR SD=' num2str(SDARmean)...
    ' and AR SD with power=' num2str(SDARpmean)]);
%Transparent quantization: mean <= 1 dB, no SD>4 dB and <=2% in [2,4]
sdLargerThan4dB = 100*sum(sdAR_all>4)/M  %SD > 4 in %
sdBetween2And4 = 100*(sum((sdAR_all>=2)&(sdAR_all<=4)))/M %in [2,4]
clf, plot(sd_all), hold on, plot(sdAR_all, 'r') %plot averages
plot(sdARp_all,'k'), legend('SD', 'AR SD', 'AR SD with power');
xlabel('frame number'); ylabel('dB')