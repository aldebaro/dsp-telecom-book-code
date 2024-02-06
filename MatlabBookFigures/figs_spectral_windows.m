%% Plots illustrating leakage
% Assume pwd is something like 
% C:\ak_bootor\dsp-telecom-book-code\MatlabOctaveFunctions
outputFolder = '../../latex/ak_dspbook/Figures/';
W0 = 1; % signal angular frequency in rad
A = 3; % signal amplitude in V
N = 14; % window duration in samples
M = 10000; % samples to represent infinite duration signal
subplot(311)
w=[-W0 W0]; Xw=0.5*pi*[A A]; 
h=ak_impulseplot(Xw,w,[]);
xlabel(''), ylabel('X(e^{j\Omega})')
axis([-pi pi 0 A*N/2+2])
%ak_makedatatip(h,[-W0, Xw(1)])
whereToPlace='northwest'; ak_makedatatip(h,[W0, Xw(2)], whereToPlace)
subplot(312)
% discretize the frequency axis in large number M of points
Omega = linspace(-pi, pi, M); 
%add frequency values of interest to facilitate plots
Omega = sort([Omega -W0 W0 0]);
W_div_2 = Omega/2; %speed up things computing only once
rect_window_dtft=(sin(N*W_div_2)./sin(W_div_2)).*exp(-1j*W_div_2*(N-1));
rect_window_dtft(isnan(rect_window_dtft))=N; %L'Hospital rule to correct NaN if 0/0
h=plot(Omega, abs(rect_window_dtft));
xlabel(''), ylabel('|W(e^{j\Omega})|')
axis([-pi pi 0 A*N/2+2])
whereToPlace='northwest'; ak_makedatatip(h,[0, N], whereToPlace)
subplot(313)
W_div_2 = (Omega+W0)/2; %speed up things computing only once
dtft_parcel1=(sin(N*W_div_2)./sin(W_div_2)).*exp(-1j*W_div_2*(N-1));
dtft_parcel1(isnan(dtft_parcel1))=N; %L'Hospital rule to correct NaN if 0/0
W_div_2 = (Omega-W0)/2; %speed up things computing only once
dtft_parcel2=(sin(N*W_div_2)./sin(W_div_2)).*exp(-1j*W_div_2*(N-1));
dtft_parcel2(isnan(dtft_parcel2))=N; %L'Hospital rule to correct NaN if 0/0
Xw = (A/2)*(dtft_parcel1 + dtft_parcel2);
h=plot(Omega, abs(Xw));
axis([-pi pi 0 A*N/2+2])
W0_index = find(Omega==-W0);
whereToPlace='southeast'; ak_makedatatip(h,[-W0, Xw(W0_index)], whereToPlace)
xlabel('\Omega (rad)'), ylabel('|X_w(e^{j\Omega})|')
writeEPS('leakage_example','none',outputFolder)

N = 50; % window duration in samples
M = 10000; % samples to represent infinite duration signal
subplot(311)
w=[-W0 W0]; Xw=0.5*pi*[A A]; 
h=ak_impulseplot(Xw,w,[]);
xlabel(''), ylabel('X(e^{j\Omega})')
axis([-pi pi 0 A*N/2+2])
%ak_makedatatip(h,[-W0, Xw(1)])
whereToPlace='northwest'; ak_makedatatip(h,[W0, Xw(2)], whereToPlace)
subplot(312)
% discretize the frequency axis in large number M of points
Omega = linspace(-pi, pi, M); 
%add frequency values of interest to facilitate plots
Omega = sort([Omega -W0 W0 0]);
W_div_2 = Omega/2; %speed up things computing only once
rect_window_dtft=(sin(N*W_div_2)./sin(W_div_2)).*exp(-1j*W_div_2*(N-1));
rect_window_dtft(isnan(rect_window_dtft))=N; %L'Hospital rule to correct NaN if 0/0
h=plot(Omega, abs(rect_window_dtft));
xlabel(''), ylabel('|W(e^{j\Omega})|')
axis([-pi pi 0 A*N/2+2])
whereToPlace='northwest'; ak_makedatatip(h,[0, N], whereToPlace)
subplot(313)
W_div_2 = (Omega+W0)/2; %speed up things computing only once
dtft_parcel1=(sin(N*W_div_2)./sin(W_div_2)).*exp(-1j*W_div_2*(N-1));
dtft_parcel1(isnan(dtft_parcel1))=N; %L'Hospital rule to correct NaN if 0/0
W_div_2 = (Omega-W0)/2; %speed up things computing only once
dtft_parcel2=(sin(N*W_div_2)./sin(W_div_2)).*exp(-1j*W_div_2*(N-1));
dtft_parcel2(isnan(dtft_parcel2))=N; %L'Hospital rule to correct NaN if 0/0
Xw = (A/2)*(dtft_parcel1 + dtft_parcel2);
h=plot(Omega, abs(Xw));
axis([-pi pi 0 A*N/2+2])
W0_index = find(Omega==-W0);
whereToPlace='southeast'; ak_makedatatip(h,[-W0, Xw(W0_index)], whereToPlace)
xlabel('\Omega (rad)'), ylabel('|X_w(e^{j\Omega})|')
writeEPS('leakage_example2','none',outputFolder)

