f0=50; %50 Hz
T0=1/f0;
t=linspace(0,3*T0,1000);

b0=exp(0*t);
subplot(211); plot(t,real(b0));
subplot(212); plot(t,imag(b0));
xlabel('t (seconds)')
writeEPS('complexexponential0')

b1=exp(j*2*pi*f0*t);
subplot(211); plot(t,real(b1));
subplot(212); plot(t,imag(b1));
xlabel('t (seconds)')
writeEPS('complexexponential1')

b2=exp(j*2*pi*2*f0*t);
subplot(211); plot(t,real(b2));
subplot(212); plot(t,imag(b2));
xlabel('t (seconds)')
writeEPS('complexexponential2')

b3=exp(-j*2*pi*2*f0*t);
subplot(211); plot(t,real(b3));
subplot(212); plot(t,imag(b3));
xlabel('t (seconds)')
writeEPS('complexexponential3')

%DTFS explanation
N=12; %period in samples
Ah=ak_fftmtx(N,2); %DFT matrix with normalization as in DTFS
n=0:N-1; %abscissa
A=10, x=A*cos(pi/6*n + pi/3); %generate cosine with amplitude 10 V
X=Ah*transpose(x);
k=0:N-1;
subplot(211); stem(k,abs(X)); ylabel('|X[k]| (V)')
subplot(212); hObj=stem(k,angle(X));
%unfortunately cannot use makedatatip with stem
%makedatatip(hObj,[1 11]);
text(1,2,'\pi/3')
text(11,-2,'-\pi/3')
xlabel('k'); ylabel('Phase of X[k] (rad)')
writeEPS('dtfs_example')

k=-N/2:N/2-1;
X(abs(X)<1e-12)=0;
X=fftshift(X);
subplot(211); stem(k,abs(X)); ylabel('|X[k]| (V)')
subplot(212); hObj=stem(k,angle(X));
%unfortunately cannot use makedatatip with stem
%makedatatip(hObj,[1 11]);
text(1,1.5,'\pi/3')
text(-1,-1.5,'-\pi/3')
xlabel('k'); ylabel('Phase of X[k] (rad)')
writeEPS('fftshift_example')

X = [X; X; X];
k = -18:17;
subplot(211); stem(k,abs(X)); ylabel('|X[k]| (V)')
ak_add3dots
subplot(212); stem(k,angle(X)); xlabel('k'); ylabel('Phase of X[k] (rad)')
ak_add3dots
writeEPS('complete_dtfs')

%x(t)=4 + 10\cos(2 \pi 50 t + 2) + 4\sin(2 \pi 150 t - 1)$
%coefficients are $c_0 = 4$, $c_1=5e^{j2}$, $c_3=2e^{-j(1+\pi/2)}$,
%$c_{-1}=5e^{-j2}$, $c_{-3}=2e^{j(1+\pi/2)}$. 
clf
c0=4;
c1=5*exp(j*2);
c3=2*exp(-j*(1+pi/2));
ck=[0 0 conj(c3) 0 conj(c1) c0 c1 0 c3 0 0];
subplot(211); stem(-5:5,abs(ck)); grid
ylabel('|c_k|')
ak_add3dots
subplot(212); stem(-5:5,angle(ck)); grid
ylabel('phase(c_k)')
ak_add3dots
xlabel('k')
writeEPS('simplespectrum')

clf
c0=4;
c1=2*5*exp(j*2);
c3=2*2*exp(-j*(1+pi/2));
ck=[c0 c1 0 c3 0 0];
subplot(211); stem(0:5,abs(ck));
ylabel('|c_k|')
ak_add3dots
subplot(212); stem(0:5,angle(ck));
ylabel('phase(c_k)')
ak_add3dots
xlabel('k')
writeEPS('unilateralsimplespectrum')

