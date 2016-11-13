clear all
rand('seed',0); randn('seed',52); %52 was found after trial and error, do not mess up
ex_systems_LS_channel_estimation
[H,w]=freqz(h); [Hpinv,w]=freqz(h_est); [Hsimple,w]=freqz(h_est3);
clf, line_fewer_markers(w,20*log10(abs(H)),9,'-bs');
line_fewer_markers(w,20*log10(abs(Hpinv)),9,'-xk');
line_fewer_markers(w,20*log10(abs(Hsimple)),9,'-ro');
xlabel('\Omega (rad)'); ylabel('|H(e^{j \Omega})| (dB)');
legend('Channel','LS estimation via pinv (method 1)','LS estimat. simplified (method 3)',...
'Location','SouthEast')
writeEPS('ls_channel_estimation','font12Only');

[R,lag]=xcorr(x);
subplot(121), stem(lag,R); xlabel('lag k'), ylabel('R_x(k)');
subplot(122), mesh(X'*X); colorbar, title('X^H X')
%To make a figura wider:
x=get(gcf, 'Position'); %get figure's position on screen
x(3)=floor(x(3)*1.6); %adjust the size making it "wider"
set(gcf, 'Position',x);
writeEPS('autocorrelationSignalAndMatrix','font12Only');
