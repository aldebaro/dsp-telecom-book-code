function [X, f]=ak_spectrum(x,Fs,min_mag_threshold_dB)
% function ak_plotBilateralFFTMagnitude(x,Fs,min_mag_threshold_dB)
%Plot the FFT magnitude of vector x using a bilateral spectrum.
%Normalize FFT by the FFT length, such that the output corresponds to
%the DTFS. Fs is the sampling frequency, used to plot the abscissa.
%The default value for Fs is 1 Hz. It returns the FFT value
%corresponding to the largest magnitude and its frequency in Hz.
if ~isvector(x) || isempty(x)
    error('First argument must be a non-empty vector, not matrix!');
end
if nargin < 3
    min_mag_threshold_dB=50; %default value
end
if nargin < 2
    Fs=2; %default value
end
X=fft(x); %calculate FFT
Nfft = length(X); %get FFT length
X=X/Nfft; %normalize (strictly, the result is the DTFS)
deltaF = Fs/Nfft;  %frequency resolution in Hz
mag = abs(X);
phase = angle(X);
phase = unwrap(phase);

%assume phase is 0 when magnitude is too small
db_mag = 20*log10(mag);
min_mag_dB = max(db_mag) - min_mag_threshold_dB;
phase(db_mag < min_mag_dB)=0;
X = mag .* exp(1j*phase); %recrete a new version of X

if isreal(x)
    % due to the Hermitian symmetry of the spectrum, discard
    % the "negative" frequencies
    if rem(Nfft,2)==0
        %Nfft is even and the negative frequencies start at -Fs/2
        f = (0:Nfft/2)*deltaF;
        X = X(1:Nfft/2+1); % only positive frequencies
        X(2:end-1)=2*X(2:end-1); %duplicate mag but at DC and Nyquist
    else
        %Nfft is odd: negative frequencies start at -Fs/2+(deltaF/2)
        f = -Fs/2+(deltaF/2):deltaF:Fs/2-(deltaF/2);
    end    
else
    % represent both positive and negative frequencies
    if rem(Nfft,2)==0
        %Nfft is even and the negative frequencies start at -Fs/2
        f = -Fs/2:deltaF:Fs/2-deltaF;
    else
        %Nfft is odd: negative frequencies start at -Fs/2+(deltaF/2)
        f = -Fs/2+(deltaF/2):deltaF:Fs/2-(deltaF/2);
    end    
end

if nargout == 0
    mag = abs(X);
    phase = angle(X);
    subplot(211)
    stem(f,mag); %plot graph
    ylabel('Magnitude (V)');
    subplot(212)
    stem(f,phase); %plot graph
    ylabel('Phase (rad)');
    %myaxis=axis; axis([f(1),f(end),myaxis(3), myaxis(4)])
    xlabel('frequency (Hz)');
end