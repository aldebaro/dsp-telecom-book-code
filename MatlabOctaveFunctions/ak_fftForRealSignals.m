function Xsplit=ak_fftForRealSignals(x)
% function Xsplit=ak_fftForRealSignals(x)
%Calculates the DFT of a real signal x with N samples
%using a N/2-points DFT. The result is equivalent to
%Xsplit=fft(x), but obtained with less computation.
N=length(x); %DFT size
temp=nextpow2(N);%check if power of 2
if N ~= 2^temp
    error('Number of input elements must be a power of 2')
end
N2 = N/2; %calculate spectrum using FFT of N/2 points
%pre-compute the constant factors
deltaW = 2*pi/N; %angular spacing between points
angles = deltaW*[0:N2-1]; %angles in rad
Ai = -cos(angles);
Ar = 1-sin(angles);
Bi = cos(angles);
Br = 1+sin(angles);
x1 = x(1:2:end); %organize the N-samples real vector ...
x2 = x(2:2:end); %into a N/2-samples complex vector
x = x1 + 1j*x2;
X = fft(x,N2); %calculate a N/2-points FFT
Xr = real(X);
Xi = imag(X);
Gr = zeros(N2,1); Gi = zeros(N2,1); %allocate space
%1) recover DC tone:
Gr(1) = (Xr(1)*Ar(1) - Xi(1)*Ai(1) + ...
    Xr(1)*Br(1) + Xi(1)*Bi(1))/2;
Gi(1) = (Xi(1)*Ar(1) + Xr(1)*Ai(1) + ...
    Xr(1)*Bi(1) - Xi(1)*Br(1))/2;
for k = 1:N2-1 %2) calculate for other points
    ki = k+1;
    Gr(ki) = (Xr(ki)*Ar(ki) - Xi(ki)*Ai(ki) + ...
        Xr(N2-k+1)*Br(ki) + Xi(N2-k+1)*Bi(ki))/2;
    Gi(ki) = (Xi(ki)*Ar(ki) + Xr(ki)*Ai(ki) + ...
        Xr(N2-k+1)*Bi(ki) - Xi(N2-k+1)*Br(ki))/2;
    Gr(2*N2-k+1) = Gr(ki);
    Gi(2*N2-k+1) = -Gi(ki);
end
%3) recover Nyquist tone: (the TI doc has a typo here)
Gr(N2+1) = Xr(1) - Xi(1);
Gi(N2+1) = 0;
Xsplit = Gr + 1j*Gi; %obtain the FFT final result