%conversion continuous => discrete 
clf
%spectrum in continuous-time 
x1=[zeros(1,40) 3 3 (3:10) 10];
x2=fliplr(x1);
x=[x1 x2];
f=linspace(-30,30,length(x)); %Hz
subplot(211); plot1=plot(f,x);
makedatatip(plot1,62);
axis([-80 80 0 12])
xlabel('f (Hz)');
ylabel('X(f)');
ak_add3dots
%spectrum in discrete-time 
%plot base-band
fs=60; x=fs*x; %scale the amplitude
w=linspace(-pi,pi,length(x));
subplot(212); plot2=plot(w,x); hold on
makedatatip(plot2,62);
plot(2*pi+w,x);
plot(-2*pi+w,x);
axis([-10 10 0 602])
xlabel('\Omega (rad)');
ylabel('X(e^{j\Omega})');
ak_add3dots
writeEPS('continuousdiscretespectra')

%calculating the DTFT via DFT
clear all
clf
N=20; %DFT size
N1=5; %num. non-zero samples in the (aperiodic) pulse
x=[ones(1,N1) zeros(1,N-N1)]; %signal x[n]
N2=512; %num. samples of the DTFT theoretical expression
k=0:N2-1; %indices of freq. components
wk = k*2*pi/N2; %angular frequencies
Xk_fft = fft(x); %use N-point DFT to sample DTFT
Xk_theory=(sin(wk*N1/2)./sin(wk/2)).*exp(-j*wk*(N1-1)/2);
Xk_theory(1) = N1; %take care of 0/0 (NaN) at k=0
subplot(211); stem(2*pi*(0:N-1)/N,abs(Xk_fft));
hold on, plot(wk,abs(Xk_theory),'r');
ylabel('|X[k]|');
subplot(212); stem(2*pi*(0:N-1)/N,angle(Xk_fft));
hold on, plot(wk,angle(Xk_theory),'r');
ylabel('phase X[k] (rad)');
xlabel('\Omega (rad)');
legend('DFT','DTFT')
writeEPS('dtft_via_dft','font12Only');

clf
n=0:N-1;
subplot(211)
stem(n,x);
hold on
stem(n-N,zeros(size(x)));
ak_add3dots
subplot(212)
stem(n,x);
hold on
stem(n+N,x,'r');
stem(n-N,x,'r');
stem([-N-2 -N-2 -N-1],[0 0 0]);
xlabel('n');
ak_add3dots
writeEPS('pulse_and_repetition','font12Only');

clf
M=5; %num. non-zero samples in a period
x=[ones(1,M) zeros(1,32-M)]; %signal x[n]
N=256; %num. of DFT points
k=0:N-1; %indices of freq. components
Xk_fft = fft(x,N);
subplot(211); stem(k,abs(Xk_fft));
ylabel('|X[k]|');
subplot(212); stem(k,angle(Xk_fft));
ylabel('phase (rad)');
xlabel('k');
writeEPS('N256dtft_via_dft','font12Only');

clf
freqz(x)
writeEPS('dtft_via_freqz');

clf
N=512;
Xk_fft = fft(x,2*N); %want only positive freqs.
Xk_fft = Xk_fft(1:N); %discard negative freqs.
wk=(0:N-1)*(2*pi/(2*N)); %positive freq. grid
subplot(211); plot(wk,20*log10(abs(Xk_fft)));
grid; ylabel('|X[k]| (dB)');
subplot(212); plot(wk,angle(Xk_fft)*180/pi);
grid; ylabel('phase (degrees)');
xlabel('\Omega (rad)');
writeEPS('replicate_freqz');

%pairs
clf
A=8;
T0=1/50;
x0=zeros(1,100);
x1=A*ones(1,100);
x=[x1 x0 x1 x0 x1 x0 x1 x0];
t=linspace(-2*T0,3*T0,length(x));
subplot(211); plot(t,x);
subplot(212);
n=-10:10;
ck=((-1).^n) .* (A./(pi*(2*n+1)))
stem(n,ck);
subplot(211); axis([-0.04 0.04 -1 9])
writeEPS('squarewavespectrum')