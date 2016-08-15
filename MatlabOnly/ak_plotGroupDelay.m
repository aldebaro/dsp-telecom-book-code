function ak_plotGroupDelay(B,A)
% function ak_plotGroupDelay(B,A)
%Plots both the group delay and phase using plotyy
gd = grpdelay(B,A,128); %estimate the group delay
gd(1) = []; %avoid NaN at first sample
[H,w] = freqz(B,A,128); %obtain DTFT at 128 points
H(1) = []; w(1) = []; %keep the same size as gd vector
phase = unwrap(angle(H)); %unwrap the phase for better visualization
ax=plotyy(w,gd,w,phase); %use two distinct y axes
ylabel(ax(1),'Group Delay (samples)'); ylabel(ax(2),'Phase (rad)');
xlabel('Frequency \Omega (rad)'); grid;
