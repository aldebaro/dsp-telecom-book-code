GdB=[-0.5, 25, -0.8, -7, 30]; %gains in dB
NF=[0.5, 3, 0.8, 7, 5.5]; %noise figure (always in dB)
G=10.^(0.1*GdB); %gains in linear scale
F=10.^(0.1*NF); %noise factor (always in linear scale)
[Fcascade, Gcascade]=ak_friisCascadeNoiseFactor(F, G); %Friis equ.
GcascadedB = 10*log10(Gcascade) %convert back to dB
NFcascade = 10*log10(Fcascade) %convert to NF (in dB)
