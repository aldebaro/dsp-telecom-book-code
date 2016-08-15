function [Cxx,alphas,lags]=ak_cyclicCorrelation(x,maxLag,P)
% function [Cxx,alphas,lags]=ak_cyclicCorrelation(x,maxLag,P)
%Also called cyclic autocorrelation function (ACF). Assumes it is
%ergodic in the autocorrelation and uses one single realization.
%Cxx[alpha, lag] stores cycles per row and lags per column.
M=length(x);
if M<maxLag
    error('M<maxTau')
end
%if P<maxTau
%    error('P<maxTau')
%end
if rem(P,2)==1
    P=P+1; %force P to be an even number such that P/2 is an integer
end
Cxx=zeros(P,2*maxLag+1);
%calculate products
% one should not average over
% lags that are far away from the origin (say ) because
% the accuracy of the corresponding sample cyclic correlations
% decreases due to reduced averaging [c.f. (15)].
x=transpose(x(:)); %row vector
X=zeros(P,M); %pre-allocate space for "realizations"
for tau=0:maxLag %in case wants to include tau=0
    %for tau=1:maxTau %do not want tau=0
    xx = x(1:end-tau) .* conj(x(tau+1:end));
    N = length(xx);
    X(1:N,tau+1)=xx; %organize as "realizations", later
    %calculate FFT for each column (lag), over time n, to find alpha
    n=0:N-1;
    positiveTauCol=maxLag+1+tau;  %first column for -maxTau, column maxTau+1 is for tau=0
    negativeTauCol=maxLag+1-tau;
    for k=0:P-1;
        thisAngle=k*(2*pi)/P;
        kRow=k+1;
        Cxx(kRow,positiveTauCol)=(1/N)*sum(xx .* exp(-1j*thisAngle*n)); %positive tau
        Cxx(kRow,negativeTauCol)=conj(Cxx(kRow,positiveTauCol))*exp(1j*thisAngle*tau);
    end
end
Cxx=fftshift(Cxx,1);
Cxx=conj(Cxx); %AK-TODO. Not sure. Need to better study the equations
if 0
    %Alternative way is to use FFT. But in this case, the cycle grid
    %may have low resolution while the number of points M is larger
    %Calculate FFT for each column (lag), over time n, to find alpha:
    Cxx2 = (1/N)*fft(X);
    Cxx2 = fftshift(Cxx2,1);
    mesh(abs(Cxx2))
end

alphas=2*pi*(-P/2:(P/2)-1)/P; %in rad
lags=-maxLag:maxLag;
if nargout==0
    if 1
        subplot(211)
        mesh(lags,alphas,abs(Cxx));
        subplot(212)
        mesh(lags,alphas,angle(Cxx));
    else
        subplot(211)
        imagesc(lags,alphas,abs(Cxx));
        subplot(212)
        imagesc(lags,alphas,angle(Cxx));
    end
    subplot(211), xlabel('lag'); ylabel('cycle \alpha'); zlabel('|Cx|')
    title('ACF magnitude')
    subplot(212), xlabel('lag'); ylabel('cycle \alpha'); zlabel(' Cx phase')
    title('ACF phase')
    %ylabel('\tau (samples)'); xlabel('\alpha (rad)')
end