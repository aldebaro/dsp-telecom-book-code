if 1 %choose between two options
    f0 = 980;   %frequency of first sinusoid (in telecom, of bit 0)
    f1 = 1180;   %frequency of 2nd sinusoid (in telecom, of bit 1)
else %another example
    f0 = 1650; %1st sinusoid
    f1 = 1850; %2nd sinusoid
end
Fs=9600; %assumed sampling frequency
sumSinusoidFrequency = f0+f1;
subractSinusoidFrequency = f1-f0;
%reduce numbers to rational forms
[m,n]=rat(sumSinusoidFrequency/Fs)
[p,q]=rat(subractSinusoidFrequency/Fs)
Nmin = lcm(n,q) %find the least commom multiple
disp(['Minimum common period: ' num2str(Nmin)])
T_duration = Nmin / Fs; %minimum number of samples in seconds
%disp(['Maximum symbol rate: ' num2str(1/T_symbolDuration) ' bauds'])
%% Check if the product of the two sinusoids is really orthogonal
Tsum = 1 / sumSinusoidFrequency;
Tsub = 1 / subractSinusoidFrequency;
disp('Numbers below should be integers:')
T_duration/Tsum
T_duration/Tsub
Ts=1/Fs; %sampling interval
t = 0:Ts:T_duration-Ts; %generate (discrete) time
%use sin or cos with arbitrary phase
b0 = sin(2*pi*f0*t+4)';  %column vector
b1 = sin(2*pi*f1*t)';  %column vector
normalizedInnerProduct = sum(b0.*b1) / length(b0) %inner product
if (normalizedInnerProduct > 1e-13)
    error('not orthogonal! should not happen!');
end