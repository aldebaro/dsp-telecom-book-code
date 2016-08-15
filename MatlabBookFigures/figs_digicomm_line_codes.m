clear all
close all
S=200; %need large oversampling factor for nice pictures
N=7;
Fs=50; Ts=1/Fs;
Tsym=S*Ts %show Tsym
n=0:N*S-1;
t=n*Ts; %total time (for plotting purposes)
tp=-Tsym:Ts:2*Tsym-Ts; %3 symbols time (for plotting purposes)
bits=[0 1 0 1 1 0 0];

%polar NRZ
m=[-1 1 -1 1 1 -1 -1];
p=ones(1,S); %NRZ pulse
m_upsampled=zeros(1,N*S); %allocate space and fill with zeros
m_upsampled(1:S:end)=m;
s=filter(p,1,m_upsampled); %convolve with p and discard last samples
subplot(431); ak_sampledsignalsplot(m,[],Tsym); xlabel(''); title('m_s(t)'); axis([0 (N)*Tsym -1.5 1.5])
ylabel('polar NRZ')
subplot(432); plot(tp,[zeros(1,S) p zeros(1,S)]); axis([-Tsym 2*Tsym -1.5 1.5]); title('p(t)')
hold on, plot(0:Ts:Tsym-Ts,p,'r.')
subplot(433); plot(t,s); title('s(t)'); axis([0 (N)*Tsym -1.5 1.5])

%unipolar NRZ
m=[0 1 0 1 1 0 0];
p=ones(1,S); %NRZ pulse
m_upsampled=zeros(1,N*S); %allocate space and fill with zeros
m_upsampled(1:S:end)=m;
s=filter(p,1,m_upsampled); %convolve with p and discard last samples
subplot(434); ak_sampledsignalsplot(m,[],Tsym); xlabel(''); axis([0 (N)*Tsym -1.5 1.5])
ylabel('unipolar NRZ')
subplot(435); plot(tp,[zeros(1,S) p zeros(1,S)]); axis([-Tsym 2*Tsym -1.5 1.5]);
hold on, plot(0:Ts:Tsym-Ts,p,'r.')
subplot(436); plot(t,s); axis([0 (N)*Tsym -1.5 1.5])

%polar RZ
m=[-1 1 -1 1 1 -1 -1];
p=[ones(1,S/2) zeros(1,S/2)]; %RZ pulse
m_upsampled=zeros(1,N*S); %allocate space and fill with zeros
m_upsampled(1:S:end)=m;
s=filter(p,1,m_upsampled); %convolve with p and discard last samples
subplot(437); ak_sampledsignalsplot(m,[],Tsym); xlabel(''); axis([0 (N)*Tsym -1.5 1.5])
ylabel('polar RZ')
subplot(438); plot(tp,[zeros(1,S) p zeros(1,S)]); axis([-Tsym 2*Tsym -1.5 1.5]);
hold on, plot(0:Ts:Tsym-Ts,p,'r.')
subplot(439); plot(t,s); axis([0 (N)*Tsym -1.5 1.5])

%Manchester
m=[-1 1 -1 1 1 -1 -1];
p=[ones(1,S/2) -ones(1,S/2)]; %Manchester pulse
m_upsampled=zeros(1,N*S); %allocate space and fill with zeros
m_upsampled(1:S:end)=m;
s=filter(p,1,m_upsampled); %convolve with p and discard last samples
subplot(4,3,10); ak_sampledsignalsplot(m,[],Tsym); xlabel(''); axis([0 (N)*Tsym -1.5 1.5])
xlabel('t (s)'); ylabel('Manchester')
subplot(4,3,11); plot(tp,[zeros(1,S) p zeros(1,S)]); axis([-Tsym 2*Tsym -1.5 1.5]);
hold on, plot(0:Ts:Tsym-Ts,p,'r.')
xlabel('t (s)')
subplot(4,3,12); plot(t,s); axis([0 (N)*Tsym -1.5 1.5])
xlabel('t (s)')

x=get(gcf, 'Position'); %get figure's position on screen
x(4)=floor(x(4)*1.4); %adjust the size making it "taller"
set(gcf, 'Position',x);

writeEPS('linecodes');

clf

%polar NRZ
m=[-1 1 -1 1 1 -1 -1];
p=ones(1,S); %NRZ pulse
m_upsampled=zeros(1,N*S); %allocate space and fill with zeros
m_upsampled(1:S:end)=m;
s=filter(p,1,m_upsampled); %convolve with p and discard last samples
subplot(331); ak_sampledsignalsplot(m,[],Tsym); xlabel(''); title('m_s(t)'); axis([0 (N)*Tsym -1.5 1.5])
ylabel('polar NRZ')
subplot(332); plot(tp,[zeros(1,S) p zeros(1,S)]); axis([-Tsym 2*Tsym -1.5 1.5]); title('p(t)')
hold on, plot(0:Ts:Tsym-Ts,p,'r.')
subplot(333); plot(t,s); title('s(t)'); axis([0 (N)*Tsym -1.5 1.5])

