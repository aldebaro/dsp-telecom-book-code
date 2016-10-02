%set global constants
global Fs M S b L const showPlots htx hrx hhilbert ...
    wc useQAM delayInSamples shouldWriteEPS useIdealChannel ...
    phaseCorrection

%% General parameters
showPlots=0; %use 1 to show plots
shouldWriteEPS=1; %write output EPS files (with print -depsc)
Fs=44100; %sampling frequency in Hz
S=1000; %number of symbols
L=80; %oversampling factor

%% Channel parameters
useIdealChannel = 0; %set 1 if want ideal channel

%% Transmitter and receiver parameters
wc=pi/2; %carrier frequency: 0.5 pi rad (or Fs/4 Hz)
M=32; %number of symbols in alphabet
useQAM=1; %use QAM or PAM
if useQAM==1
    const=ak_qamSquareConstellation(M); %QAM const.
else %PAM
    const=-(M-1):2:M-1;
end
b=log2(M); %num of bits per symbol
Nbits=b*S; %total number of bits to be transmitted

%phase correction if channel is not ideal (compensates channel
%phase). Obtained by inspection for given channel, not automatically)
phaseCorrection = pi/23; %in rads

%htx=ak_rcosine(1,L,'fir/normal',0.5,10); %raised cosine
%Instead, use pair of square root cosines at Tx and Rx:
htx=ak_rcosine(1,L,'fir/sqrt',1,10); %sqrt raised cosine
hrx=conj(fliplr(htx)); %matched filter

%the number of samples the receiver should skip. Each
%processing block such as filtering should update this
%variable
delayInSamples = 0;

%Design a Hilbert filter (or transformer)
if 0 %you may enable if using Matlab
    N = 22;           % Filter order
    F = [0.05 0.95];  % Frequency Vector
    A = [1 1];        % Amplitude Vector
    W = 1;            % Weight Vector
    hhilbert  = firls(N, F, A, W, 'hilbert');
    save -ascii 'hhilbertFilter.txt' hhilbert
else %load filter previously designed
    %Octave's firls does not support 'hilbert' option and:
    %hhilbert  = firls(N, F, A, W); %does not design a proper Hilbert
    %Later, we will properly design a Hilbert on Octave, but for now:
    hhilbert = load('hhilbertFilter.txt'); %load filter
end

%% Initialization procedures
rand('twister',0); %reset uniform random number generator
randn('state',0); %reset Gaussian random number generator
