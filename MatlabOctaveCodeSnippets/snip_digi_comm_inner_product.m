N=4; %length of vectors for inner product
x=(1:N)+j*(N:-1:1); %define some complex signals as row vectors, such
y=rand(1,N)+j*rand(1,N); %that fliplr inverts the ordering
innerProduct = sum(x.*conj(y))
innerProductViaXcorr=xcorr(x,y,0) %cross-correlation at origin
innerProductViaConv=conv(x,conj(fliplr(y))); %use the second argument
innerProductViaConv=innerProductViaConv(N) %sample of interest
