function [Sxx,alphas,omegas,SxxUnwrappedPhase]=ak_cyclicSpectrum(x,maxTau,P)
[Cxx,alphas]=ak_cyclicCorrelationEnsemble(x,P);
[alphaLength,tauLength]=size(Cxx);

omegas=2*pi*(-tauLength/2:(tauLength/2)-1)/tauLength; %in rad

%SxxUnwrappedPhase = transpose(unwrap(transpose(angle(Cxx))));
SxxUnwrappedPhase = angle(Cxx);

Sxx = (1/tauLength)*fft(Cxx,[],1);
Sxx = fftshift(Sxx,1);
SxxUnwrappedPhase = fftshift(SxxUnwrappedPhase,1);
if 1 %clean-up phase
    SxxMag=abs(Sxx);
    smallMagIndices = find(SxxMag<max(SxxMag(:))/1e2);
    SxxUnwrappedPhase(smallMagIndices)=0;
end

