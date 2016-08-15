N=10000; %2*N-1 is the number of points in frequency grid (abscissa)
M=5000; %number of complex exponentials
Tsym=0.2; %symbol interval in seconds
f=linspace(0,15,N); f=[-fliplr(f(2:end)) f]; %create frequency axis
x=zeros(1,2*N-1); %pre-allocate space
for l=-M:M %add all complex exponentials
    x = x + exp(-1j*2*pi*l*Tsym*f); %add new complex exponential
end
subplot(211), plot(f,real(x))
title('Real part: spacing is 1/Tsym=5 Hz and "areas"=2*M+1=1001');
subplot(212), plot(f,imag(x)) %plot
xlabel('f (Hz)')
title(['Imaginary part: only ' ...
    'numerical errors (spectrum is real-valued)']);