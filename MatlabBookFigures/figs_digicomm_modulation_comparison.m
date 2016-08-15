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

figure1 = clf;

plot(b,EbN0_qam_dB,'-x',b,EbN0_psk_dB,'-o',b,EbN0_shannon_dB,'--');
legend1 = legend('M-QAM','M-PSK','Shannon limit');
set(legend1,'Position',[0.1634 0.7528 0.2421 0.135]);
axis([1 8 0 30])
grid
xlabel('spectral efficiency \eta (b/s/Hz)')
ylabel('E_b / N_0 (dB)');

% Create textbox
annotation(figure1,'textbox',...
    [0.1205 0.3135 0.09226 0.05654],'String',{'BPSK'},...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',...
    [0.2283 0.3272 0.09226 0.05654],'String',{'4-QAM'},...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',...
    [0.1986 0.4363 0.09226 0.05654],'String',{'4-PSK'},...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',...
    [0.6442 0.5473 0.09226 0.05654],'String',{'64-QAM'},...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',...
    [0.6457 0.8052 0.09226 0.05654],'String',{'64-PSK'},...
    'FitBoxToText','off',...
    'LineStyle','none');

b
gapToCapacityForQAM = EbN0_qam_dB-EbN0_shannon_dB
gapToCapacityForPSK = EbN0_psk_dB-EbN0_shannon_dB

writeEPS('modulation_comparison');

clf
plot(1./b,EbN0_qam_dB,'-x',1./b,EbN0_psk_dB,'-o');
hold on
b=1:1:30;
EbN0_shannon_dB = 10*log10((2.^b -1) ./ b); %Shannon limit
plot(1./b,EbN0_shannon_dB,'r--');
axis([0 1 0 30])
grid
xlabel('Normalized bandwidth or 1/\eta=1/b (Hz/(b/s))')
ylabel('E_b / N_0 (dB)');
legend('M-QAM','M-PSK','Shannon limit');
writeEPS('modulation_comparison_2');