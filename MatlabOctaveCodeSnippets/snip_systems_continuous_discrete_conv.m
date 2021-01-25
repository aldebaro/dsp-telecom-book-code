T0=0.2; %pulse "duty cycle" (interval with non-zero amplitude): 0.2 s
Ts=2e-3; %sampling interval: 2 ms
N=T0/Ts; %number of samples to represent the pulse "duty cycle"
A=4; %pulse amplitude: 4 Volts
pulse=A*[zeros(1,N) ones(1,N) zeros(1,4*N)]; %pulse
triangle=Ts*conv(pulse,pulse); %(approximated) continuous convolution
disp(['Convolution peak at ' num2str(T0) ' is ' num2str(A^2*T0)])
myaxis=[-0.2 0.6 -1 5]; %show this interval
subplot(211);
t=Ts*((0:length(pulse)-1)-N+1); %time axis, create "negative" time
plot(t,pulse);
ylabel('p(t)');
axis(myaxis)
title('Pulse')
subplot(212);
t=Ts*((0:length(triangle)-1)-2*N+1);
h=plot(t,triangle);
ylabel('p(t)*p(t)');
datatip(h,0.2, 3.2) %indicate the peak
xlabel('time (s)')
axis(myaxis)
title('Convolution')