%Bipolar (also called pseudoternary and alternate mark inversion (AMI)
%it has memory, so need to properly generate m
m=zeros(1,N);
currentPolarity = 1; %initialize with positive polarity
for i=1:N
    if bits(i)==1
        m(i)=currentPolarity;
        currentPolarity = -currentPolarity; %invert for next bit 1
        %the "else" is not necessary because m(i) is initialized as zero
    end
end
p=ones(1,S); %NRZ pulse
m_upsampled=zeros(1,N*S); %allocate space and fill with zeros
m_upsampled(1:S:end)=m;
s=filter(p,1,m_upsampled); %convolve with p and discard last samples
subplot(334); ak_sampledsignalsplot(m,[],Tsym); xlabel(''); title('m_s(t)'); axis([0 (N)*Tsym -1.5 1.5])
ylabel('Bipolar')
subplot(335); plot(tp,[zeros(1,S) p zeros(1,S)]); axis([-Tsym 2*Tsym -1.5 1.5]); title('p(t)')
hold on, plot(0:Ts:Tsym-Ts,p,'r.')
subplot(336); plot(t,s); title('s(t)'); axis([0 (N)*Tsym -1.5 1.5])

%differential line code
initialValue = 1;
differentialBits = zeros(size(bits));
differentialBits(1) = xor(initialValue,bits(1));
N=length(bits);
for i=2:N
    differentialBits(i) = xor(differentialBits(i-1),bits(i));
end
%decode for the sake of fun
decodedBits=xor(differentialBits,[initialValue differentialBits(1:N-1)]);
errors = bits - decodedBits %should be all zeros, indicating no errors
m=2*(differentialBits-0.5); %transform {0,1} to polar {-1,1}
p=ones(1,S); %NRZ pulse
m_upsampled=zeros(1,N*S); %allocate space and fill with zeros
m_upsampled(1:S:end)=m;
s=filter(p,1,m_upsampled); %convolve with p and discard last samples
subplot(337); ak_sampledsignalsplot(m,[],Tsym); xlabel(''); title('m_s(t)'); axis([0 (N)*Tsym -1.5 1.5])
ylabel('Differential')
subplot(338); plot(tp,[zeros(1,S) p zeros(1,S)]); axis([-Tsym 2*Tsym -1.5 1.5]); title('p(t)')
hold on, plot(0:Ts:Tsym-Ts,p,'r.')
subplot(339); plot(t,s); title('s(t)'); axis([0 (N)*Tsym -1.5 1.5])

writeEPS('linecodesmemory');


%plot PSDs
clear all
close all

Rb=6; %symbols (bits in this case) per second
Tsym=1/Rb; %symbol period
N=100;f=linspace(0,2*Rb,N);

thisSinc2 = sinc(f*Tsym).^2; %pre-calculate for efficiency
A=1; %pulse amplitude for 1 Watt signal
polar=A^2*Tsym*thisSinc2;
A=sqrt(2); %pulse amplitude for 1 Watt signal
unipolar=(1/4)*A^2*Tsym*thisSinc2;
clf
hold on
plot(f,polar,'b-x')
plot(f,unipolar,'r','linewidth',2)
T=0.5; ak_impulseplot(0.25,[],T,'color','r')
grid on
box on
xlabel('frequency (Hz)')
ylabel('Power Spectral Density (W/Hz)')
legend('Polar','Unipolar');
axis([-0.05 12 0 0.3])
writeEPS('psdlinecodes');

%Monte Carlo simulation to compare with theoretical expression
%generate polar NRZ signal
N=10000;
x=rand(1,N)>0.5;
x=2*(x-0.5);
oversampling=8;
p=ones(oversampling,1);
s=zeros(N*oversampling,1);
s(1:oversampling:end)=x;
s=filter(p,1,s);

%PSDs
clf
%Monte Carlo simulation to compare with theoretical
%expression for binary polar NRZ signal
Rb=6; %symbols (bits in this case) per second
Tsym=1/Rb; %symbol period
N=100000; %number of symbols
x=rand(1,N)>=0.5; %convert to 0 or 1 amplitudes
x=2*(x-0.5); %convert to -1 or 1 amplitudes
oversampling=8;
p=ones(oversampling,1);
s=zeros(N*oversampling,1);
s(1:oversampling:end)=x;
s=filter(p,1,s);
window=512; %window length
noverlap=window/2; %number of overlapping samples
fftsize=window; fs=oversampling*Rb;
%if you use below, the result if off by 3 dB:
%[P,f]=pwelch(s,window,noverlap,fftsize,fs,'onesided');
[P,f]=pwelch(s,window,noverlap,fftsize,fs,'twosided');
f=f(1:window/2); %f is from 0 to fs...
P=P(1:window/2); %keep only from 0 to fs/2
plot(f,10*log10(P),'r');
polar=1^2*Tsym*sinc(f*Tsym).^2; %theoretical expression
polardB = 10*log10(polar);
hold on, plot(f,polardB,'b-x')
xlabel('frequency (Hz)')
ylabel('PSD (dBW / Hz)')
axis([0 20 -50 0])
grid
legend('Simulated','Theoretical');
writeEPS('psdspolar');

%cyclostationary
snip_psd_cyclostationary %run the code to define the signals
clf
%mesh(alphao,fo,Sx);
mesh (alphao,fo, Sx, 'EdgeColor', 'interp');
%surfl(alphao,fo,Sx);
%view(-37.5,60);
view([-65.5 56]);
%title('SCD estimate');
xlabel('\alpha (Hz)');
ylabel('spectral freq. f (Hz)');
zlabel('SCD Sx');
writeEPS('cyclostationary_scd','font12Only');

clf
plot(alphao,cyclicProfile);
xlabel('cycle frequency \alpha (Hz)');
ylabel('Cyclic profile');
writeEPS('cyclostationary_cyclic_prefix','font12Only');