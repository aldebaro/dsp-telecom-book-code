N=1000; x = 10*cos(2*pi/64*(0:N-1)); %generate a cosine
Xk = (abs(fft(x,N))/N).^2; %MS spectrum |Xk|^2
Fs = 1; window = hamming(128); %specify Fs and window
H=pwelch(x,window,[],128,Fs,'twosided'); %Welch's estimate
H = H * sum(window.^2)/sum(window)^2; %scale for MS
disp(['Peak from pwelch = ' num2str(max(H)) ' Watts'])
disp(['Peak when using one FFT = ' num2str(max(Xk)) ' W'])

