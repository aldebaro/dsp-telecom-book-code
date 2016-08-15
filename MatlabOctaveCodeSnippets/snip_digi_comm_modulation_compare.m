Pb=1e-6; %target bit error probability
b=2:2:8; %range of bits per symbol
M=2.^b; %number of symbols
qarg = Pb*b./(4*(1-1./sqrt(M))); %argument of Q^{-1}
gap = 1/3 * ak_qfuncinv(qarg).^2; %gap to capacity
EbN0_qam = gap .* (2.^b -1) ./ b; %for QAM
EbN0_psk = (ak_qfuncinv(qarg).^2)./(2*b.*(sin(pi./M)).^2);
EbN0_qam_dB = 10*log10(EbN0_qam); %in dB
EbN0_psk_dB = 10*log10(EbN0_psk); %in dB
EbN0_binary = 10*log10((ak_qfuncinv(Pb)^2)/2); %for BPSK
b=[1 b]; %pre-append the result for BPSK (or binary PAM)
EbN0_psk_dB = [EbN0_binary EbN0_psk_dB];
EbN0_qam_dB = [EbN0_binary EbN0_qam_dB];
EbN0_shannon_dB = 10*log10((2.^b -1) ./ b); %Shannon limit
plot(b,EbN0_qam_dB,b,EbN0_psk_dB,b,EbN0_shannon_dB);

