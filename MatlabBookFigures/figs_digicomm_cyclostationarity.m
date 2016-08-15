%shows some results with upsampling a signal and calculating
%autocorrelation. Test with random signals and a cosine

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%test with a cosine signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
clf
figure(1)
rand('seed',0);
%show cyclostationary autocorrelation
S=2; %oversampling (upsampling in this context) factor
numRealizations = 10000; %number of sequences (realizations)
numSamples = 8; %number of samples
N = 4; %period
extraSamples = N;
%matrix X represents the random process, add extra samples
x=4*sin(2*pi/N*(0:numSamples-1+extraSamples))';

X=repmat(x,1,numRealizations);
Xup_shifted=ak_upsampleRandomShift(X, S, N); %add random phase

clf
Z=16;
subplot(311); stem(1:Z, Xup_shifted(1:Z,6))
subplot(312); stem(1:Z, Xup_shifted(1:Z,22)); ylabel('Amplitude')
subplot(313); stem(1:Z, Xup_shifted(1:Z,31))
xlabel('n'); 
writeEPS('realizationsUpShiftedSine');

clf;
%[Rxx,n1,n2] = ak_correlationEnsemble(Xu,200);
[Rxx,n1,n2] = ak_correlationEnsemble(Xup_shifted);
mesh1=mesh(n1,n2,Rxx);
ylabel('n1'); xlabel('n2'); zlabel('Rx');
%view([-9.5 20]);
makedatatip(mesh1,1); %could not use makedatatip work properly in this case
writeEPS('correlationUpShiftedSine');

[Rxx_tau, lags] = ak_convertToWSSCorrelation(Rxx);
%figure(2);

%stem(Rxx_tau)
stem(fftshift(abs(fft(Rxx_tau))))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%test with a binary random signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
clf
rand('seed',0);
%show cyclostationary autocorrelation
S=4; %oversampling (upsampling in this context) factor
numRealizations = 5000; %number of sequences (realizations)
numSamples = 200; %number of samples
%matrix X represents the random process, add S extra samples
if 0 %polar
    X=2*[floor(2*rand(numSamples+S,numRealizations))-0.5];
else %unipolar%shows some results with upsampling a signal and calculating
    X=floor(2*rand(numSamples+S,numRealizations));
end
%upsampling:
Xu=zeros(S*numSamples,numRealizations); %pre-allocate space
%get first numSamples samples
Xu(1:S:end,:)=X(1:numSamples,:); %generate upsampled realizations
[Rxx,n1,n2] = ak_correlationEnsemble(Xu,15);  %autocorrelation
mesh1=mesh(n1,n2,Rxx);
ylabel('n1'); xlabel('n2'); zlabel('Rx');
view([-9.5 20]);
makedatatip(mesh1,[1 1; 15 15]); %could not use makedatatip properly in this case
writeEPS('sampledSignalACFUnipolar');



clear all
clf
rand('seed',0);
%show cyclostationary autocorrelation
S=4; %oversampling (upsampling in this context) factor
numRealizations = 5000; %number of sequences (realizations)
numSamples = 200; %number of samples
%matrix X represents the random process, add S extra samples
if 1 %polar
    X=2*[floor(2*rand(numSamples+S,numRealizations))-0.5];
else %unipolar%shows some results with upsampling a signal and calculating
    X=floor(2*rand(numSamples+S,numRealizations));
end
%upsampling:
Xu=zeros(S*numSamples,numRealizations); %pre-allocate space
%get first numSamples samples
Xu(1:S:end,:)=X(1:numSamples,:); %generate upsampled realizations
[Rxx,n1,n2] = ak_correlationEnsemble(Xu,15);  %autocorrelation
mesh1=mesh(n1,n2,Rxx);
ylabel('n1'); xlabel('n2'); zlabel('Rx');
view([-9.5 20]);
makedatatip(mesh1,[1 1; 15 15]); %could not use makedatatip properly in this case
writeEPS('sampledSignalACFPolar');


%use random shift
clf
Xup_shifted=ak_upsampleRandomShift(X, S);
[Rxx,n1,n2] = ak_correlationEnsemble(Xup_shifted,15); 
mesh1=mesh(n1,n2,Rxx);
ylabel('n1'); xlabel('n2'); zlabel('Rx');
%view([-9.5 20]);
makedatatip(mesh1,1); %could not use makedatatip properly in this case
writeEPS('sampledSignalACFAfterUnifPhase');

clf
Z=30;
subplot(311); stem(1:Z, Xup_shifted(1:Z,10))
subplot(312); stem(1:Z, Xup_shifted(1:Z,20)); ylabel('Amplitude')
subplot(313); stem(1:Z, Xup_shifted(1:Z,30))
xlabel('n'); 
writeEPS('cyclostationaryRealizations');
