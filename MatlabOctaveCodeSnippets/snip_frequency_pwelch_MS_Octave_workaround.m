N=1024; x = 10*cos(2*3/64*(0:N-1)); %generate a cosine
Xk = (abs(fft(x,N))/N).^2; %MS spectrum: |DTFS|^2
Fs = 1; window = flattopwin(N); %specify Fs and window
H = pwelch(x,window,[],N,Fs,'twosided'); %Welch's estimate
H = H * sum(window.^2)/sum(window)^2; %scale for MS
plot(Xk,'x-'), hold on, plot(H,'or-') %compare

