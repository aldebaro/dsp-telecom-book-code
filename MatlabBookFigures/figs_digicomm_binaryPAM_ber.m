randn('state',0); rand('state',0);%reset random generators
M=16; %modulation order
numSymbols = 40000; % number of symbols
alphabet = [-(M-1):2:M-1]; %M-PAM constellation
symbolIndicesTx = floor(M*rand (1, numSymbols));
s = alphabet(symbolIndicesTx + 1); %transmitted signal
Pn = 2 %noise power (assumed to be in Watts)
n = sqrt(Pn)*randn(size(s)); %white Gaussian noise
r = s+n; %channel with additive white Gaussian noise
symbolIndicesRx = ak_pamdemod (r, M);% demodulate
SER = sum(symbolIndicesTx~=symbolIndicesRx)/numSymbols
Ps = mean(alphabet.^2) %transmitted signal power (Watts)
Pr = mean(r.^2) %received signal power (Watts)
SNR = Ps/Pn %SNR in linear scale
N0_s = 10*log10(Ps/pi) %unilateral Tx PSD level (dB/rad)
N0_r = 10*log10(Pr/pi) %unilateral Rx PSD level (dB/rad)
N0_n = 10*log10(Pn/pi)%unilateral PSD noise level (dB/rad)
clf
subplot(311)
pwelch(s), hold on
h=plot([0 0.5 1],N0_s*[1 1 1],'r'), makedatatip(h,2)
title('PSD of transmitted signal s'), xlabel(''), ylabel('')
set(gca,'XtickLabel',[])
subplot(312)
pwelch(n), hold on
h=plot([0 0.5 1],N0_n*[1 1 1],'r'), makedatatip(h,2)
title('PSD of additive white noise n'), xlabel('')
set(gca,'XtickLabel',[])
subplot(313)
pwelch(r), hold on
h=plot([0 0.5 1],N0_r*[1 1 1],'r'), makedatatip(h,2)
title('PSD of received signal r'), ylabel('')
writeEPS('flat_psd_pam_awgn','font12Only');
%plot(real(r),imag(r),'x') %received constellation

clf
M=16; %modulation order
snrsdB=-3:30; %specified SNR range (in dB)
snrs=10.^(0.1*(snrsdB)); %conversion from dB to linear
numberOfSymbols = 40000; %number of symbols
alphabet = [-(M-1):2:M-1]; %symbols of a M-PAM
symbolIndicesTx = floor(M*rand(1, numberOfSymbols));
s = alphabet( symbolIndicesTx +1); %transmitted signal
signalPower = mean(alphabet.^2); %signal power (Watts)
for i=1:length(snrs) %loop over all SNR of interest
    noisePower = signalPower/snrs(i); %noise power (Watts)
    n = sqrt(noisePower)*randn(size(s));%white Gaus. noise
    r = s + n; %add noise to the transmitted signal
    symbolIndicesRx = ak_pamdemod ( r, M); %decision
    SER_empirical(i) = sum(symbolIndicesTx ~= ...
        symbolIndicesRx)/numberOfSymbols%Symbol error rate
end
%Compare empirical and theoretical values of SER
SER_theoretical=2*(1-1/M)*qfunc(sqrt(3*snrs/(M^2-1)));
semilogy(snrsdB,SER_theoretical,snrsdB,SER_empirical,'x');
xlabel('SNR (dB)')
ylabel('SER');
legend('Theoretical','Empirical');
grid
writeEPS('16pam_ser_empirical_theo');

clf
ex_pam_ber
writeEPS('binaryPAM_ber');

ex_pam_ber_ebn0
writeEPS('binaryPAM_ber_ebn0');

%Compare a 4-PAM with 200 bps with a 64-QAM with 1200 bps
%Part I - using SNR
%1) PAM
M=16;
snr_dB = linspace(15,25,100); %SNR in dB
snr = 10 .^ (0.1*snr_dB); %linear SNR
PAM_theoreticalSER  = 2*(1-1/M)*ak_qfunc(sqrt(3*snr/(M^2-1)));
%2) QAM
M=64;
qvalues = ak_qfunc(sqrt(3*snr/(M-1)));
temp = (1-1/sqrt(M))*qvalues;
QAM_theoreticalSER = 4*(temp  - temp.^2);
clf, semilogy(snr_dB,PAM_theoreticalSER,snr_dB,QAM_theoreticalSER,'--');
xlabel('SNR (dB)'); ylabel('SER'); grid;
legend('PAM','QAM');

%Part II - using Eb/N0
%1) PAM
M=16;
snr_dB = linspace(15,25,100); %SNR in dB
snr = 10 .^ (0.1*snr_dB); %linear SNR
ebN0 = snr / (2 * log2(M)); %linear Eb/N0
PAM_ebN0_dB = 10*log10(ebN0); %Eb/N0 in dB
PAM_theoreticalSER  = 2*(1-1/M)*ak_qfunc(sqrt(3*snr/(M^2-1)));
%2) QAM
M=64;
qvalues = ak_qfunc(sqrt(3*snr/(M-1)));
temp = (1-1/sqrt(M))*qvalues;
QAM_theoreticalSER = 4*(temp  - temp.^2);
ebN0 = snr / (2 * log2(M)); %linear Eb/N0
QAM_ebN0_dB = 10*log10(ebN0); %Eb/N0 in dB
clf, semilogy(PAM_ebN0_dB,PAM_theoreticalSER,...
    QAM_ebN0_dB,QAM_theoreticalSER,'--');
xlabel('E_b/N_0 (dB)'); ylabel('SER'); grid;
legend('PAM','QAM');
