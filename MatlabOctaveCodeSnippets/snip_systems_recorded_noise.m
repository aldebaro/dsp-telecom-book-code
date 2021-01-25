[x,Fs,b]=readwav('filteredNoise.wav'); %recorded output
N=1024; %number of FFT points
M=floor(length(x)/N); %number of segments of N samples each
x=x(1:N*M); x=x(:); %make sure x is a column vector with N*M samples
xsegments=reshape(x,N,M); %segment x into M blocks
X=abs(fft(xsegments)); %obtain the magnitude for each segment
X=mean(transpose(X)); %transpose: the mean has to be over the FFTs
f=Fs/N*(0:N/2)/1000; %create abscissa in kHz. Fs/N is the bin width
plot(f,20*log10(X(1:N/2+1))),xlabel('f (kHz)'),ylabel('|H(f)| (dBW)')