N = 1000; % window duration in samples
M = 10000; % samples to represent infinite duration signal
subplot(311)
w=[-W0 W0]; Xw=0.5*pi*[A A]; 
h=ak_impulseplot(Xw,w,[]);
xlabel(''), ylabel('X(e^{j\Omega})')
axis([-pi pi 0 A*N/2+2])
%ak_makedatatip(h,[-W0, Xw(1)])
whereToPlace='northwest'; ak_makedatatip(h,[W0, Xw(2)], whereToPlace)
subplot(312)
% discretize the frequency axis in large number M of points
Omega = linspace(-pi, pi, M); 
%add frequency values of interest to facilitate plots
Omega = sort([Omega -W0 W0 0]);
W_div_2 = Omega/2; %speed up things computing only once
rect_window_dtft=(sin(N*W_div_2)./sin(W_div_2)).*exp(-1j*W_div_2*(N-1));
rect_window_dtft(isnan(rect_window_dtft))=N; %L'Hospital rule to correct NaN if 0/0
h=plot(Omega, abs(rect_window_dtft));
xlabel(''), ylabel('|W(e^{j\Omega})|')
axis([-pi pi 0 A*N/2+2])
whereToPlace='northwest'; ak_makedatatip(h,[0, N], whereToPlace)
subplot(313)
W_div_2 = (Omega+W0)/2; %speed up things computing only once
dtft_parcel1=(sin(N*W_div_2)./sin(W_div_2)).*exp(-1j*W_div_2*(N-1));
dtft_parcel1(isnan(dtft_parcel1))=N; %L'Hospital rule to correct NaN if 0/0
W_div_2 = (Omega-W0)/2; %speed up things computing only once
dtft_parcel2=(sin(N*W_div_2)./sin(W_div_2)).*exp(-1j*W_div_2*(N-1));
dtft_parcel2(isnan(dtft_parcel2))=N; %L'Hospital rule to correct NaN if 0/0
Xw = (A/2)*(dtft_parcel1 + dtft_parcel2);
h=plot(Omega, abs(Xw));
axis([-pi pi 0 A*N/2+2])
W0_index = find(Omega==-W0);
whereToPlace='southeast'; ak_makedatatip(h,[-W0, Xw(W0_index)], whereToPlace)
xlabel('\Omega (rad)'), ylabel('|X_w(e^{j\Omega})|')
writeEPS('leakage_example3','none',outputFolder)

%% Plots illustrating combined effect of leakage and picket-fence
outputFolder = '../../latex/ak_dspbook/Figures/';
clf
snip_frequency_fftCosineExample(8,2)
writeEPS('leak_picket_ex1','none',outputFolder)

clf
snip_frequency_fftCosineExample(8,2.5)
writeEPS('leak_picket_ex2','none',outputFolder)

clf
snip_frequency_fftCosineExample(8,0)
writeEPS('leak_picket_ex3','none',outputFolder)

clf
snip_frequency_fftCosineExample(32, 8.3)
writeEPS('leak_picket_ex4','none',outputFolder)

