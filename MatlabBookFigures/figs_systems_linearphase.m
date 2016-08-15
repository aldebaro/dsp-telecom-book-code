close all
N=50; N1=15; %is the period and N1 the duty cicle
N0=4; %system delay
k=0:N-1;
xn=[ones(1,N1) zeros(1,N-N1)]; %used by FFT and for the plot
Xk=fft(xn)/N; %calculate the DTFS of xn

%two cases
summedPhase = -2*pi/N*N0*k;
Yk=Xk.*exp(j*summedPhase);
yn=ifft(Yk)*N;
subplot(311), stem(xn)
xlabel('n'); ylabel('x[n]');
ak_add3dots
subplot(312), stem(real(summedPhase))
xlabel('k'); ylabel('phase');
ak_add3dots
subplot(313), stem(real(yn))
xlabel('n'); ylabel('y[n]');
axis([0 50 0 1.1])
ak_add3dots
max(abs(imag(yn))) %debugging purpose: check Hermitian symmetry
writeEPS('ex_linear_phase','font12Only');

%pause
%other case:
clf
summedPhase = -2*[0 ones(1,N/2-1) 0 -ones(1,N/2-1)]; %in rad
Yk=Xk.*exp(j*summedPhase);

yn=ifft(Yk)*N;
subplot(211), stem(real(summedPhase))
xlabel('k'); ylabel('phase');
ak_add3dots
subplot(212), stem(real(yn))
xlabel('n'); ylabel('y[n]');
ak_add3dots
max(abs(imag(yn))) %debugging purpose: check Hermitian symmetry
writeEPS('ex_nonlinear_phase','font12Only');