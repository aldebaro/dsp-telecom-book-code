function distortion = ak_spectralDistortion(x,y,Nfft,thresholdIndB)
% function distortion = ak_spectralDistortion(x,y,Nfft,thresholdIndB)
%Returns the spectral distortion (SD) in dB as defined at
% http://en.wikipedia.org/wiki/Log-spectral_distance
%Signals x and y can be complex-valued (spectra without Hermitian
%symmetry). If the fft size Nfft is not specified, the largest length
%between x and y is assumed. The thresholdIndB sets a floor value for
%the power spectra from the maximum value to avoid numerical
%problems, such as the log of zero going to minus infinite. The
%default value of thresholdIndB is 60 (60 dB).
if nargin < 3
    Nfft=max(length(x),length(y));
end
if nargin < 4 %thresholdIndB  avoids numerical
    thresholdIndB = 60; %default is 60 dB
end
%% Deal with special cases:
%Check if any or both signals have low power (maybe only dither):
powerX = mean(x.^2);
powerY = mean(y.^2);
if powerX == 0 && powerY == 0
    distortion = 0;
    warning(['SD=0. Both signals have zero energy. Returning'])
    return;
end
if powerX == 0
    warning(['Signal x (first argument) has zero energy'])
end
if powerY == 0
    warning(['Signal y (second argument) has zero energy'])
end
if length(x) > Nfft
    warning(['Length of first signal is larger than Nfft'])
end
if length(y) > Nfft
    warning(['Length of second signal is larger than Nfft'])
end
%% Calculate the SD:
%Spectral distortion can be seen as the square-root of the mean
%square error between the two power spectra (PSD or MS spectrum) in
%dB scale. This code uses FFTs to discretize the DTFT of the signals
%and, from the DTFTs obtain the power spectra. Both PSD and MS
%spectrum are given by |FFT|^2/scaling_factor, and the scaling factor
%is not important here because the division of the two spectra
%cancels it out. Hence, the power spectrum is calculated as |DTFT|^2.
X=abs(fft(x,Nfft)); %Calculate magnitude values of DTFTs
Y=abs(fft(y,Nfft));
logX=20*log10(X); %Convert to dB and use factor=20 to convert ...
logY=20*log10(Y); %DTFTs into power spectra using log(X^2)=2*log(X)
maximumValue = max([max(logX) max(logY)]); %Avoid numerical problems
minimumValue = maximumValue - thresholdIndB; %such as log of 0
logX(logX<minimumValue)=minimumValue; %Impose the floor value
logY(logY<minimumValue)=minimumValue;
distortion = sqrt(mean((logX-logY).^2)); % SD as a mean-squared error
%Alternative interpretation of SD below: an approximation of the
%integral of the equation specified at the URL above. Using the
%rectangular rule for approximating this integral, the base of each
%rectangle is 2pi/Nfft and there is a factor of 1/2pi in SD equation,
%such that the mean above is clearly approximating the integral if
%written as:
%distance = sqrt((1/Nfft)*sum((logX-logY).^2));
%% Debug information
if 0 %enable for debugging
    clf
    subplot(311);
    deltaW = (2*pi)/Nfft;
    n=deltaW * (0:length(logX)-1);
    figure(1)
    plot(n,logX,n,logY)
    title(['Spectral distortion = ' num2str(distortion) ' dB']);
    legend('X','Y');
    subplot(312);
    plot(n,(logX-logY).^2)
    xlabel('angular frequency (rad)');
    subplot(313);
    plot(x), hold on, plot(y,'g'), legend('x','y')
    xlabel('time');
    pause
end