function [A,E,K] = ak_levinson_durbin(R,p)
% Levinson-Durbin recursion compatible with Matlab's levinson method.
% R: autocorrelation sequence [R(0) ... R(p)]
% p: order

R = R(:).'; % ensure row vector

% Initialization
A = zeros(1,p+1);
K = zeros(p,1);
E = zeros(p+1,1);

A(1) = 1;
E(1) = R(1);

for i = 1:p
    if i == 1
        lambda = -R(2) / E(1);
    else
        lambda = -(R(i+1) + A(2:i) * R(i:-1:2).') / E(i);
    end

    K(i) = lambda;

    % Update A
    A_prev = A;
    A(2:i+1) = A_prev(2:i+1) + lambda * fliplr(A_prev(1:i));

    % Update error
    E(i+1) = E(i) * (1 - abs(lambda)^2);
end

% Match MATLAB outputs
A = A;        % includes A(1)=1
E = E(end);   % final prediction error