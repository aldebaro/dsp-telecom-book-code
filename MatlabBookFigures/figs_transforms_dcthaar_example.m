%generate figure illustrating how Haar transform provides information about
%time-localization by varying the position of an impulse
N=32;

mydir = pwd;
cd('../MatlabOctaveThirdPartyFunctions/');
Ah_haar=haarmtx(N);
A_haar = Ah_haar'; %unitary: inverse is the Hermitian
cd(mydir);
Ah_dct=octave_dctmtx(N);
A_dct = Ah_dct'; %unitary: inverse is the Hermitian

x = zeros(N,1); x(12)=1; %define input vector and location of impulse
X_dct=Ah_dct * x; %calculate DCT transform
X_haar=Ah_haar * x; %calculate Haar transform
%plot results
subplot(321); stem(0:N-1,x); ylabel('x[n]');
subplot(324); stem(0:N-1,X_dct); ylabel('X[k] (DCT)');
subplot(326); stem(0:N-1,X_haar); xlabel('k'); ylabel('X[k] (Haar)');
%plot the DCT basis functions for the largest coefficient
ndxMaxDCT = find(max(abs(X_dct))==abs(X_dct));
ndxMaxDCT = ndxMaxDCT(1) %get rid of extra maxima if they exist, keep first
subplot(323); plot(0:N-1,A_dct(:,ndxMaxDCT),'-x'); ylabel('Best DCT basis');
%plot the Haar basis functions for the largest coefficient
ndxMax = find(max(abs(X_haar))==abs(X_haar));
ndxMax = ndxMax(1)
subplot(325); plot(0:N-1,A_haar(:,ndxMax),'-x'); xlabel('n'); ylabel('Best Haar basis');

writeEPS('dct_haar_impulse','font12Only');