close all
clear *

%Note:
%x=-3:3; y=-1:1; A=rand(3,7); A(1,5)=20; mesh(x,y,A);
%xlabel('x'), ylabel('y')
%When mesh(x,y,A) plots a matrix A, the vector x informs the
%values over the columns of A, while y is the values over the
%rows. The element A(1,1) has the value of x(1) and y(1). Hence,
%mesh will show an "image":
%  A(x(1),y(2))  A(x(2),y(2)) A(x(3),y(2)) ...
%  A(x(1),y(1))  A(x(2),y(1)) A(x(3),y(1)) ...
%To show the image as the matrix, maybe needs mesh(x,y,flipud(A))

%Hence Cxx has to be organized such that ...

snip_appprobability_modulatednoise %generate signal
%maxTime=3*P; %P is the sinusoid period
maxTime=62; %P is the sinusoid period
[Rxx,n1,n2]=ak_correlationEnsemble(X, maxTime);
[newRxx,n,lags]=ak_correlationMatrixAsLags(Rxx,n1,n2);
%newRxx[n,lags] has the rows n=n1
%and the columns of newRxx are the lags=n2-n1. For example,
%newRxx(1,1) is the earliest time instant n=n1(1) with the smallest
%lag value.
%newRxx=ones(5,8)

% zeroLagIndex=find(lags==0);
% if isempty(zeroLagIndex)
%     error('I was expecting to have a lag = 0');
% end

[numSamplesOverTime,numLags]=size(newRxx);
Cxx=(1/numSamplesOverTime)*fft(newRxx,numSamplesOverTime);
%Cxx is [alpha, lag]
%first row of Cxx has the DC values of each FFT that was calculated
%for each column. Assuming real signal, eliminate negative cycles:
if rem(numSamplesOverTime,2)==0
    Cxx2=Cxx(1:(numSamplesOverTime/2)+1,:);
else
    Cxx2=Cxx(1:(numSamplesOverTime+1)/2,:);
end
%unwrap phase (not working)
%Cphase=unwrap(angle(Cxx2));
%Cphase=transpose(unwrap(transpose(angle(Cxx2))));
Cphase=angle(Cxx2);

%now discard values for alpha=0
Cxx2(1,:)=0; %zero

%no need for the cyclic spectrum
%[alphalength,lagslength]=size(Cxx);
%Sxx = (1/lagslength)*fft(Cxx,lagslength,2);
%xlabel('cycle \alpha');ylabel('lag l');

deltaAlphaInRad=2*pi/numSamplesOverTime;
deltaAlphaInNormalizedFreq=2/numSamplesOverTime;
%not including pi
%alphas=pi*(0:deltaAlphaInNormalizedFreq:1-deltaAlphaInNormalizedFreq);
%including pi
alphas=pi*(0:deltaAlphaInNormalizedFreq:1);

%not using 2nd FFT
%deltaFInRad=2*pi/lagslength;
%deltaFInNormalizedFreq=2/lagslength;
%f=pi*(-1:deltaFInNormalizedFreq:1-deltaFInNormalizedFreq);

%SfirstQuadrant=Cxx(1:lagslength/2,:);
Cmag=abs(Cxx2);
if 1 %want to clean up phase
    smallMagIndices = find(Cmag<max(Cmag(:))/1e2);
    Cphase(smallMagIndices)=0;
end

%[row,col]=find(Smag==max(max(Smag(:,2:end))),1); %,'first');
[row,col]=find(Cmag==max(max(Cmag)),1); %,'first');

%imagesc(alpha,f,abs(S(1:nfft/2,:))),axis xy
mesh(lags,alphas,Cmag);
%mesh(lags,alphas,Cphase);
xlabel('lag l'); ylabel('cycle \alpha'); zlabel('|Cx|')

%imagesc(alphas,f,Cmag); axis xy, hold on
%ak_makedatatip(h,[alpha(rol),f(col)]);
hold on
plot(lags(col),alphas(row),'or','MarkerSize',30);
hold off

WEstimated=alphas(row)/2;
phaseEstimated = Cphase(row,col)/2;
phaseOffset=wrapToPi(Phc) - wrapToPi(phaseEstimated);

disp(['Peak = ' num2str(Cmag(row,col)) ' exp(' ...
    num2str(Cphase(row,col)) 'j)'])
disp(['Correct frequency = ' num2str(Wc) ' rad'])
disp(['Estimated frequency = ' num2str(WEstimated) ' rad'])
disp(['Frequency offset = ' num2str(Wc-WEstimated) ' rad'])
disp(['Correct Phase = ' num2str(Phc) ' rad'])
disp(['Estimated phase = ' num2str(phaseEstimated) ' rad'])
disp(['Phase offset = ' num2str(phaseOffset) ' rad'])
if abs(phaseOffset)>0.1 %error is typically multiple of pi
    disp(['Phase offset dividided by pi = ' num2str(phaseOffset/pi)])
end
