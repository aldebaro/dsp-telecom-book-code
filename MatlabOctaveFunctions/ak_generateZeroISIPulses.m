function p=ak_generateZeroISIPulses(L,N,isLinearPhase,N0)
%function p=ak_generateZeroISIPulses(L,N,isLinearPhase,N0)
%Inputs: L - oversampling factor
%        N - determines the duration of p 
%        isLinearPhase - set to 1 if p want linear phase
%        N0 - sample for obtaining the first symbol
if isLinearPhase
    if nargin > 3
        error('N0 cannot be used when isLinearPhase=1')
    end
else
    if N0 > N
        error('Sampling instant exceeds pulse duration')
    end
end
if isLinearPhase
    p=randn(1,L*ceil(N/2+1));
    p(L:L:end)=0;
    p=[fliplr(p) 1 p];
else
    p=randn(1,N*L+1);
    p(1:L:end)=0;
    p(1+(N0-1)*L) = 1;
end