clf
subplot(221)
N=10;
n=0:N-1;
alpha=2.5;
xwn=6*cos(alpha*2*pi/N*n);
stem(n,xwn)
ylabel('x_w[n]')
subplot(222)
snip_frequency_fftCosineExample(N, alpha)
xlabel('')
subplot(223)
alpha=pi;
xwn=6*cos(alpha*2*pi/N*n);
stem(n,xwn)
xlabel('n'), ylabel('x_w[n]')
subplot(224)
snip_frequency_fftCosineExample(N, alpha)
writeEPS('leak_picket_ex5','none',outputFolder)

clf
subplot(121)
N=256;
alpha=50;
snip_frequency_fftCosineExample(N, alpha)
alpha=30.5;
subplot(122)
snip_frequency_fftCosineExample(N, alpha)
ylabel('')
writeEPS('leak_picket_ex6','none',outputFolder)

%% Windows
clf
numW = 5; %number of windows
N=32;
allWin = zeros(N,numW);
allWin(:,1)=rectwin(N);
allWin(:,2)=hamming(N);
allWin(:,3)=hanning(N);
allWin(:,4)=kaiser(N,7.85);
allWin(:,5)=flattopwin(N);

Npad=1024-N;
bin=(2*pi)/(N+Npad);
w=-pi:bin:pi-bin;
n=0:N-1;

%ak_plotSeveralCurves(n,allWin)
plot(n,allWin)
legend('Rectangular','Hamming','Hann','Kaiser','Flat top');
grid
xlabel('Time (n)');
ylabel('Window w[n]');
axis([0,N-1,-0.2,1.2])
writeEPS('windowsTimeDomain')

% Frequency Analysis
close all
allSpectra = fft(allWin,N+Npad); %non-normalized
allSpectraNormalized = zeros(size(allSpectra)); %normalized by the DC value
%I cannot use fftshift for the whole matrix because it performs the shift in both dimensions!
for ii=1:numW
    allSpectraNormalized(:,ii) = allSpectra(:,ii) / allSpectra(1,ii); %make DC = 1
    allSpectra(:,ii) = fftshift(allSpectra(:,ii)); %make fftshift
    allSpectraNormalized(:,ii) = fftshift(allSpectraNormalized(:,ii)); %make fftshift
end

%ak_plotSeveralCurves(w,fftshift(20*log10(abs(allSpectra))));
plot(w,20*log10(abs(allSpectra)));
legend('Rectangular','Hamming','Hann','Kaiser','Flat top');
xlabel('\Omega (radians)');
axis([-pi,pi,-100,40])
ylabel('|W(e^{j \Omega})| (dB)');
writeEPS('windowsFreqDomain')

plot(w,(20*log10(abs(allSpectraNormalized))));
xlabel('\Omega (radians)');
%plot(w,fftshift(20*log10(abs(allSpectraNormalized(:,1)))),'-x');
legend('Rectangular','Hamming','Hann','Kaiser','Flat top');
axis([0,pi,-110,10])
ylabel('|W(e^{j \Omega})| (dB)');
writeEPS('windowsFreqDomainNormalized')

% Comparison of side-lobes fall-off
%figure is not so good so I will take it out
if 0
    N=512;
    allWin = zeros(N,numW);
    allWin(:,1)=rectwin(N);
    allWin(:,2)=hamming(N);
    allWin(:,3)=hanning(N);
    allWin(:,4)=kaiser(N,7.85);
    allWin(:,5)=flattopwin(N);

    Npad=4096-N;
    bin=(2*pi)/(N+Npad);
    w=-pi:bin:pi-bin';

    allSpectra = fft(allWin,N+Npad); %will normalize
    for ii=1:numW
        allSpectra(:,ii) = allSpectra(:,ii) / allSpectra(1,ii); %make DC = 1
        allSpectra(:,ii) = fftshift(allSpectra(:,ii)); %make fftshift
    end

    clf
    plot(w,20*log10(abs(allSpectra)),'x');
    axis([0.3 pi -150 -40]);
    ylabel('Normalized dB Magnitude');
    xlabel('Frequency (radians)');
    title('Comparison of side-lobe fall-off of windows');
    legend('Rectangular','Hamming','Hann','Kaiser','Flat top');
