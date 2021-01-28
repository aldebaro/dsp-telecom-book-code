randn('seed',1); %reset number generator. Could use rng('default')
useARProcess = 0;       % 1 for AR or 0 for ARMA
N       = 100000;  % Number of samples
inn = randn(1, N); % innovation: WGN with zero mean and unit variance
if useARProcess == 1 % AR process
    fprintf('AR process example\n')
    Bz = 4; % H(z) = Bz/Az is an all-poles filter
    Az = poly([0.98*exp(1j*pi/4) 0.98*exp(-1j*pi/4)]);
    x = filter(Bz, Az, inn); % realization of an AR (2) process
    P = 2; % adopt the correct order of H(z)
else %ARMA process
    fprintf('ARMA process example\n')
    Bz = 6*poly([0.7*exp(1j*pi/3) 0.7*exp(-1j*pi/3)]);
    Az = poly([0.9*exp(1j*pi/4) 0.9*exp(-1j*pi/4)]);
    x = filter(Bz, Az, inn); % realization of innovation process
    P = 10; % it is not AR, so choose a relatively high value
end
[A, Pinn] = aryule(x, P); %prediction, P: order and Pinn: error variance
% Given the filter M(z) = 1/A(z), the inverse M^{-1}(z) = A(z)
% estimates the innovation sequence with X as input:
estimatedInnovation = filter(A, 1, x); % predict
Hw = freqz(Bz, Az); % frequency response
Spsd = abs(Hw).^2 + eps; % convert to scaled PSD and avoid zeros
Sgeo = geo_mean(Spsd); % geometric mean: power of innovation
Sarit = mean(Spsd); % arithmetic mean: power of input signal
predictionGain = 10*log10(Sarit/Sgeo); %prediction gain in dB
fprintf('prediction gain = %g dB \n', predictionGain)
fprintf('Signal power (time-domain) =  %g \n', mean(x.^2) )
fprintf('Signal power (via PSD arithmetic mean) = %g \n', Sarit)
fprintf('Innovation power (via PSD geometric mean) = %g \n', Sgeo)
fprintf('Innovation power (via AR modeling) = %g \n', Pinn)
fprintf('Innovation power (time-domain) = %g \n', ...
    mean(estimatedInnovation.^2))
% freqz(Bz,Az) %frequency response, if useful
