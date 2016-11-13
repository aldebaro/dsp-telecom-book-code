close all

nstart=12650;%chosen after zooming the signal in impulseResponses.wav
nend=22050;%this was the chosen segment. Adjust them for your data!
if 1 %if you have impulseResponses.wav available
    %[h,Fs,b]=wavread('..\..\Applications\LoopbackMeasurements\impulseResponses.wav','native');
    [h,Fs,b]=wavread('..\Applications\LoopbackMeasurements\impulseResponses.wav');
    h=double(h(nstart:nend)); %segment and cast h to double
else %use signal with few samples extracted from impulseResponses.wav
    duration = floor(nend-nstart+1); %same duration as h above
    h =[-1051, 4155, -32678, -11250, 5536, -4756, 2941, -3162];
    h = [h zeros(1,duration-length(h))]; %pad with zeros
    h = h + 10*randn(1,length(h)); %add some noise
    Fs=44100; %chosen sampling frequency
end
N=1024; %number of FFT points
M=floor(length(h)/N); %number of segments of N samples each
h=h(1:N*M); h=h(:); %make sure h is a column vector with N*M samples
xsegments=reshape(h,N,M); %segment h into M blocks
X=abs(fft(xsegments)); %obtain the magnitude for each segment
X=mean(transpose(X)); %transpose: the mean has to be over the FFTs
f=Fs/N*(0:N/2)/1000; %create abscissa in kHz. Fs/N is the bin width
handler=plot(f,20*log10(X(1:N/2+1))),xlabel('f (kHz)'),ylabel('|H(f)| (dBW)')
makedatatip(handler,[20, 445])
grid, axis tight
writeEPS('loopbackFreqResponse','font12Only')

clf
clear all
%[h,Fs,b]=wavread('..\..\Applications\LoopbackMeasurements\impulseResponses.wav','native');
[h,Fs,b]=wavread('..\Applications\LoopbackMeasurements\impulseResponses.wav');
nstart=11026; %when second \delta[n] occurs in impulses.wav
nend=22050; %segment ends before the third \delta[n] in impulses.wav
h=double(h(nstart:nend)); %segment and cast h to double
N=length(h)-1; %it's convenient to make N an even number to use N/2
H=fft(h,N); %calculate FFT
p = unwrap(angle(H(1:N/2+1))); %unwrap the phase for positive freqs.
f=Fs/N*(0:N/2)/1000; %create abscissa in kHz. Fs/N is the bin width
handler=plot(f,p); xlabel('f (kHz)'),ylabel('\angle{H(f)} (rad)')
k1=1500; k2=4000; makedatatip(handler,[k1,k2]); %choose any 2 points
%Calculate derivative as the slope. Convert from kHz to rad/s first:
groupDelayInSeconds = -atan2(p(k2)-p(k1),2*pi*1000*(f(k2)-f(k1)))
grid, axis tight
writeEPS('loopbackFreqResponsePhase')

clf
%[x,Fs,b]=wavread('..\..\Applications\LoopbackMeasurements\filteredNoise.wav','native');
[x,Fs,b]=wavread('..\Applications\LoopbackMeasurements\filteredNoise.wav');
N=1024; %number of FFT points
M=floor(length(x)/N); %number of segments of N samples each
x=x(1:N*M); x=x(:); %make sure x is a column vector with N*M samples
xsegments=reshape(x,N,M); %segment x into M blocks
X=abs(fft(xsegments)); %obtain the magnitude for each segment
X=mean(transpose(X)); %transpose: the mean has to be over the FFTs
f=Fs/N*(0:N/2)/1000; %create abscissa in kHz. Fs/N is the bin width
handler=plot(f,20*log10(X(1:N/2+1))),xlabel('f (kHz)'),ylabel('|H(f)| (dBW)')
makedatatip(handler,[20, 445])
grid, axis tight
writeEPS('loopbackFreqResponseViaNoise','font12Only')
