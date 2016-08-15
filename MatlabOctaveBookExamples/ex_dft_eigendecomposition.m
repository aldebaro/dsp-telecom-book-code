N=3; %number of FFT points
h=[0.9 -0.3 0]; %impulse response of length N
H=circulant(h); %create a circulant matrix
A=ak_fftmtx(N,1); %orthonormal inverse DFT matrix (basis are columns)
[V,D]=eig(H); %eigenvalue decomposition
A2=[V(:,1) -V(:,3) -V(:,2)]; %rearrange the eigenvectors to match DFT
max(max(abs(A-A2))) %check whether matrices A and A2 are the same
fft(h)-transpose(diag(D)) %check if eigenvalues are DFT values
