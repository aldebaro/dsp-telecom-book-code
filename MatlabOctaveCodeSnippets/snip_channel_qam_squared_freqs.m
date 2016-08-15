fc=1e9; %nominal (transmitter's) carrier frequency in Hz (1 GHz)
freqOffset=-500/1e6*fc; %frequency offset (-500 ppm)
fIF = 130e6; %chosen intermediate frequency in Hz
fdelta = fIF+freqOffset; %frequency offset in MHz
%positive (negative freqs. not shown) center frequency of each term:
f_DC=0 %f0 in textbook: DC frequency term bandwidth 
fqam(1) = 2*fdelta %phase is 2 phi, where phi is the phase offset
fqam(2) = 4*fdelta %term of interest: phase is 4 phi
fqam(3)=2*fc-2*fdelta %phase is -2 phi
fqam(4)= 2*fc %phase is zero
fqam(5)=2*fc+2*fdelta %phase is 2 phi
fqam(6)=2*fc+4*fdelta %phase is 4 phi
fqam(7)= 4*fc %phase is zero
fqam(8)= 4*fc+2*fdelta %phase is 2 phi
fqam(9)= 4*fc+4*fdelta %phase is 4 phi
fqam(10)= 6*fc+2*fdelta %phase is 2 phi
fqam(11)= 6*fc+4*fdelta %phase is 4 phi
fqam(12)= 8*fc+4*fdelta %phase is 4 phi