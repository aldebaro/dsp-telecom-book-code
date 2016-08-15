function Bmin = ak_forceStableMinimumPhase(B, tol)
% function Bmin = ak_forceStableMinimumPhase(B, tol)
% B has the real coefficients of a FIR filter, which are
%the same as its impulse response samples.
% Bmin is a minimum-phase version of B, with the same mag.
if nargin == 1 %tolerance for closeness to unity circle:
    tol = 1e-3; %tol = eps;
end
B_roots = roots(B); %find the roots of B(z), its zeros
B_roots_abs = abs(B_roots); %magnitude of roots
outsideCircle = find (B_roots_abs > 1); %outside |z|=1 ?
%no need to use conjugate in case we assume B is real
%and complex roots appear in conjugate pairs, but will
%adopt it here:
B_roots(outsideCircle)=1./conj(B_roots(outsideCircle));
B_roots_abs = abs(B_roots); %recalculate magnitudes
onCircle = find ( abs(B_roots_abs - 1) < tol); %on |z|=1 ?
%move all roots on unit circle to 1-tol (keep the angle)
B_roots(onCircle)=(1-tol)*exp(j*angle(B_roots(onCircle)));
Bmin = poly(B_roots); %compose polynomial
Bmin = sqrt(sum(B.^2)/sum(Bmin.^2)) * Bmin; %equalize
Bmin = real(Bmin); %combat numeric errors on coefficients