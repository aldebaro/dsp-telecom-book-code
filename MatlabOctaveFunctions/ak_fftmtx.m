function [Ah, A] = ak_fftmtx(N, option)
% function [Ah, A] = ak_fftmtx(N, option)
%FFT direct Ah and inverse A matrices with 3 options for
%the normalization factors:
%1 (default) ->orthonormal matrices
%2->conventional discrete-time (DT) Fourier series
%3->used in Matlab/Octave, corresponds to samples of DTFT
%Example that gives the same result as Matlab/Octave:
% Ah=ak_fftmtx(4,3); x=[1:4]'; Ah*x, fft(x)
if nargin < 2
    option = 1; %the default is option=1
end
W = exp(-i*2*pi/N); %twiddle factor W_N
Ah=zeros(N,N); %pre-allocate space
for n=0:N-1 %create the matrix with twiddle factors
    for k=0:N-1
        Ah(k+1,n+1) = W^(n*k);
    end
end
switch option %choose among three different normalizations
    case 1 %orthonormal (also called unitary)
        Ah = Ah/sqrt(N);
        A = conj(Ah);
    case 2 %read X(k) in Volts in case x(n) is in Volts
        A = conj(Ah);
        Ah = Ah/N;
    case 3 %as in Matlab/Octave: Ah = Ah;
        A = conj(Ah)/N;
    otherwise
        error(['Invalid option value: ' num2str(option)]);
end