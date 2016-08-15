bits=[0 1 0 1 1 0 0]; %bits to be transmitted
N=length(bits); %number of bits
m=zeros(1,N); %pre-allocate space for symbols
currentPolarity = 1;%assumption: positive polarity first
for i=1:N %loop over bits
    if bits(i)==1
        m(i)=currentPolarity;
        currentPolarity = -currentPolarity; %invert 
    end %no need for "else": m(i) is initialized as zero
end

