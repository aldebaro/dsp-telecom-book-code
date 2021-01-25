[h,Fs,b]=readwav('impulseResponses.wav');
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

