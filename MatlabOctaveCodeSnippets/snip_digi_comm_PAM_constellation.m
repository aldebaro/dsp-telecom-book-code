M=4 %modulation order
canonicalPAMSymbols = -(M-1):2:M-1 %original, Delta = 2
cx = canonicalPAMSymbols/2; %intermediate result, Delta=1
cx = 8 * cx %convert to the specified Delta=8
originalEnergy = mean(abs(canonicalPAMSymbols).^2);
cy = canonicalPAMSymbols / sqrt(originalEnergy); %Ec = 1
cy = sqrt(20) * cy %convert to the specified Ec=20 J

