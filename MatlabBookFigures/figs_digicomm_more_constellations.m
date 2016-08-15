clf
subplot(221)
b=3; M=2^b; plot(qammod(0:M-1,M),'x','markersize',12),grid
title('a)'), axis equal, axis tight
subplot(222)
b=5; M=2^b; plot(qammod(0:M-1,M),'x','markersize',12),grid
title('b)'), axis equal, axis tight
subplot(223)
b=7; M=2^b; plot(qammod(0:M-1,M),'x','markersize',12),grid
title('c)'), axis equal, axis tight
subplot(224)
b=9; M=2^b; plot(qammod(0:M-1,M),'x','markersize',12),grid
title('d)'), axis equal, axis tight
writeEPS('crossConstellations')

clf
subplot(221)
b=2; M=2^b; plot(pskmod(0:M-1,M),'x','markersize',12),grid
axis equal, title('a)'), axis tight
subplot(222)
b=3; M=2^b; plot(pskmod(0:M-1,M),'x','markersize',12),grid
title('b)'), axis equal, axis tight
subplot(223)
b=4; M=2^b; plot(pskmod(0:M-1,M),'x','markersize',12),grid
title('c)'), axis equal, axis tight
subplot(224)
b=5; M=2^b; plot(pskmod(0:M-1,M),'x','markersize',12),grid
title('d)'), axis equal, axis tight
writeEPS('pskConstellations')

clf
d_over_2sigma = linspace(1,3,20);
M=2; Pe_PAM2 = 2*(1-1/M)*ak_qfunc(d_over_2sigma);
M=4; Pe_PAM4 = 2*(1-1/M)*ak_qfunc(d_over_2sigma);
M=64; Pe_PAM64 = 2*(1-1/M)*ak_qfunc(d_over_2sigma);
semilogy(d_over_2sigma, Pe_PAM2, '.-', ...
    d_over_2sigma, Pe_PAM4, 'x-', ...
    d_over_2sigma, Pe_PAM64, '--')
legend('2-PAM','4-PAM','64-PAM')
xlabel('d/(2 \sigma)')
ylabel('Pe')
grid
writeEPS('pe_severalPAM')

clf
M=2; SNR_PAM2 = 10*log10 ((M^2-1)*d_over_2sigma.^2/3);
M=4; SNR_PAM4 = 10*log10 ((M^2-1)*d_over_2sigma.^2/3);
M=64; SNR_PAM64 = 10*log10 ((M^2-1)*d_over_2sigma.^2/3);

semilogy(SNR_PAM2, Pe_PAM2,  '.-', ...
    SNR_PAM4, Pe_PAM4,  'x-', ...
    SNR_PAM64, Pe_PAM64, '--')
legend('2-PAM','4-PAM','64-PAM')
xlabel('SNR (dB)')
ylabel('Pe')
grid
writeEPS('pe_severalPAM_SNR')

