function y=ak_interpolationInFreqDomain(x,P)
% function y=ak_interpolationInFreqDomain(x,P)
%  Inputs: x - signal to be interpolated
%          P - interpolation factor
%Obs: similar to function interpft in Matlab / Octave
x=x(:); %make it a column vector
if P<2
	error('P must be an integer greater than 2');
end
N=length(x);
if rem(N,2)~=0 %supports only even N
	error('N must be even');
end
X=fft(x); %go to frequency domain
Y=zeros(P*N,1);
Y(1:N/2+1)=X(1:N/2+1); %positive angles, include Nyquist
Y(P*N-N/2+2:P*N)=X(N/2+2:N); %negative angles, do not include Nyquist
Y(P*N-N/2+1)=conj(X(N/2+1)); %conjugate Nyquist freq. (it is real for real x)
y=P*ifft(Y); %scale by P
if isreal(x)
	y = real(y); %fix numerical errors
end
