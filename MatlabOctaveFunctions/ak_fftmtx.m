function [A, Ainverse] = ak_fftmtx(N, option)
%function [A, Ainverse] = ak_fftmtx(N, option)
% FFT direct A and inverse Ainverse matrices with 3
% options for the normalization factors:
% 1 (default) ->orthonormal matrices
% 2->conventional discrete-time (DT) Fourier series
% 3->used in Matlab/Octave's fft: gives samples of the DTFT
% Example that gives the same result as Matlab/Octave:
%  [A, Ainv]=ak_fftmtx(4,3); x=[1:4]'+1j; A*x, fft(x)
% and inverts to the original vector: Ainv*A*x
if nargin < 2
    option = 1; %the default is option=1
end
W = exp(-1i*2*pi/N); %twiddle factor W_N
A=zeros(N,N); %pre-allocate space
for n=0:N-1 %create the matrix with twiddle factors
    for k=0:N-1
        A(k+1,n+1) = W^(n*k);
    end
end
switch option %choose among three different normalizations
    %A is symmetric. The Hermitian A' can be obtained with conj(A)
    case 1 %orthonormal (also called unitary)
        A = A/sqrt(N);
        Ainverse = conj(A); % Hermitian
    case 2 %read X(k) in Volts in case x(n) is in Volts
        Ainverse = conj(A); % Hermitian
        A = A/N;
    case 3 %as in Matlab/Octave: A = A;
        Ainverse = conj(A)/N; % Hermitian / N
    otherwise
        error(['Invalid option value: ' num2str(option)]);
end