G=[200 20]; F=[3 4]; %gains and noise factors (linear scale)
%G=[20 200]; F=[4 3]; %gains and noise factors (alternative order)
[Fcascade, Gcascade]=ak_friisCascadeNoiseFactor(F, G) %equivalent
Pin_s = 100; %power of signal of interest at input
Pin_t = 2; %input thermal noise power
Pout_s = Pin_s * Gcascade %power of signal of interest at output
Pout_t = Gcascade * Fcascade * Pin_t %noise power by cascade
Gcascade_dB = 10*log10(Gcascade)
NFcascade = 10*log10(Fcascade)
SNRin_dB = 10*log10(Pin_s/Pin_t)
SNRout_dB = SNRin_dB - NFcascade