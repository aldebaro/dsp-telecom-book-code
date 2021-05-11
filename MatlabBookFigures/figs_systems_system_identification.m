function figs_systems_system_identification()
clear all
rand('seed',0); randn('seed',52); %52 was found after trial and error, do not mess up
%% Option with preamble of 63 training samples and SNR=20 dB
inputLengthLog2=6;
inputSequenceChoice=3;
SNRdB = 20;
plot_3_estimates(inputLengthLog2,inputSequenceChoice,SNRdB);
writeEPS('ls_channel_estimation','font12Only');

%% Option with preamble of 1023 training samples  and SNR=20 dB
% inputLengthLog2=10;
% inputSequenceChoice=3;
% SNRdB = 20;
% plot_3_estimates(inputLengthLog2,inputSequenceChoice,SNRdB);
% writeEPS('ls_channel_estimation_better','font12Only');

%% Option with preamble of 63 training samples and SNR=Inf dB
inputLengthLog2=6;
inputSequenceChoice=3;
SNRdB = Inf;
plot_3_estimates(inputLengthLog2,inputSequenceChoice,SNRdB);
writeEPS('ls_channel_estimation_snrinf','font12Only');

%% Option with preamble of 2047 training samples and SNR=20 dB
inputLengthLog2=11;
inputSequenceChoice=3;
SNRdB = 20;
plot_3_estimates(inputLengthLog2,inputSequenceChoice,SNRdB);
writeEPS('ls_channel_estimation_longtrain','font12Only');

%% Corrrelation
inputLengthLog2=5;
x=mseq(2,inputLengthLog2); %"maximum length" sequence
X=convmtx(x,181); %create convolution matrix X
x=mseq(2,inputLengthLog2); %"maximum length" sequence
[R,lag]=xcorr(x);
subplot(121), stem(lag,R); xlabel('lag k'), ylabel('R_x(k)');
subplot(122), mesh(X'*X); colorbar, title('X^H X')
%To make a figura wider:
x=get(gcf, 'Position'); %get figure's position on screen
x(3)=floor(x(3)*1.6); %adjust the size making it "wider"
set(gcf, 'Position',x);
writeEPS('autocorrelationSignalAndMatrix','font12Only');

return %end of main function

%% Only plot
function plot_3_estimates(inputLengthLog2,inputSequenceChoice,SNRdB)
[h,h_est,h_est2,h_est3]= ...
ex_systems_LS_channel_estimation(inputLengthLog2, inputSequenceChoice,SNRdB);
[H,w]=freqz(h); [Hpinv,w]=freqz(h_est); [Hsimple,w]=freqz(h_est3);
[H2,w]=freqz(h_est2);
clf, line_fewer_markers(w,20*log10(abs(H)),9,'-bs');
line_fewer_markers(w,20*log10(abs(Hpinv)),9,'-xk');
line_fewer_markers(w,20*log10(abs(H2)),9,'-*g');
line_fewer_markers(w,20*log10(abs(Hsimple)),9,'-ro');
xlabel('\Omega (rad)'); ylabel('|H(e^{j \Omega})| (dB)');
inputLength=2^inputLengthLog2-1; %number of input samples
title(['SNR = ' num2str(SNRdB) ' dB and ' num2str(inputLength) ' training samples'])
legend('Channel',...
    'Using pinv (method 1)',...
    'Cross-correlation (method. 2)',...
    'Peak search + cross-correlation (met. 3)',...
'Location','SouthEast')
return