%Monte Carlo simulation to compare with theoretical
%expression for unipolar RZ line code
close all
Rsym=6; %symbols (bits in this case) per second
Tsym=1/Rsym; %symbol period
A=1;
B=1;
M=4; %Tsym/M is the support of the shaping pulse
oversampling=24; %needs to be a multiple of M
N=100000; %number of symbols
Fs=oversampling*Rsym;
x=rand(1,N)>=0.5; %convert to 0 or 1 amplitudes
x=B*x;
%x=2*(x-0.5); %convert to -1 or 1 amplitudes
%p=ones(oversampling/4,1); %p=ones(oversampling,1);
p=[ones(oversampling/M,1); ... %mimics a RZ pulse 
    zeros(oversampling-oversampling/M,1)]; %(oversampling is "Tsym")
p=A*p;
%p=[ones(oversampling/2,1); -ones(oversampling/2,1)]; 
s=zeros(N*oversampling,1);
s(1:oversampling:end)=x;
s=filter(p,1,s);

%% PSD estimation with large FFT bins (small variance)
window=512; %window length
noverlap=window/2; %number of overlapping samples
fftsize=window; 
%if you use below, the result is off by 3 dB:
%[P,f]=pwelch(s,window,noverlap,fftsize,fs,'onesided');
[P,f]=pwelch(s,window,noverlap,fftsize,Fs,'twosided');
f=f(1:window/2); %f is from 0 to fs...
P=P(1:window/2); %keep only from 0 to fs/2
plot(f,10*log10(P),'r');
xlabel('frequency (Hz)')
ylabel('PSD (dBW / Hz)')
%axis([0 20 -50 0])
grid
hold on

%% Theoretical PSD expression 
%rzunipolar=1^2*Tsym*sinc(f*Tsym).^2; %theoretical expression
constantFactor=A^2*B^2*Tsym/(4*M^2);
rzunipolar=constantFactor*sinc(f*Tsym/M).^2;
psddB = 10*log10(rzunipolar);
plot(f,psddB,'b-')
%generate impulses
maxMultiple=ceil(max(f)/Rsym);
impAbscissa=[];
for i=1:maxMultiple
    if i/M ~= round(i/M)
        impAbscissa = [impAbscissa i];
    end
end
%impAbscissa = Rsym*[-fliplr(impAbscissa) 0 impAbscissa];
impAbscissa = Rsym*[0 impAbscissa];
impulsesArea=(1/Tsym)*constantFactor*sinc(impAbscissa*Tsym/M).^2;
impulsesStarts=constantFactor*sinc(impAbscissa*Tsym/M).^2;
impulsesStops=impulsesStarts+impulsesArea;
ak_impulseplotOnCurve(impAbscissa,10*log10(impulsesStarts),...
    10*log10(impulsesStops),axis)
legend('Simulated','Theoretical');
axis([-2 72 -80 -10])

writeEPS('psd_rz_unipolar_small_variance','font12Only');
pause
%% PSD estimation with small FFT bins (large variance)
clf
[P2,f2]=ak_psd(s,Fs);
plot(f2,P2-30,'r'); %convert dBm/Hz into dBW/Hz by subtracting 30 dB
hold on
plot(f,psddB,'b-')
ak_impulseplotOnCurve(impAbscissa,10*log10(impulsesStarts),...
    10*log10(impulsesStops),axis)
legend('Simulated','Theoretical');
xlabel('frequency (Hz)')
ylabel('PSD (dBW / Hz)')
%axis([0 20 -50 0])
grid
axis([-2 72 -80 20])
writeEPS('psd_rz_unipolar_large_variance','font12Only');
