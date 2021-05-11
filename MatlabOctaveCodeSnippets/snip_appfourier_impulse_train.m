%% Discrete-time 
%See, e.g., https://dsp.stackexchange.com/questions/35571/equation-for-impulse-train-as-sum-of-complex-exponentials
N=8; %period
M=50; %samples
x=zeros(1,M); %pre-allocate space
n=0:M-1;
for k=0:N-1 %add all complex exponentials
    x = x + exp(1j*2*pi*k*n/N); %add new complex exponential
end
subplot(211), stem(n,real(x))
title('Real part of impulse train');
subplot(212), plot(n,imag(x)) %plot
xlabel('discrete-time n')
title(['Imaginary part: only numerical errors']);

%% Continuous-time
N=10000; %2*N-1 is the number of points in frequency grid (abscissa)
M=5000; %number of complex exponentials
T0=0.2; %symbol interval in seconds
f=linspace(0,15,N); f=[-fliplr(f(2:end)) f]; %create frequency axis
x=zeros(1,2*N-1); %pre-allocate space
for l=-M:M %add all complex exponentials
    x = x + exp(-1j*2*pi*l*T0*f); %add new complex exponential
end
x=x/T0
subplot(211), plot(f,real(x))
title('Real part: spacing is 1/T0=5 Hz');
subplot(212), plot(f,imag(x)) %plot
xlabel('f (Hz)')
title(['Imaginary part: only numerical errors']);