N=80; %total number of samples used in the simulation
Np=8, Ns=50; %period of carrier and information signal, respectively
Ts=0.25; %sampling period in seconds
n=0:N-1; t=n*Ts; %abscissas in n and t, respectively
m=sin(2*pi/Ns*n); %information signal 
A=1.8; %DC level
x=(m+A).*cos(2*pi/Np*n); %AM signal
subplot(311)
plot(t,x), hold on, xlabel('time (s)'); ylabel('s(t)')
plot(t,m+A,'r','LineWidth',2), plot(t,-(m+A),'r','LineWidth',2)
subplot(312)
x_rectified=x; x_rectified(x<0)=0; %mimic a diode-based rectifier
plot(t,x_rectified), hold on, plot(t,m+A,'r','LineWidth',2)
xlabel('time (s)'); ylabel('s(t) rectified')
subplot(313) %now in discrete-time:
stem(n,abs(x)), hold on, plot(n,m+A,'r','LineWidth',2)
xlabel('sample (n)'); ylabel('s[n]')