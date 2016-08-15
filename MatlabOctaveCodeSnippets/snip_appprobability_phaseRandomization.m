B=[1 -0.8]; %Generate MA(1) process with these FIR coefficients
L=3; %upsampling factor (to upsample the MA(1) process)
numRealizations = 20000; %number of sequences (realizations)
numSamples = 300; %number of samples
%matrix X represents the input random process, add L extra samples
Z=randn(numSamples+L,numRealizations); %white Gaussian noise
X=filter(B,1,Z); %implement filtering by LTI system
X(1:2*length(B),:)=[]; %take out filter transient
Xup_shifted=ak_upsampleRandomShift(X, L); %upsample & random shift
[Rxx,n1,n2] = ak_correlationEnsemble(Xup_shifted,10); %get Rxx
subplot(121), ak_correlationMatrixAsLags(Rxx); %plot as n times lag
ylabel('lag'); xlabel('n'); colorbar; title('a) WSS') 
Xup = zeros(L*size(X,1),numRealizations); %initialize with zeros
Xup(1:L:end,:)=X; %effectively upsample
subplot(122) %now the autocorrelation of the cyclostationary process
ak_correlationMatrixAsLags(ak_correlationEnsemble(Xup,10)); %plot Rxx
ylabel('lag'); xlabel('n'); title('b) WSC'); colorbar