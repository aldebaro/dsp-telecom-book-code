bits=[0 1 0 1 1 0 0]; %bits to be transmitted
N=length(bits); %number of bits
initialValue = 1; %assume the initial bit is 1
differentialBits=zeros(size(bits)); %pre-allocate space 
differentialBits(1)=xor(initialValue,bits(1)); %initialize
for i=2:N %for all other bits
   differentialBits(i)=xor(differentialBits(i-1),bits(i));
end
m=2*(differentialBits-0.5); %transform {0,1} to {-1,1}
%decode for the sake of fun (not needed here)
decodedBits=xor(differentialBits,[initialValue ...
    differentialBits(1:N-1)]);
errors = bits - decodedBits %no errors: all zeros

