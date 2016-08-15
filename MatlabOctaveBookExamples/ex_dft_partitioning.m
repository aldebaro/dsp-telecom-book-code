N=4; %number of FFT points
X = transpose([-1 -1-j -1 -1+j]); %transmit vector (QAM symbols)
[Ah, A]=ak_fftmtx(N,1); %orthonormal DFT matrices, A is the inverse
h = transpose([0.6 0.5 0.3 0]); %impulse response (of N samples)
H = circulant(h); %N x N circulant channel matrix
D=Ah*H*A; %check that DFT can partition H
maxOutOfDiagonal=max(max(abs(D-diag(diag(D))))) %only small values
eigenvalues=fft(h); %or, alternatively, eigenvalues=diag(D)
x = A*X; y = H*x; Y = Ah*y; Xp = Y ./ eigenvalues; %processing
disp('Compare the received Xp with the transmitted symbols X'); X, Xp