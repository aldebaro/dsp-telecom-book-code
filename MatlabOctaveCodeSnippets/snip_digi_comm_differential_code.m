%% Differential encoding at transmitter
bits=[0 1 0 1 1 0 0] %bits to be transmitted
N=length(bits); %number of bits
initialValue = 1; %assume the initial bit is 1
differentialBits=zeros(size(bits)); %pre-allocate space 
differentialBits(1)=xor(initialValue,bits(1)); %initialize
for i=2:N %for all other bits
   differentialBits(i)=xor(differentialBits(i-1),bits(i));
end
m=2*(differentialBits-0.5); %convert {0,1} to {-1,1}
%% Differential decoding at receiver
mHat=m; %assume no errors: no noise and perfect decoding at receiver
differentialBitsHat=(mHat+1)/2; %convert polar {-1,1} to {0,1} 
decodedBits=xor(differentialBitsHat,[~initialValue ...
    differentialBitsHat(1:N-1)])
errors = bits - decodedBits %no errors: all zeros