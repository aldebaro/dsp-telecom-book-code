S=10000; %some arbitrary number of samples
x=rand(1,S); %create some very very long vector
N=50; %number of samples per frame (or block)
M=floor(S/N); %number of blocks, floor may discard last block samples
powerPerBlock=zeros(M,1); %pre-allocate space
for m=0:M-1 %following the book convention
    beginIndex = m*N+1; %index of the m-th block start
    endIndex = beginIndex+N-1; %m-th block end index
    xm=x(beginIndex:endIndex) %the samples of m-th block
    powerPerBlock(m+1)=mean(abs(xm).^2); %estimate power of block xm
end
clf; subplot(211); plot(x); subplot(212); plot(powerPerBlock) %plot
