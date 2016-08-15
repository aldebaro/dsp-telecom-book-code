N=3000; %total number of samples
n=0:N-1; %abscissa
x1=100*cos(2*pi/30*n); %first cosine
x2=1*cos(2*pi/7*n); %second cosine
x=[x1 x2]; %concatenation of 2 cosines
subplot(211), pwelch(x) %PSD
subplot(212), specgram(x), colorbar %spectrogram

