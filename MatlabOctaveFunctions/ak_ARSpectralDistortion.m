function distortion=ak_ARSpectralDistortion(x,y,lpcOrder,Nfft,...
    thresholdIndB,takeErrorPowerInAccount)
% function distortion=ak_ARSpectralDistortion(x,y,lpcOrder,Nfft,...
%    thresholdIndB,takeErrorPowerInAccount)
%Returns the spectral distortion (SD) in dB the autoregressive (AR)
%power spectra S(z)=1/|A(z)|^2, with A(z) from the LPC function.
%Signals x and y can be complex-valued (spectra without Hermitian
%symmetry). The order of A(z) is given by lpcOrder, with a default
%of 10. If the fft size Nfft is not specified, the largest length
%between x and y is assumed. The thresholdIndB sets a floor value for
%the power spectra from the maximum value to avoid numerical
%problems, such as the log of zero going to minus infinite. The
%default value of thresholdIndB is 60 (60 dB). If the flag
%takeErrorPowerInAccount is 1, use S(z)=Pe/|A(z)|^2 instead of
%S(z)=1/|A(z)|^2, where Pe is the LPC prediction error power.
%See also ak_SpectralDistortion.m
if nargin < 3
    lpcOrder=10; %default
end
if nargin < 4
    Nfft=max(length(x),length(y));
end
if nargin < 5 %thresholdIndB  avoids numerical
    thresholdIndB = 60; %default is 60 dB
end
if nargin < 6
    takeErrorPowerInAccount  = 0; %default is S(z)=1/|A(z)|^2
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
if powerX ~= 0
    x=x.*hamming(length(x)); %use Hamming window
    [Ax,Pex]=aryule(x,lpcOrder);
    X=freqz(1,Ax,Nfft,'whole');
    if takeErrorPowerInAccount==1
        X=Pex*(abs(X).^2); %Calculate magnitude values of DTFTs
    else %option adoped in papers such as [Paliwal & Atal, 1993]
        X=abs(X).^2; %Efficiente Vector quantization..., IEEE
    end
    logX=10*log10(X); %Convert to dB and use factor=20 to convert ...
else
    logX=-Inf*ones(Nfft,1); %column vector
end
if powerY ~= 0
    y=y.*hamming(length(y)); %use Hamming window
    [Ay,Pey]=aryule(y,lpcOrder);
    Y=freqz(1,Ay,Nfft,'whole');
    if takeErrorPowerInAccount==1
        Y=Pey*(abs(Y).^2);
    else %option adoped in papers such as [Paliwal & Atal, 1993]
        Y=abs(Y).^2; %Efficiente Vector quantization..., IEEE
    end
    logY=10*log10(Y); %DTFTs into power spectra using log(X^2)=2*log(X)
else
    logY=-Inf*ones(Nfft,1); %column vector
end
maximumValue = max([max(logX) max(logY)]); %Avoid numerical problems
minimumValue = maximumValue - thresholdIndB; %such as log of 0
logX(logX<minimumValue)=minimumValue; %Impose the floor value
logY(logY<minimumValue)=minimumValue;
distortion = sqrt(mean((logX-logY).^2)); % SD as a mean-squared error
%% Debug information
if 0 %enable for debugging
    clf
    subplot(311);
    deltaW = (2*pi)/Nfft;
    n=deltaW * (0:length(logX)-1);
    plot(n,logX,n,logY)
    title(['Spectral distortion AR = ' num2str(distortion) ' dB']);
    legend('log Sx','log Sy');
    subplot(312);
    plot(n,(logX-logY).^2)
    xlabel('angular frequency (rad)'); ylabel('difference')
    subplot(313);
    plot(x), hold on, plot(y,'g'), legend('x','y')
    xlabel('time'); ylabel('signals')
    pause
end