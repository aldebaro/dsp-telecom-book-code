if 0
N = 52;           % Filter order
F = [0.05 0.95];  % Frequency Vector
A = [1 1];        % Amplitude Vector
W = 1;            % Weight Vector
b  = firls(N, F, A, W, 'hilbert'); %design Hilbert filter

w=linspace(-pi,pi,100);
H=freqz(b,1,w);
subplot(311)
plot(w,abs(H));
ylabel('Magnitude');
axis tight
subplot(312)
plot(w,unwrap(angle(H))/pi*180);
ylabel('Phase (degrees)');
axis tight
subplot(313)
H2=H.*exp(j*(N/2)*w);
plot(w,angle(H2)/pi*180);
xlabel('\Omega (rad)');
ylabel('Removed linear phase');
axis tight
writeEPS('hilbertFilter')

subplot(211)
w=[-20 -4 1 4 4 20];
x=[0    0 1 1 0  0];
plot(w,x);
ylabel('|X_{ce}(\omega)|');
grid
subplot(212)
w=[0 10 15 18 18 20];
x=0.5*[0 0  1  1  0  0]; %note the 0.5 factor
w=[-fliplr(w) w];
x=[fliplr(x) x];
plot(w,x);
xlabel('\omega (rad/s)');
ylabel('|X_{QAM}(\omega)|');
grid
writeEPS('complexEnvelope')

clf
subplot(311)
f=[0 10 15 18 18 20];
x=[0 0  1  1  0  0];
f=[-fliplr(f) f];
x=[fliplr(x) x];
plot(f,x);
ylabel('|X_{QAM}(f)|');
grid
subplot(312)
f=[-20 10 15 18 18 20];
x=[0 0  1  1  0  0];
plot(f,x);
ylabel('|X_{+}(f)|');
grid
subplot(313)
f=[-20 -4 1 4 4 20];
x=[0    0 1 1 0  0];
plot(f,x);
ylabel('|X_{ce}(f)|');
grid
xlabel('f (Hz)');
writeEPS('analyticSignal')
end

clear all
close all
ex_qam_generation_via_symbols
ex_qam_demodulation
%Plot constellation:
plot(real(ys),imag(ys),'x','markersize',20); %received
hold on
plot(real(qamSymbols),imag(qamSymbols),'or'); %transmitted
axis equal; %make constellation on square
axis([-4 4 -4 4]) 
title('Transmitted (o) and received (x) constellations');
xlabel('Real part of QAM symbol m_i');
ylabel('Imaginary part of QAM symbol m_q');
writeEPS('qam_constellation2')

