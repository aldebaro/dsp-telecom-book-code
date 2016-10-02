[y,Fs]=wavread('WeWereAway.wav');
Ts=1/Fs;
minF0Frequency=80; %minimum F0 frequency in Hz
maxF0Frequency=300; %minimum F0 frequency in Hz
minF0Period = 1/minF0Frequency; %correponding F0 (sec)
maxF0Period = 1/maxF0Frequency; %correponding F0 (sec)
Nbegin=round(maxF0Period/Ts);%number of lags for max freq.
Nend=round(minF0Period/Ts); %number of lags for min freq.
subplot(211); plot(Ts*[0:length(y)-1],y);
xlabel('time (s)'); ylabel('Signal y(t)')
[R,lags]=xcorr(y,Nend,'biased'); %ACF with max lag Nend
subplot(212); %autocorrelation with normalized abscissa
plot(lags*Ts,R); xlabel('lag (s)');
ylabel('Autocorrelation of y(t)')
firstIndex = find(lags==Nbegin); %find index of lag
Rpartial = R(firstIndex:end); %just the region of interest
[Rmax, relative_index_max]=max(Rpartial);
%Rpartial was just part of R, so recalculate the index:
index_max = firstIndex - 1 + relative_index_max;
lag_max = lags(index_max); %get lag corresponding to index
hold on; %show the point:
plot(lag_max*Ts,Rmax,'xr','markersize',20);
F0 = 1/(lag_max*Ts); %estimated F0 frequency (Hz)
fprintf('Rmax=%g lag_max=%g T=%g (s) Freq.=%g Hz\n',...
    Rmax,lag_max,lag_max*Ts,F0);
%t=0:Ts:2; soundsc(cos(2*pi*3*F0*t),Fs); %play freq. 3*F0
