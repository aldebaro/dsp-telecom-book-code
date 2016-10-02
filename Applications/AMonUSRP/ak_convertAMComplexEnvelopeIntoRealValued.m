%% Convert file with complex envelope obtained with an USRP into
%% a real-valued signal upconverted to pi/2 radians.
close all, clear *
wc=2*pi/3; %frequency to be used in upconversion
rc=read_complex_binary('am_usrp710.dat'); %read file in binary format
rc(1:20)=[]; %take out transient
Fs=256000; %original sampling frequency
%% Increase sampling rate by 4
U=4; %upsampling factor
rc_up=resample(rc,U,1,30); %use FIR of order 30
[B,A]=butter(10,0.17); %design filter to eliminate images
%freqz(B,A); %check filter
rc_up = filtfilt(B,A,rc_up); %linear phase filtering using IIR
%% Frequency upconversion (it required increasing sampling rate)
N=length(rc_up);
carrier=transpose(exp(1j*wc*(0:N-1))); %center signal at wc rad
rc2=rc_up.*carrier; %upconversion
%% Make it real-valued
rr = real(rc2);
rr = sqrt(2)*rr; %correct amplitude (power)
%% Save to a wav file
Fs2=U*Fs; %Note that Fs2=floor(Fs*length(rr)/length(rc));
maxAbs=ceil(max(abs(rr))); %wavwrite restricts to [-1,1[.
wavwrite(rr/maxAbs,Fs2,16,'am_real.wav'); %write with 16 bits/sample

if 1 %show plots
    Nfft=8192;
    Pc=pwelch(rc,hamming(Nfft),Nfft/2,Nfft,Fs,'twosided'); %PSD 
    Pr=pwelch(rr,hamming(Nfft),Nfft/2,Nfft,Fs2,'twosided'); %PSD
    df=Fs/Nfft; f=-Fs/2:df:Fs/2-df; %create frequency (abscissa) axis
    df2=Fs2/Nfft; f2=-Fs2/2:df2:Fs2/2-df2; %create abscissa axis
    clf, subplot(311)
    h=plot(f/1e3+710,fftshift(10*log10(Pc))); %original spectrum
    grid, axis tight
    makedatatip(h,find(f==0,1))
    title('Original complex signal: two-sided PSD')
    subplot(313)
    h=plot(f2/1e3,fftshift(10*log10(Pr))); %original spectrum
    grid, axis tight
    makedatatip(h,find(abs(f2-128)<df2,1))
    title('Processed real signal: two-sided PSD')
    subplot(312)
    Pr2=pwelch(rr,hamming(Nfft),Nfft/2,Nfft,Fs2); %PSD estimation
    df2=Fs2/Nfft; f2=0:df2:Fs2/2; %create frequency (abscissa) axis
    h=plot(f2/1e3,10*log10(Pr2)); %original spectrum
    grid, axis tight
    title('Processed real signal: one-sided PSD')
    figure(2)
    plot(linspace(0,1,length(Pc)),fftshift(10*log10(Pc)));
    hold on
    h=plot(linspace(0,1,length(Pr2)),10*log10(Pr2),'r'); 
    title('comparison of subplots 1 and 2 of figure 1');
end