%%%%%%%%%%%%%%%%%%%%%%%
%Autocorrelation of cosine
%%%%%%%%%%%%%%%%%%%%%%%
close all; clear all
numSamples = 48; %number of samples
n=0:numSamples-1; %indices
N = 8; %sinusoid period
x=4*sin(2*pi/N*n); %sinusoid (try varying the phase!)
[R,l]=xcorr(x,'unbiased'); %calculate autocorrelation
subplot(211); stem(n,x); xlabel('n'); ylabel('x[n]');
subplot(212); stem(l,R); xlabel('Lag l'); ylabel('Autocorrelation R_x[l]');
writeEPS('cosineAutocorrelation','font12Only');

%Illustrate finite duration effects
clf
numSamples = 48; %number of samples
n=0:numSamples-1; %indices
N = 15; %sinusoid period
x=4*sin(2*pi/N*n); %sinusoid (try varying the phase!)
[R1,l]=xcorr(x,'unbiased'); %calculate autocorrelation
[R2,l]=xcorr(x,'none'); %calculate autocorrelation
subplot(211); stem(l,R1); ylabel('Unbiased R_x[l]');
subplot(212); stem(l,R2); xlabel('Lag l'); ylabel('Raw R_x[l]');
writeEPS('autocorrelationFiniteDurationEffects','font12Only');

%Noise plus sinusoid
A=4; %sinusoid amplitude
noisePower=25; %noise power
f=2; %frequency in Hz
n=0:3999; %"time", using many samples to get good estimate
Fs=20; %sampling frequency in Hz
x=A*sin(2*pi*f/Fs*n); %generate discrete-time sine
randn('state', 0); %Set randn to its default initial state
noise=sqrt(noisePower)*randn(size(x)); %generate noise
clf, subplot(211), plot(x+noise) %plot noise
maxSample=100; %determine the zoom range
subplot(212),stem(x(1:maxSample)+noise(1:maxSample)) %zoom
writeEPS('noisePlusSine','font12Only');
maxLags = 20; %maximum lag for xcorr calculation
[Rx,lags]=xcorr(x,maxLags,'unbiased'); %signal only
[Rz,lags]=xcorr(noise,maxLags,'unbiased'); %noise only
[Ry,lags]=xcorr(x+noise,maxLags,'unbiased');%noisy signal
subplot(311), stem(lags,Rx); ylabel('R_x[l]');
subplot(312),stem(lags,Rz);ylabel('R_z[l]'); subplot(313)
stem(lags,Ry);xlabel('Lag l');ylabel('R_y[l]');
%[R,lags]=xcorr(x,'unbiased');
temp = find(lags==0)
Rx(temp)
Rz(temp)
Ry(temp)
writeEPS('xcorrNoisePlusSine','font12Only');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%sunspot figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clf
load sunspot.dat; %the data file
year=sunspot(:,1); %first column
wolfer=sunspot(:,2); %second column
%plot(year,wolfer); title('Sunspot Data') %plot raw data
x=wolfer-mean(wolfer); %remove mean
[R,lag]=xcorr(x); %calculate unnormalized autocorrelation
plot(lag,R); hold on; %find 2nd peak:
indexForLag0 = find(lag==0)% or indexForRmax = find(R==max(R))
maxR = R(indexForLag0); %known property of R(tau)
previousR = maxR; %initialize previousR
for i=indexForLag0+1:length(R) %find when R stops decreasing
    if R(i) > previousR
        break;
    end
    previousR = R(i); %update for next iteration
end
endOfFirstPeak = i;
maxWithoutFirstPeak = max(R(endOfFirstPeak:end))
candidates2ndPeak = find(R==maxWithoutFirstPeak)
if length(candidates2ndPeak) ~= 2
    warning('Due to numerical errors, R(tau) \ne R(-tau)')
end
if length(candidates2ndPeak)==2
    index=candidates2ndPeak(2); %first element is for negative lag
else
    index=candidates2ndPeak; %there is only 1 maximum. Assume it's lag=11
