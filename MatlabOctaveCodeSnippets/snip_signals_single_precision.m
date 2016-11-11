N=2^20; %FFT length (one may try different values)
xs=single(randn(1,N)); %generate random signal using single precision
xd=randn(1,N); %generate random signal using double precision
tic %start time counter
Xs=fft(xs); %calculate FFT with single precision
disp('Single precision: '), toc %stop time counter
tic %start time counter
Xd=fft(xd); %calculate FFT with double precision
disp('Double precision: '), toc %stop time counter
