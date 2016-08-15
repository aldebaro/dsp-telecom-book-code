clear all, close all
rand('seed',1); %make sure all simulations are the same
randn('seed',1);
snip_digi_comm_correlative_decoding %run script

clf
innerProductViaConv1=conv(r,fliplr(A(:,1)')); %could use Ah
innerProductViaConv2=conv(r,fliplr(A(:,2)')); %2nd basis
NN=100; %given number of samples
subplot(211)
plot(innerProductViaConv1(1:NN),'-x');
hold on
plot([D:D:NN],innerProductViaConv1(D:D:NN),'or','MarkerSize',12)
title('Convolution with first basis function')
grid
legend('Samples','Symbols','Location','SouthEast')
subplot(212)
plot(innerProductViaConv2(1:NN),'-x');
hold on
plot([D:D:NN],innerProductViaConv2(D:D:NN),'or','MarkerSize',12)
xlabel('n')
title('Convolution with second basis function')
grid
writeEPS('correlativeDecoderConvOutput','font12Only')

clf
xx=[1 16 -1.25 1.25]; %axis
subplot(311)
plot(x','x-'), axis(xx)
title('Four transmit signals');
subplot(312)
plot(A(:,1),'o-'), axis(xx)
title('First basis function');
subplot(313)
plot(A(:,2),'o-'), axis(xx)
title('Second basis function');
xlabel('n')
writeEPS('correlativeDecoderFunctions','font12Only')

clf
plot(rxSymbols(1,:),rxSymbols(2,:),'xr')
hold on, plot(constellation(1,:),constellation(2,:),'x','MarkerSize',20)
xlabel('Dimension 1'), ylabel('Dimension 2')
legend('Received symbols','Constellation symbols','Location','NorthWest')
writeEPS('correlativeDecoderConstellation','font12Only')
