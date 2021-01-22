window_choice = 1; %choose one among 3 possible windows
clf, N=32; A=6; %clear figure, FFT length, cosine amplitude
alpha=8.5; %specifies the cosine frequency
Wc=(alpha*2*pi)/N; %cosine frequency in radians
n=0:N-1; x=A*cos(Wc*n); %generate N samples of the cosine
switch (window_choice)
  case 1
    this_window = rectwin(N);
  case 2
    this_window = hanning(N);
  case 3
  this_window = flattopwin(N);
end
amplitude_scaling = sum(this_window); %factor to mitigate scalloping
xw = x.* transpose(this_window); %multiply in time-domain
Xw_scaled_fft = fft(xw)/amplitude_scaling; %N-points FFT and scale it
max_fft_amplitude = max(abs(Xw_scaled_fft));
disp(['Max(abs(scaled FFT))=' num2str(max_fft_amplitude )])
scalloping_loss=(A/2)-max_fft_amplitude;
disp(['Scalloping loss = ' num2str(scalloping_loss)])
disp(['Correct amplitude (Volts) = ' num2str(A)])
disp(['Estimated amplitude (Volts) = ' num2str(2*max_fft_amplitude)])
amplitude_error = A - 2*max_fft_amplitude;
disp(['Amplitude error (Volts) = ' num2str(amplitude_error)])
disp(['Amplitude error (%) = ' num2str(100*amplitude_error/A)])
ak_impulseplot([A/2, A/2],[Wc,2*pi-Wc]/pi,[]); %plot cosine impulses
hold on, stem([0:N-1]*(2*pi/N)/pi,abs(Xw_scaled_fft),'or')
xlabel('Frequency \Omega (rad) normalized by \pi)')
ylabel('Magnitude'), grid
