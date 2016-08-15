function figs_transforms_dtfs_pulse
close all

N=20; N1=10; %is the period and N1 the duty cicle
plotPulseDTFSWithPhase(N, N1);
writeEPS('dtfs_pulse','font12Only');

N=20; N1=1; %is the period and N1 the duty cicle
plotPulseDTFS(N, N1);
writeEPS('dtfs_pulse_duty_1','font12Only');

N=20; N1=2; %is the period and N1 the duty cicle
plotPulseDTFS(N, N1);
writeEPS('dtfs_pulse_duty_2','font12Only');

N=20; N1=3; %is the period and N1 the duty cicle
plotPulseDTFS(N, N1);
writeEPS('dtfs_pulse_duty_3','font12Only');

N=20; N1=4; %is the period and N1 the duty cicle
plotPulseDTFS(N, N1);
writeEPS('dtfs_pulse_duty_4','font12Only');

end

function plotPulseDTFS(N, N1)
clf
xn=[ones(1,N1) zeros(1,N-N1)]; %used by FFT and for the plot
if 1
    k=0:N-1;
    Xk=(1/N)*(sin(k*N1*pi/N)./sin(k*pi/N)).*exp(-j*k*pi/N*(N1-1));
    Xk(1)=N1/N;
else
    Xk=fft(xn)/N;
end

xnall = [xn xn xn];
Xkall = [Xk Xk Xk];
subplot(211)
stem(0:3*N-1,xnall,'o')
xlabel('n'), ylabel('x[n] (V)')
ak_add3dots
%subplot(212), plot(0:3*N-1,abs(Xkall),'o')
subplot(212), stem(0:3*N-1,abs(Xkall))
hold on, plot(0:3*N-1,abs(Xkall),':r') %it became ugly
%axis([0 60 0 0.5])
ak_add3dots
xlabel('k'), ylabel('|X[k]| (V)')
end

function plotPulseDTFSWithPhase(N, N1)
clf
xn=[ones(1,N1) zeros(1,N-N1)]; %used by FFT and for the plot
if 1
    k=0:N-1;
    Xk=(1/N)*(sin(k*N1*pi/N)./sin(k*pi/N)).*exp(-j*k*pi/N*(N1-1));
    Xk(1)=N1/N;
else
    Xk=fft(xn)/N;
end

xnall = [xn xn xn];
Xkall = [Xk Xk Xk];
subplot(311)
stem(0:3*N-1,xnall)
xlabel('n'), ylabel('x[n] (V)')
ak_add3dots
subplot(312), stem(0:3*N-1,abs(Xkall))
%hold on, plot(0:3*N-1,abs(Xkall),':r') %it became ugly
if 1 %just to beautify when N=20 and N1=10
    axis([0 60 0 0.5])
end
ak_add3dots
xlabel('k'), ylabel('|X[k]| (V)')
subplot(313), stem(0:3*N-1,angle(Xkall))
%subplot(313), stem(0:3*N-1,unwrap(angle(Xkall)))
xlabel('k'), ylabel('angle(X[k]), (rad)')
ak_add3dots
end