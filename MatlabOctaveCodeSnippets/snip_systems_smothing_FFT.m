nstart=12650;%chosen after zooming the signal in impulseResponses.wav
nend=22050;%this was the chosen segment. Adjust them for your data!
if 1 %if you have impulseResponses.wav available
    [h,Fs,b]=wavread('impulseResponses.wav');
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
plot(f,20*log10(X(1:N/2+1))),xlabel('f (kHz)'),ylabel('|H(f)| (dBW)')

