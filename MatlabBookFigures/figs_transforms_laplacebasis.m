clear all
clf
sigma = 0.3; w = 2*pi*5; %frequency of 5 Hz
s=sigma+j*w; %define the complex variable s
t=linspace(0,3,1000); %interval from [0, 3] sec.
x=exp(s*t); %the signal
envelope = exp(sigma*t); %the signal envelope

subplot(121); plot(t,real(x));
hold on
plot(t,envelope,':r');
%plot(t,t,'k');
ylabel('Real\{e^{(0.3+j10 \pi) t}\}');
xlabel('t (s)');

sigma = -0.3; w = 2*pi*5; %frequency of 5 Hz
s=sigma+j*w; %define the complex variable s
x=exp(s*t);
envelope = exp(sigma*t);
subplot(122); plot(t,real(x));
hold on
plot(t,envelope,':r');
xlabel('t (s)');
ylabel('Real\{e^{(-0.3+j10 \pi) t}\}');
legend('e^{st}','e^{\sigma t}')

writeEPS('laplace_basis');