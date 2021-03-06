GdB=[30 20]; %gains in dB
NF=[2 5]; %noise figures (NFs)
Pin_s_dBm = -60; %in dBm (absolute power value)
PSDin_t_dBmHz = -174; %in dBm/Hz (PSD value)
PSDin_t = 10^(0.1*PSDin_t_dBmHz); %in linear scale
G=10.^(0.1*GdB); %gains in linear scale
F=10.^(0.1*NF); %noise factor (linear scale)
[Fcascade, Gcascade]=ak_friisCascadeNoiseFactor(F, G); %equivalent
GcascadedB = 10*log10(Gcascade) %gain of cascade in dB
NFcascade = 10*log10(Fcascade) %cascade NF
Pout_s_dBm = Pin_s_dBm + GcascadedB %in dBm
PSDout_t = Gcascade * Fcascade * PSDin_t; %linear scale
PSDout_n_dBmHz = 10*log10(PSDout_t) %dBm/Hz, PSD 