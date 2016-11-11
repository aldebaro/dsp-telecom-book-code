x=[1:20,20:-1:1]; %input signal to be filtered, in Volts
[B,A]=butter(8,0.3); %IIR filter
N=5; %block length
numBlocks=floor(length(x)/N); %number of blocks
Zi=filtic(B,A,0); %initialize the filter memory with zero samples
y=zeros(size(x)); %pre-allocate space for the output
for i=0:numBlocks-1
    startSample = i*N + 1; %begin of current block 
    endSample = startSample+N -1; %end of current block
    xb=x(startSample:endSample); %extract current block
    [yb,Zi]=filter(B,A,xb,Zi);%filter and update memory
    y(startSample:endSample)=yb; %update vector y
end