end

%Evaluating weak and strong sines spectra
N=256;%number of samples available of x1 and x2
bin=(2*pi)/N; %DFT spacing in rads
w=-pi:bin:pi-bin'; %abscissa for plots
n=0:N-1; %abscissa
kweak=32; %FFT bin where the weak cosine is located
kstrong1=38; %FFT bin for strong cosine in x1
weakSigal = 1*cos((2*pi*kweak/N)*n+pi/3); %common parcel
x1=100*cos((2*pi*kstrong1/N)*n+pi/4) + weakSigal;
kstrong2=37.5; %location for strong cosine in x2
x2=100*cos((2*pi*kstrong2/N)*n+pi/4) + weakSigal;

subplot(421)
x=x1.*rectwin(N)';
factor=max(abs(fft(x)));
plot(w,fftshift(20*log10(abs(fft(x)/factor))));
%yl=sprintf('dB Magnitude (normalizing factor = %.2f dB)',20*log10(1/factor));
%title('Rectangular') % Window - Stronger cosine is bin centered');
%xlabel('Frequency (radians)');
%ylabel(yl)
ylabel('Rectangular')
title('Bin-centered')
axis([-pi pi -80 0]);
set(gca,'Xtick',[])
%pause

subplot(422)
x=x2.*rectwin(N)';
factor=max(abs(fft(x)));
plot(w,fftshift(20*log10(abs(fft(x)/factor))));
%yl=sprintf('dB Magnitude (normalizing factor = %.2f dB)',20*log10(1/factor));
%title('Rectangular Window - Stronger cosine is not bin centered');
%xlabel('Frequency (radians)');
%ylabel(yl)
title('Not bin-centered')
axis([-pi pi -80 0]);
set(gca,'Xtick',[])
%pause

subplot(423)
x=x1.*hanning(N)';
factor=max(abs(fft(x)));
plot(w,fftshift(20*log10(abs(fft(x)/factor))));
%yl=sprintf('dB Magnitude (normalizing factor = %.2f dB)',20*log10(1/factor));
%title('Hann Window - Stronger cosine is bin centered');
%xlabel('Frequency (radians)');
ylabel('Hann')
axis([-pi pi -80 0]);
set(gca,'Xtick',[])
%pause

subplot(424)
x=x2.*hanning(N)';
factor=max(abs(fft(x)));
plot(w,fftshift(20*log10(abs(fft(x)/factor))));
%yl=sprintf('dB Magnitude (normalizing factor = %.2f dB)',20*log10(1/factor));
%title('Hann Window - Stronger cosine is not bin centered');
%xlabel('Frequency (radians)');
%ylabel(yl)
axis([-pi pi -80 0]);
set(gca,'Xtick',[])
%pause

subplot(425)
x=x1.*hamming(N)';
factor=max(abs(fft(x)));
plot(w,fftshift(20*log10(abs(fft(x)/factor))));
%yl=sprintf('dB Magnitude (normalizing factor = %.2f dB)',20*log10(1/factor));
%title('Hamming Window - Stronger cosine is bin centered');
%xlabel('Frequency (radians)');
ylabel('Hamming')
axis([-pi pi -80 0]);
set(gca,'Xtick',[])
%pause

subplot(426)
x=x2.*hamming(N)';
factor=max(abs(fft(x)));
plot(w,fftshift(20*log10(abs(fft(x)/factor))));
%yl=sprintf('dB Magnitude (normalizing factor = %.2f dB)',20*log10(1/factor));
%title('Hamming Window - Stronger cosine is not bin centered');
%xlabel('Frequency (radians)');
%ylabel(yl)
axis([-pi pi -80 0]);
set(gca,'Xtick',[])
%pause

subplot(427)
x=x1.*kaiser(N,7.85)';
factor=max(abs(fft(x)));
plot(w,fftshift(20*log10(abs(fft(x)/factor))));
%yl=sprintf('dB Magnitude (normalizing factor = %.2f dB)',20*log10(1/factor));
%title('Kaiser Window - Stronger cosine is bin centered');
xlabel('\Omega (rad)');
ylabel('Kaiser')
axis([-pi pi -80 0]);
%pause

