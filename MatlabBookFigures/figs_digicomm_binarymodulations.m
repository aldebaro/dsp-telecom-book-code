close all
clf
N=10; %number of bits
bits=floor(2*rand(1,N)); %generate N random bits
modulation = 'ASK'; %choose modulation
plot(ak_simpleBinaryModulation(modulation, bits),'x-')
title([modulation ' modulation of bits: ' num2str(bits)])
xlabel('n'); ylabel('s[n]');
writeEPS('binaryask');

modulation = 'FSK';
plot(ak_simpleBinaryModulation(modulation, bits),'x-')
title([modulation ' modulation of bits: ' num2str(bits)])
xlabel('n'); ylabel('s[n]');
writeEPS('binaryfsk');

modulation = 'PSK';
plot(ak_simpleBinaryModulation(modulation, bits),'x-')
title([modulation ' modulation of bits: ' num2str(bits)])
xlabel('n'); ylabel('s[n]');
writeEPS('binarypsk');

%calculate PSDs

N=100000; %number of bits
bits=floor(2*rand(1,N)); %generate N random bits
%noverlap=window/2 %creates conflict between pwelch in Matlab and Octave
window=8192;noverlap=[];fftsize=window;fs=16000;
subplot(311);
s=ak_simpleBinaryModulation('ASK', bits);
mean(s.^2)
pwelch(s,window,noverlap,fftsize,fs)
xlabel([]); ylabel([]); title('ASK');
axis([0 8 -100 0])
subplot(312);
s=ak_simpleBinaryModulation('FSK', bits);
mean(s.^2)
pwelch(s,window,noverlap,fftsize,fs)
xlabel(''); title('FSK'); ylabel('PSD (dBW/Hz)');
axis([0 8 -100 0])
subplot(313);
s=ak_simpleBinaryModulation('PSK', bits);
mean(s.^2)
pwelch(s,window,noverlap,fftsize,fs)
ylabel('');
title('PSK');
axis([0 8 -100 0])
writeEPS('psds_ask_fsk_psk');

%% PAM spectrum
close all
snip_digi_comm_PAM_PSD
writeEPS('pam_spectrum_th_em','font12Only');

%linear modulation
clear all
rand('seed',13);
clf
M=4; %cardinality of the set of symbols
N=10; %number of symbols to be generated
S=5; %oversampling factor
p=[1 1 1]; %an example of pulse

indices=floor(M*rand(1,N))+1; %random indices from [1, M]
largestAmplitude = M-1; %considering ..., -3,-1,1,3,5,7,...
alphabet=[-largestAmplitude:2:largestAmplitude]; %possible symbols
m=alphabet(indices); %obtain N random symbols
m_upsampled=zeros(1,N*S); %allocate space and fill with zeros
m_upsampled(1:S:end)=m;
s=filter(p,1,m_upsampled); %convolve with p and discard last samples
n=0:length(s)-1;

subplot(411); stem(0:N-1,m); xlabel('n'''); ylabel('Sym. m[n'']')
axis([0 10 -3 3])
subplot(412); stem(n,m_upsampled); xlabel('n'); ylabel('Ups. m_u[n]')
axis([0 50 -3 3])
subplot(413); stem(n,[p zeros(1,N*S-length(p))]); xlabel('n'); ylabel('Pulse p[n]')
axis([0 8 -1 2])
subplot(414); stem(n,s); xlabel('n'); ylabel('s[n]')
axis([0 50 -3 3])
x=get(gcf, 'Position'); %get figure's position on screen
x(4)=floor(x(4)*1.4); %adjust the size making it "taller"
set(gcf, 'Position',x);
writeEPS('linearModulation','font12Only');
close all

clf

N=10; %number of symbols to be generated
Fs=20;
Ts=1/Fs;

S=500; %need much larger oversampling factor for nice pictures
%p=conv(ones(1,S/4),ones(1,S/4))/25; %an example of pulse
p=ones(1,S/2); %an example of pulse
Tsym = S*Ts

m_upsampled=zeros(1,N*S); %allocate space and fill with zeros
m_upsampled(1:S:end)=m;
s=filter(p,1,m_upsampled); %convolve with p and discard last samples
n=0:length(s)-1;
t=n*Ts;

subplot(411); stem(0:N-1,m); xlabel('n'); ylabel('Symbol m[n]')
axis([0 10 -5 5])
subplot(412); ak_sampledsignalsplot(m,[],Tsym); xlabel('t (s)'); ylabel('m_s(t)')
axis([0 250 -3 3])
pulse = zeros(size(t)); pulse(1:S/2)=1; %pulse version with size of t
%subplot(413); plot(t(1:4*length(p)),[p zeros(1,3*length(p))]); xlabel('t (s)'); ylabel('p(t)')
subplot(413); plot(t,pulse); xlabel('t (s)'); ylabel('p(t)')
%axis([ 0 2*Tsym -1 3])
%axis([ 0 250 -0.1 1.1])
axis([ 0 250 -0.1 3])
subplot(414); plot(t,s); xlabel('t (s)'); ylabel('s(t)')
x=get(gcf, 'Position'); %get figure's position on screen
x(4)=floor(x(4)*1.4); %adjust the size making it "taller"
set(gcf, 'Position',x);
axis 'tight'
writeEPS('linearModulationSampled');
close all


%Same data, but with pulses with 100% of duty cycle
clf
p=ones(1,S); %an example of pulse
m_upsampled=zeros(1,N*S); %allocate space and fill with zeros
m_upsampled(1:S:end)=m;
s=filter(p,1,m_upsampled); %convolve
h=plot(t,s); xlabel('t (s)'); ylabel('r(t)')
hold on
for th=-2:2:2
    plot([t(1) t(end)],th*[1 1],'r--')
end
axis([t(1) t(end) -3.5 3.5])
for n=S/2:S:length(t)
    text(t(n)-1,0.5,num2str(s(n)));
end
legend1=legend('PAM signal','thresholds');
set(legend1,'Position',[0.4613 0.796 0.2464 0.1095]);
set(gca,'xtick',[0:Tsym:t(end)])
myaxis = axis;
writeEPS('pamExampleFullDutyCycle');

clf
h=plot(t,s); xlabel('t (s)'); ylabel('r(t)')
hold on
bits=['00';'01';'10';'11'];
for n=S/2:S:length(t)
    text(t(n)-1,0.5,bits(((s(n)+3)/2)+1,:));
end
set(gca,'xtick',[0:Tsym:t(end)])
set(gca,'ytick',[-3:2:3])
axis(myaxis);
grid
writeEPS('pamExampleFullDutyCycleWithBits');

clf
[B,A]=cheby1(5,0.5,0.0055)
sf=filter(B,A,s); %convolve
grid
h=plot(t,sf); xlabel('t (s)'); ylabel('r(t)')
set(gca,'xtick',[0:Tsym:t(end)])
grid
for n=S/2:S:length(t)
    text(t(n)-1,3.5,num2str(s(n)));
end
writeEPS('pamExampleDistortedFullDutyCycle');