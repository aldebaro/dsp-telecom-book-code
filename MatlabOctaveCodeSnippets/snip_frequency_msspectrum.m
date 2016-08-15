N=1024; x = transpose(10*cos(2*3/64*(0:N-1))); %generate a cosine
Xk = (abs(fft(x,N))/N).^2; %MS spectrum: |DTFS|^2
Fs = 2*pi; myWindow = hamming(N); %specify Fs and a Hamming window
H = Fs*pwelch(x,myWindow,[],N,Fs,'twosided');%Welch's estimate. Third
%parameter is [] because in Matlab is num. samples while Octave is %
H = H * sum(myWindow.^2)/sum(myWindow)^2; %scale for MS
plot(Xk,'x-'), hold on, plot(H,'or-') %compare