end
plot(lag(index),R(index),'r.', 'MarkerSize',25);
text(lag(index)+10,R(index),['2nd peak at lag=11']);
xlabel('lag (year)'); ylabel('Autocorrelation')
axis([-100 100 -2e5 5e5])
grid
writeEPS('sunspotautocorrelation');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%F0 estimation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clf
Fs=44100; %sampling frequency
Ts=1/Fs; %sampling interval
minF0Frequency=80; %minimum F0 frequency in Hz
maxF0Frequency=300; %minimum F0 frequency in Hz
minF0Period = 1/minF0Frequency; %correponding F0 (sec)
maxF0Period = 1/maxF0Frequency; %correponding F0 (sec)
Nbegin=round(maxF0Period/Ts); %number of lags for maximum freq.
Nend=round(minF0Period/Ts); %number of lags for minimum freq.
if 0 %record sound or test with 300 Hz cosine
    r = audiorecorder(Fs, 16, 1);%create an object audiorecorder
    disp('Started recording. Say a vowel: a, e, i, o or u')
    recordblocking(r,2);%record 2 seconds and store in object r
    disp('finished recording');
    y = double(getaudiodata(r, 'int16')); %get recorded signal
else
    N=floor(8*(1/300)/Ts); %~ 8 periods of 300 Hz
    y = cos(2*pi*300*[0:N-1]*Ts); %cosine, for testing
end
subplot(211); plot(Ts*[0:length(y)-1],y);
xlabel('time (s)'); ylabel('Signal y(t)')
[R,lags]=xcorr(y,Nend,'biased'); %calculate ACF with maximum lag Nend
subplot(212); %autocorrelation with normalized abscissa
plot(lags*Ts,R); xlabel('lag (s)'); ylabel('Autocorrelation of y(t)')
firstIndex = find(lags==Nbegin); %find index of lag of interest
Rpartial = R(firstIndex:end); %just look at region of interest
[Rmax, relative_index_max]=max(Rpartial);
%Rpartial was just part of R, so need to recalculate the index:
index_max = firstIndex - 1 + relative_index_max;
lag_max = lags(index_max); %get lag corresponding to index
hold on; %show the point:
plot(lag_max*Ts,Rmax,'xr','markersize',20);
F0 = 1/(lag_max*Ts); %estimated F0 frequency (Hz)
fprintf('Rmax=%g lag_max=%g T=%g (sec) Frequency=%g Hz\n',...
    Rmax,lag_max,lag_max*Ts,F0);
t=0:Ts:2; soundsc(cos(2*pi*3*F0*t),Fs); %play frequency 3*F0

axis([-0.015 0.015 -.5 .5]);
%added for plotting the figure:
subplot(211);
axis([0 2*0.015 -1 1]);

writeEPS('sinusoidautocorrelation');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%delay estimation via crosscorrelation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clf
Fs=8000; %sampling frequency
Ts=1/Fs; %sampling interval
N=1.5*Fs; %1.5 seconds
t=[0:N-1]*Ts;
if 1
    x = rand(1,N)-0.5; %zero mean uniformly distributed
else
    x = cos(2*pi*100*t); %cosine
end
delayInSamples=2000;
timeDelay = delayInSamples*Ts %delay in seconds
y=[zeros(1,delayInSamples) x(1:end-delayInSamples)];
SNRdb=10; %specified SNR
signalPower=mean(x.^2);
noisePower=signalPower/(10^(SNRdb/10));
noise=sqrt(noisePower)*randn(size(y));
y=y+noise;
subplot(211); plot(t,x,t,y);
[c,lags]=xcorr(x,y); %find crosscorrelation
subplot(212); handlerPlot = plot(lags*Ts,c);
%find the lag for maximum absolute crosscorrelation:
maxIndex = find(abs(c)==max(abs(c)));
L = lags(maxIndex); 
estimatedTimeDelay = L*Ts
makedatatip(handlerPlot, maxIndex);

%added for figure:
subplot(211)
xlabel('t (s)'); ylabel('x(t) and y(t)');
axis([0 0.5 -1 1])
%legend('x', 'y');
subplot(212)
xlabel('lag (s)'); ylabel('R(lag)');
writeEPS('delayestimation','font12Only');