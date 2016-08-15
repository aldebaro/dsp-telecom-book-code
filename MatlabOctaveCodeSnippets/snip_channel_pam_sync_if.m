BWpam = 0.2; %signal bandwidth in MHz (200 kHz)
fc = 900; %carrier frequency in MHz (900 MHz)
fmax = 40/1e6*fc; %maximum absolute frequency offset in MHz (40 ppm)
fIFmin = fmax + BWpam %minimum intermediate frequency
fIFmax = 0.5*(fc - BWpam) - fmax %maximum intermediate frequency