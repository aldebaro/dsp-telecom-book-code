numRealizations = 500; numSamples = 4000; %500 waveforms
X=2*[floor(2*rand(numSamples,numRealizations))-0.5];
L=4; %oversampling (upsampling in this context) factor
Xu=zeros(L*numSamples,numRealizations);%pre-allocate space
Xu(1:L:end,:)=X; %generate upsampled realizations
[Rx,n1,n2] = ak_correlationEnsemble(Xu,15); %estimate correlation
mesh(n1,n2,Rx); %3-d plot

