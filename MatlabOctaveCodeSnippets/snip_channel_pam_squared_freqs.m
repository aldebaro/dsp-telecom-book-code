BWpam = 0.2; %signal bandwidth in MHz (200 kHz)
fc = 900; %carrier frequency in MHz (900 MHz)
fdelta = 0.027; %frequency offset in MHz (27 kHz)
squaredBW = 2*BWpam; %BW expands by 2 after squaring
%positive (negative freqs. not shown) center frequency of each term:
f_DC=0+[-squaredBW, squaredBW] %DC frequency term bandwidth
f_2wc=2*fc+[-squaredBW, squaredBW] %two times carrier frequency term
f_2wcwoffset = 2*(fc+fdelta)+[-squaredBW, squaredBW] %3rd term
f_4wcwoffset = 4*fc+fdelta+[-squaredBW, squaredBW] %4th term
f_2woffset = 2*fdelta+[-squaredBW, squaredBW] %term of interest
