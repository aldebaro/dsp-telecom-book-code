%% Before this one, use ak_resampleFiles.m to pre-process your files!
N=4; %number of AM signals (or AM radio stations)
%The input files are named amFile1.wav, amFile2.wav, ..., amFileN.wav
myPath='.'; %directory where the files can be found, e.g. 'c:/mydir'
%The first file determines the adopted sampling frequency Fs and
%the output signal duration
fileName=[myPath '/amFile1.wav']; %name of first file
[x,Fs]=wavread(fileName); %Fs is the sampling frequency (Hz)
%soundsc(x,Fs); disp('Press a key'); pause
M=length(x); %number of samples assumed for the output signal
U=16; %upsampling factor (must be an integer) to increase Fs
for i=2:N
    fileName=[myPath '/amFile' num2str(i) '.wav'];
    [x,Fs_temp]=wavread(fileName);
    if Fs_temp ~= Fs
        error([fileName ' sampling freq. differs from amFile1.wav'])
    end
    if length(x) < M
        M=length(x); %update M to be the shortest duration
    end
    %soundsc(x,Fs); disp('Press a key'); pause %enable to listen file
end
Fs_tx=U*Fs; %sampling freq. of transmit (multiplexed output) signal
%This determines the bandwidth as Fs_tx/2, such that the
%digital signal captures the range ]-Fs_tx/2, Fs_tx/2[
Fc_if=600e3; %intermediate frequency (IF) adopted by receiver (Hz)
%It is assumed that the signal at RF frequency is multiplied by
%a sinusoid with intermediate frequency (IF) and the output signal
%is at frequency fmax=RF-IF. Taking in account the negative
%frequencies, the range [-fmax, fmax] must fit in ]-Fs_tx/2, Fs_tx/2[
%or, equivalently, by sampling theorem, Fs_tx must be Fs_tx > 2 fmax
BWam = 5000; %each AM has BW=5 kHz and their freq. spacing is 10 kHz
freqRF=[610 620 630 650]*1000; %RF of each station
fmax=freqRF(end)-Fc_if+BWam;
if fmax > Fs_tx/2
    disp(['Maximum frequency = ' num2str(fmax)])
    disp(['Suggested upsampling factor D=' num2str(ceil(2*fmax/Fs))])
    error('Sampling theorem not obeyed. Increase upsampling factor!')
end
y=zeros(M*U,1); %pre-allocate space for output signal
n=transpose(0:M*U-1);
modulationIndex=0.5; %number within range ]0, 1[
for i=1:N
    fileName=[myPath '/amFile' num2str(i) '.wav'];
    disp(['Processing ' fileName])
    [x,Fs_temp]=wavread(fileName);
    x=x(1:M); %force all signals to have the same duration (length)
    xup=resample(x,U,1);
    Fc=freqRF(i)-Fc_if;
    phase=2*pi*rand; %some arbitrary phase between 0 and 2*pi rad
    xMax=max(abs(xup));
    A=xMax/modulationIndex; %carrier amplitude
    carrier=cos(2*pi*Fc/Fs_tx*n+phase);
    y=y+((A+xup).*carrier); %add to multiplexed output signal    
    %plot(xrf,'r'); hold on; plot(xup);
end
maxAbs=max(abs(y))+eps; %wavwrite restricts to [-1,1[.
wavwrite(y/maxAbs,Fs_tx,16,'amMultiplexedSignals.wav');
