%% Compare custom Levinson-Durbin with MATLAB's levinson()
N = 1000;      % Number of samples
P = 3;          % AR model order
%% Generate A(z) that leads to a STABLE synthesis filter 1/A(z)
theta = 2*pi*rand(1,floor(P/2)); %angles
poles_half = 0.999*rand(1,floor(P/2)) .* exp(1j*theta); %poles
poles = [poles_half, conj(poles_half)]; %complex conjugates
if mod(P,2)==1 %add extra real pole if order is odd number
    poles = [poles 0.8 * (2*rand-1)]; % real pole
end
A_true = poly(poles); % compose guaranteed real and stable 1/A(z)
%% Generate AR process x[n] by filtering white noise
sigma2 = 1;                          % driving noise variance
w = sqrt(sigma2) * randn(1,N);       % white Gaussian noise
x = filter(1, A_true, w);            % AR process (synthesis filter)
%% Estimate autocorrelation (Matlab assumes it's real-valued)
r = xcorr(x, P, 'biased');           % autocorrelation estimate
r = r(P+1:end);                      % keep lags 0, 1, ..., P
%% Estimate linear filter via MATLAB and custom implementation
[A1, E1, K1] = levinson(r, P);       % MATLAB reference
[A2, E2, K2] = ak_levinson_durbin(r, P);% our implementation
%% Compare results (result should be 0 or small number, e.g., 1e-15
disp('Estimation errors: ||A1 - A2|| ='); disp(norm(A1 - A2))
disp('||K1 - K2|| ='); disp(norm(K1 - K2))
disp('|E1 - E2| =');  disp(abs(E1 - E2))
%% Show filters
disp('True and estimated A(z):'); disp(A_true); disp(A1) %A1 = A2