subplot(428)
x=x2.*kaiser(N,7.85)';
factor=max(abs(fft(x)));
plot(w,fftshift(20*log10(abs(fft(x)/factor))));
%yl=sprintf('dB Magnitude (normalizing factor = %.2f dB)',20*log10(1/factor));
%title('Kaiser Window - Stronger cosine is not bin centered');
xlabel('\Omega (rad)');
%ylabel(yl)
axis([-pi pi -80 0]);
%pause
writeEPS('windowsHarmonicAnalysis','font12Only')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Additional comparisons for the non bin-centered case
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clf
x2a=100*cos((2*pi*kstrong2/N)*n+pi/4);
x2b=1*cos((2*pi*kweak/N)*n+pi/3);
factor=max([max(abs(fft(x2a))) max(abs(fft(x2b)))]);
plot(w,fftshift(20*log10(abs(fft(x2a)/factor))));
hold on
plot(w,fftshift(20*log10(abs(fft(x2b)/factor))),'r');
%yl=sprintf('dB Magnitude (normalizing factor = %.2f dB)',20*log10(1/factor));
title('Rectangular Window');
legend('stronger','weaker')
xlabel('Frequency (radians)');
ylabel('Normalized magnitude (dB)')
axis([-pi pi -80 0]);
writeEPS('windowsRectangularNotCentered')

clf
x2a=100*cos((2*pi*kstrong2/N)*n+pi/4);
x2b=1*cos((2*pi*kweak/N)*n+pi/3);
x2a=x2a.*kaiser(N,7.85)';
x2b=x2b.*kaiser(N,7.85)';
factor=max([max(abs(fft(x2a))) max(abs(fft(x2b)))]);
plot(w,fftshift(20*log10(abs(fft(x2a)/factor))));
hold on
plot(w,fftshift(20*log10(abs(fft(x2b)/factor))),'r');
%yl=sprintf('dB Magnitude (normalizing factor = %.2f dB)',20*log10(1/factor));
title('Kaiser Window');
legend('stronger','weaker')
xlabel('Frequency (radians)');
ylabel('Normalized magnitude (dB)')
axis([-pi pi -80 0]);
writeEPS('windowsKaiserNotCentered')

%% Filter banks %%%%%%%%%%%%%%%
% DFT as a filter bank. Using Rectangular window
clf
w=linspace(-pi,pi,256);
N=8;
n=0:N-1;
hn=zeros(N,N);
hold on
for k=0:N-1
    hn(k+1,:)=rectwin(N)'.*exp((i*2*pi*k*n)/N);
end
filter_response=abs(fft(hn,256));
plot(w,fftshift(20*log10(filter_response/max(filter_response(:)))));
axis([-pi pi -40 0]);
title('DFT filter bank with rectangular window.');
xlabel('\Omega (rads)');
ylabel('Normalized dB Magnitude');
plot([-pi:2*pi/N:pi-2*pi/N],-40*[ones(1,N)],'ko','markersize',12);
plot(w,fftshift(20*log10(filter_response(:,7)/max(filter_response(:)))),'xr','LineWidth',3);
writeEPS('dftFilterBankRectangular','font12Only')

% DFT as a filter bank. Using Kaiser window
clf
w=linspace(-pi,pi,256);
N=8;
n=(0:N-1)';
hn=zeros(N,N);
filter_response=zeros(256,N);
hold on
for k=0:N-1
    hn(:,k+1)=kaiser(N,7.85).*exp((i*2*pi*k*n)/N);
    filter_response(:,k+1)=fftshift(abs(fft(hn(:,k+1),256)));
    filter_response(:,k+1)=20*log10(filter_response(:,k+1)/max(filter_response(:)));
end
plot(w,filter_response);
axis([-pi pi -100 0]);
title('DFT filter bank with Kaiser window.');
xlabel('\Omega (rads)');
ylabel('Normalized dB Magnitude');
plot([-pi:2*pi/N:pi-2*pi/N],-100*[ones(1,N)],'ko','markersize',12);
plot(w,filter_response(:,3),'rx','LineWidth',3);
writeEPS('dftFilterBankKaiser','font12Only')
