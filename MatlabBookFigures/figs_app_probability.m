clf
%use the twister method for number generation and set seed to 2
rand('twister',2);
M = 7; %months
Y = 5; %years

%limit the number of victories in 4 (one per week). The season has 7 months
r=floor(5*rand(M,Y));

trend = repmat([0 0 0 1 1 1 2]',1,Y); %create trend
victories = r + trend;
victories(find(victories>4))=4;

if 0 %in case the random number generator changes in future versions
    victories = [
        2     3     0     0     1
        0     1     3     2     1
        2     1     4     0     2
        3     4     3     1     2
        3     3     4     3     4
        2     1     1     2     3
        3     4     4     2     4];
end

mean(victories(:,1))
std(victories(:,1))

stem(1:M,victories(:,1)); xlabel('n (month)'); ylabel('# victories'); grid
    writeEPS('randomsignal');


close all
figure1=figure %should have a better way for doing this

plot(victories);
xlabel('n (month)'); ylabel('# victories');
    writeEPS('realizations');

% Create line
annotation(figure1,'line',[0.5179 0.5196],[0.1061 0.9167],'LineStyle','--',...
    'LineWidth',4);
% Create line
annotation(figure1,'line',[0.7754 0.7771],[0.11 0.9205],'LineStyle','--',...
    'LineWidth',4);
    writeEPS('marked_realizations');

%estimate joint pdf (probability density function) through histograms
clf
[n,bin]=hist(victories(4,:));
bar(bin,n)
[n,bin]=hist(victories(6,:));
bar(bin,n/sum(n))
%joint pdf
[histogram,xaxis,yaxis]=ak_hist2d(victories(4,:),victories(6,:),7,7);
mesh(xaxis,yaxis,histogram/sum(histogram(:))); %normalize to estimate pmf
xlabel('X(4)'); ylabel('X(6)')
    writeEPS('joint_pdf');


%estimate correlation function
[Rxx,n1,n2] = ak_correlationEnsemble(victories);
mesh1 = mesh(n1,n2,Rxx);
ylabel('n1'); xlabel('n2'); zlabel('Rx');
%makedatatip(mesh1,[1]); %could not use makedatatip properly in this case
    writeEPS('correlationNonStationary');


h=imagesc(n1,n2,transpose(Rxx));
xlabel('n1'), ylabel('n2')
axis equal, axis tight, axis xy
colorbar
ak_makedatatip(h,[1 2])
ak_makedatatip(h,[3 5])
    writeEPS('nonStationaryCorrAsImage');


%Compare putting in subplot
%estimate correlation function
clf
[Rxx,n1,n2] = ak_correlationEnsemble(victories);
subplot(121)
h1=mesh(n1,n2,transpose(Rxx)); %use transpose of Rxx such that n1,n2
xlabel('n1');ylabel('n2');zlabel('Rxx[n1,n2]'); %are row and column
%makedatatip(h1,7)
subplot(122)
[newRxx,n,lags]=ak_correlationMatrixAsLags(Rxx,n1,n2)
h2=mesh(n,lags,transpose(newRxx)); %use transpose of newRxx such ...
xlabel('absolute time n');ylabel('lag l'); %that n and l ...
zlabel('Rxx[n,l]'); %are row and column
    writeEPS('twoAbsVersusLag','none');


%Compare putting in subplot as images
clf
subplot(121)
RxxForPlot=zeros(size(Rxx,1)+2,size(Rxx,2)+2);
RxxForPlot(2:end-1,2:end-1)=Rxx;
h1=imagesc(n1(1)-1:n1(end)+1,...
    n2(1)-1:n2(end)+1,transpose(RxxForPlot))
xlabel('n1'), ylabel('n2')
h2=get(h1,'Parent')
axis equal, axis tight, axis xy
%truesize
set(h2,'Xtick',n1)
set(h2,'Ytick',n2)
%colorbar
position=[5 7];
ak_makedatatip(h1,position)
subplot(122)
h3=imagesc(n,lags,transpose(newRxx))
%axis equal, axis tight
xlabel('absolute time n'), ylabel('lag l')
h4=get(h3,'Parent')
%set(h4,'Xtick',n)
%set(h4,'Ytick',lags)
axis equal, axis tight, axis xy
set(h4, ...
    'Ydir','normal', ...
    'YTick', lags(:), ...
    'YTickLabel', ...
    arrayfun(@num2str, lags(:), 'UniformOutput', false));
position=[5 2];
ak_makedatatip(h3,position)
  writeEPS('twoAbsVersusLagAsImage','none');

%With a toeplitz matrix
clf
Rxx=toeplitz(14:-1:4);
ak_correlationMatrixAsLags(Rxx);
colorbar
    writeEPS('rxxOfToeplitz','none');


%generate random signal
clear all
%unipolar case
numRealizations = 1000;
numSamples = 5000;
%matrix X represents the random process
X=floor(2*rand(numSamples,numRealizations)); %random values 0 or 1
[Rxx,n1,n2] = ak_correlationEnsemble(X,10);
subplot(121); mesh2 = mesh(n1,n2,Rxx);
ylabel('n1'); xlabel('n2'); zlabel('Rx');
%makedatatip(mesh2,[10 10]); %could not use makedatatip properly in this case
axis([1 10 1 10 0 1])
title('(a) random values 0 and 1');

%convert Rxx into Rxx_tau, assuming the process is WSS
[Rxx_tau, lags] = ak_convertToWSSCorrelation(Rxx);
Rxx_tau_unipolar = Rxx_tau; %keep for later use

%polar case
X=2*[floor(2*rand(numSamples,numRealizations))-0.5]; %random values -1 or 1
[Rxx,n1,n2] = ak_correlationEnsemble(X,10);
subplot(122); mesh3 = mesh(n1,n2,Rxx);
ylabel('n1'); xlabel('n2'); zlabel('Rx');
%makedatatip(mesh3,10); %could not use makedatatip properly in this case
axis([1 10 1 10 0 1])
title('(b) random values -1 and 1');
writeEPS('correlationStationary');

%representation as image for the polar case
clf
ak_correlationMatrixAsLags(Rxx);
colorbar
writeEPS('correlationPolarAsImage','none')

[Rxx_tau, lags] = ak_convertToWSSCorrelation(Rxx);
Rxx_tau_polar = Rxx_tau; %keep for later use

clf
subplot(121); stem(lags, Rxx_tau_unipolar);
xlabel('lag l'); ylabel('Rx[l]'); title('Unipolar');
axis([-10 10 -0.2 1.2])
subplot(122); stem(lags, Rxx_tau_polar);
xlabel('lag l'); title('Polar');
axis([-10 10 -0.2 1.2])
writeEPS('correlationStationaryOneDim');

%assuming ergodicity
numSamples=1000;
Xunipolar=floor(2*rand(1,numSamples)); %random values 0 or 1
[Rxx,lags]=xcorr(Xunipolar,9,'unbiased');
subplot(121); stem(lags,Rxx)
xlabel('lag l'); ylabel('Rx[l]'); title('Unipolar');
axis([-10 10 -0.2 1.2])
Xpolar=2*[floor(2*rand(1,numSamples))-0.5]; %random values -1 or 1
[Rxx,lags]=xcorr(Xpolar,9,'unbiased');
subplot(122); stem(lags,Rxx)
xlabel('lag l'); title('Polar');
axis([-10 10 -0.2 1.2])
writeEPS('correlationErgodic');
hold off

%% Compare the result of phase randomization to obtain a WSS process
snip_appprobability_phaseRandomization
writeEPS('phaseRandomization');