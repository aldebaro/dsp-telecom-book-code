M=8; %modulation order
N=10000; %number of symbols to be generated
indices=floor(M*rand(1,N))+1; %random indices from [1, M]
alphabet=[-(M-1):2:M-1]; %symbols ...,-3,-1,1,3,5,7,...
m=alphabet(indices); %obtain N random symbols

