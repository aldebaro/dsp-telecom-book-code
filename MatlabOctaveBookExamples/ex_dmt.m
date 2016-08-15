N=8 %number of FFT points
h=[2 1 0 3]; %channel impulse response
%bitloading is [1, 2, 3, 3, 2] bits per symbol
%1) Design constellations
M = 2; pamconstM2 = -(M-1):2:M-1; %2-PAM
M = 4; pamconstM4 = -(M-1):2:M-1; %4-PAM
M = 4; qamconstM4 = ak_qamSquareConstellation(M); %4-QAM
M = 8; qamconstM8 = ak_qamSquareConstellation(M); %8-QAM
%Bitstream is B={0 11 101 100 10}
X0 = pamconstM2(bin2dec('0')+1); %find the symbol
X1 = qamconstM4(bin2dec('11')+1);
X2 = qamconstM8(bin2dec('101')+1);
X3 = qamconstM8(bin2dec('100')+1);
X4 = pamconstM4(bin2dec('10')+1);
X5 = conj(X3);  %impose the Hermitian symmetry
X6 = conj(X2);
X7 = conj(X1);
%Compose DMT symbol to be modulated and transmitted:
Xk=[X0 X1 X2 X3 X4 X5 X6 X7]
L = 3; %length of cyclic prefix = channel dispersion
xn=ifft(Xk)*sqrt(N)  %adopt orthonormal FFT
xp=[xn(N-L+1:N) xn]  %add cyclic prefix (CP)
r=conv(xp,h) %transmit: convolve with channel response h
yn=r(L+1:L+N) %take CP out and keep N information samples
Yk=fft(yn)/sqrt(N)  %an orthonormal FFT has been adopted
Hk=fft(h,N);%channel frequency response with N-points FFT
Gk = 1 ./ Hk %frequency equalizer FEQ
Zk = Yk .* Gk  %decoded symbols
%discard negative frequencies and demodulate
b0 = dec2bin(ak_pamdemod(real(Zk(1)),2))
b1 = dec2bin(ak_qamdemod(Zk(2),4))
b2 = dec2bin(ak_qamdemod(Zk(3),8))
b3 = dec2bin(ak_qamdemod(Zk(4),8))
b4 = dec2bin(ak_pamdemod(real(Zk(5)),4))
receivedBitstream=[b0 ' ' b1 ' ' b2 ' ' b3 ' ' b4]
disp('Transmitted bitstream was B={0 11 101 100 10}')