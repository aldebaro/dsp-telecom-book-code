function snip_frequency_fftCosineExample(N, alpha)
% function snip_frequency_fftCosineExample(alpha)
% Superimposes the DTFT and FFT of a windowed cosine,
% assuming the rectangular window.
% N     - FFT length
% alpha - specifies the cosine angular frequency Wc as
%         Wc=(alpha*2*pi)/Nfft, where Wc is in radians
A=6; %cosine amplitude
if alpha > N/2
    error('alpha cannot be larger than N/2')
end
Wc=(alpha*2*pi)/N; %cosine frequency in radians
%% Calculate DTFT values in a fine grid
M=1000; %number of sample points for DTFT visualization
% discretize the frequency axis in large number M of points:
Omega = linspace(-pi, pi, M); 
%add frequency values of interest to facilitate plots
Omega = sort([Omega -Wc Wc 0]);
Xw = (A/2)*(rect_dtft(Omega+Wc,N) + rect_dtft(Omega-Wc,N)); %DTFT
%% Calculate DFT
n=0:N-1; x=A*cos(Wc*n); %generate N samples of the cosine
Xfft = fftshift(fft(x)); %calculate FFT with N points and shift
deltaW = 2*pi/N;  %the unit circle was divided in N slices
if rem(N,2) == 0
    W_fft = -pi:deltaW:pi-deltaW; %N is even
else
    W_fft = -pi+(deltaW/2):deltaW:pi-(deltaW/2); %N is odd
end
%% Plot and calculate scalloping loss
plot(Omega,abs(Xw)),hold on, stem(W_fft,abs(Xfft),'or')
xlabel('Angular frequency \Omega (rad)')
ylabel('|X_w(e^{j\Omega})|'), legend('DTFT','DFT')
grid, axis tight
disp(['Max(abs(FFT))=' num2str(max(abs(Xfft)))])
disp(['Scalloping loss in DTFT=' num2str(A*N/2-max(abs(Xfft)))])
end
function rect_window_dtft = rect_dtft(Omega, N)
    %DTFT of rectangular window
    W_div_2 = Omega/2; %half of angles (pre-compute to speed up)
    rect_window_dtft=(sin(N*W_div_2)./sin(W_div_2)).*exp(-1j*W_div_2*(N-1));
    %Use L'Hospital rule to correct NaN if 0/0:
    rect_window_dtft(isnan(rect_window_dtft))=N; 
end