function  Spec = cps_w(y,x,alpha,nfft,Noverlap,Window,opt,P)     
% Spec = CPS_W(y,x,alpha,nfft,Noverlap,Window,opt) 
% Welch's estimate of the (Cross) Cyclic Power Spectrum of signals y 
% and x at cyclic frequency alpha:  
% opt = 'sym' : symmetric version E{Y(f+alpha/2)X*(f-alpha/2)}/W
% opt = 'asym': asymmetric version E{Y(f)X*(f-alpha)}/W
% (f and alpha are normalized by the sampling frequency and constrained to take values between 0 and 1)
% x and y are divided into K overlapping blocks (Noverlap taps), each of which is
% detrended, windowed and zero-padded to length nfft. Input arguments nfft, Noverlap, and Window
% are as in function 'PSD' or 'PWELCH' of Matlab. Denoting by Nwind the window length, it is recommended to use 
% nfft = 2*NWind and Noverlap = 2/3*Nwind with a hanning window or Noverlap = 1/2*Nwind with a half-sine window.
% Note: use analytic signal to avoid correlation between + and - frequencies
%
% -------
% Outputs
% -------
% Spec is a structure organized as follows:
%                   Spec.S = Cyclic Power Spectrum vector
%                   Spec.f = vector of normalized frequencies
%                   Spec.K = number of blocks
%                   Spec.Var_Reduc = Variance Reduction factor
%
%                   Spec = CPS_W(y,x,...,P) where P is a scalar between 0 and 1, 
%                   also returns Spec.CI the P*100% confidence interval for Spec.S
%                   (requires function 'chi2inv' of the statistical toolbox of Matlab)
%
% --------------------------
% Reference: J. Antoni, "Cyclic Spectral Analysis in Practice", Mechanical Systems and Signal Processing, Volume 21, Issue 2, February 2007, Pages 597-630.
% --------------------------
% Author: J. Antoni
% Last Revision: 12-2014
% --------------------------

if length(Window) == 1
    Window = hanning(Window);
end
Window = Window(:);
n = length(x);          % Number of data points
nwind = length(Window); % length of window

% check inputs
if (alpha>1||alpha<0),error('alpha must be in [0,1] !!'),end
if nwind <= Noverlap,error('Window length must be > Noverlap');end
if nfft < nwind,error('Window length must be <= nfft');end
if nargin > 7 && (P>=1 || P<=0),error('P must be in ]0,1[ !!'),end

y = y(:);
x = x(:);		
K = fix((n-Noverlap)/(nwind-Noverlap));	% Number of windows
if K==0
    error('Maybe signal is too short! K==0')
end

% compute CPS
index = 1:nwind;
f = (0:nfft-1)/nfft;
t = (0:n-1)';
CPS = 0;
if strcmp(opt,'sym') == 1
    y = y.*exp(-1i*pi*alpha*t);
    x = x.*exp(1i*pi*alpha*t);
else
    x = x.*exp(2i*pi*alpha*t);
end

for i=1:K
    xw = Window.*x(index);
    yw = Window.*y(index);
    Yw1 = fft(yw,nfft);		% Yw(f+a/2) or Yw(f)
    Xw2 = fft(xw,nfft);		% Xw(f-a/2) or Xw(f-a)
    CPS = Yw1.*conj(Xw2) + CPS;
    index = index + (nwind - Noverlap);
end

% normalize
KMU = K*norm(Window)^2;	% Normalizing scale factor ==> asymptotically unbiased
CPS = CPS/KMU;   

% variance reduction factor
Window = Window(:)/norm(Window);
Delta = nwind - Noverlap;
R2w = xcorr(Window);
k = nwind+Delta:Delta:min(2*nwind-1,nwind+Delta*(K-1));
if length(k) >1
    Var_Reduc = R2w(nwind)^2/K + 2/K*(1-(1:length(k))/K)*(R2w(k).^2);
else
    Var_Reduc = R2w(nwind)^2/K;
end

% confiance interval
if nargin > 7
    v = 2/Var_Reduc;
    alpha = 1 - P;
    if alpha == 0		% Sa ~ Chi2
        temp = 1./chi2inv([1-alpha/2 alpha/2],round(v));
        CI = v*CPS*temp;
    else				    % Sa ~ Normal
        Sy = CPS_W(y,y,0,nfft,Noverlap,Window,opt);
        Sx = CPS_W(x,x,0,nfft,Noverlap,Window,opt);
        Var_Sa = Sy.S.*Sx.S/v;
        temp = sqrt(2)*erfinv(2*P-1);
        CI = CPS*[1 1] + temp*sqrt(Var_Sa(:))*[1 -1];
    end
end

% set up output parameters
if nargout == 0
    figure,newplot;
    plot(f,10*log10(abs(CPS))),grid on
    xlabel('[Hz]'),title('Spectral Correlation Density (dB)')
else
    Spec.S = CPS;
    Spec.f = f;
    Spec.K = K;
    Spec.Var_Reduc = Var_Reduc;
    if nargin > 7 
        Spec.CI = CI;
    end
end