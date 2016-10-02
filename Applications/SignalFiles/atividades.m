%3) DTFS via FFT
N=8000;
n=0:N-1;
w1=2*pi/4;
w2=2*pi/400;
x=10+8*cos(w1*n)+5*cos(w2*n+3);
fp=fopen('dtfs_via_fft.floatbigendian','w','b');
fwrite(fp,x,'float');
fclose(fp);
if 0
    fp=fopen('dtfs_via_fft.floatbigendian','r','b');
    y=fread(fp,Inf,'float');
    fclose(fp);
end
%4) DTFT via FFT: snip_transforms_DTFT_pulse.m
N=512; %DFT size
N1=5; %num. non-zero samples in the (aperiodic) pulse
x=[ones(1,N1) zeros(1,N-N1)]; %signal x[n]
wavwrite(x,1,'dtft_via_fft');
%[y,Fs]=wavread('dtft_via_fft');

%frequency analysis
N=256; %number of samples available of x1 and x2
n=0:N-1; %abscissa
kweak=32; %FFT bin where the weak cosine is located
kstrong1=38; %FFT bin for strong cosine in x1
weakSigal = 1*cos((2*pi*kweak/N)*n+pi/3); %common parcel
x1=100*cos((2*pi*kstrong1/N)*n+pi/4) + weakSigal; %x1[n]
wavwrite(x1/101,8000,'sinusoids1.wav');
[y,Fs]=wavread('sinusoids1.wav');

kstrong2=39.5; %location for strong cosine in x2
x2=100*cos((2*pi*kstrong2/N)*n+pi/4) + weakSigal; %x2[n]
wavwrite(x2/101,8000,'sinusoids2.wav');


