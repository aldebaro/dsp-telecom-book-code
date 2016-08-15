%get posteriori probabilities
close all
clear all
myaxis=[-4 4 0 1.2];
subplot(121)
N=10000; x=linspace(-4,4,N);
mean1=-1;
mean2=1;
standardDeviation1=2;
standardDeviation2=0.4;
prior1 = 0.5;
prior2 = 0.5;
%g1=pdf('norm',x,-1,standardDeviation1);
g1=octave_normpdf(x,-1,standardDeviation1);
%g2=pdf('norm',x,1,standardDeviation2);
g2=octave_normpdf(x,1,standardDeviation2);
posterior1 = g1*prior1;
posterior2 = g2*prior2;
prob_of_m = posterior1+posterior2;
%normalize
posterior1 = posterior1./prob_of_m;
posterior2 = posterior2./prob_of_m;
plot(x,posterior1,x,posterior2);
xlabel('r'); ylabel('p(m|r)');
hold on
%plot(x,posterior1+posterior2,'r:');
plot([-1 1],[0 0],'x','markersize',20);
[optimalThresholds, BayesError]=...
    ak_MAPforTwoGaussians(mean1, standardDeviation1, prior1, ...
    mean2, standardDeviation2, prior2)
ymaxlim = 1.5;
for i=1:length(optimalThresholds)
    plot(optimalThresholds(i)*[1 1],[0 ymaxlim],':k')
end
%set(gca,'xtick',[-5 -3 -2 -1 0 1 2]);
axis(myaxis);
title('a)')
disp(['Pe = ' num2str(BayesError)])
axis square

subplot(122)
mean1=-1;
mean2=1;
standardDeviation1=1;
standardDeviation2=1;
prior1 = 0.8;
prior2 = 0.2;
%g1=pdf('norm',x,-1,standardDeviation1);
g1=octave_normpdf(x,-1,standardDeviation1);
%g2=pdf('norm',x,1,standardDeviation2);
g2=octave_normpdf(x,1,standardDeviation2);
posterior1 = g1*prior1;
posterior2 = g2*prior2;
%normalize
prob_of_m = posterior1+posterior2;
%normalize
posterior1 = posterior1./prob_of_m;
posterior2 = posterior2./prob_of_m;
plot(x,posterior1,x,posterior2);
xlabel('r'); 
hold on
%plot(x,posterior1+posterior2,'r:');
plot([-1 1],[0 0],'x','markersize',20);
[optimalThresholds, BayesError]=...
    ak_MAPforTwoGaussians(mean1, standardDeviation1, prior1, ...
    mean2, standardDeviation2, prior2)
ymaxlim = 1.5;
for i=1:length(optimalThresholds)
    plot(optimalThresholds(i)*[1 1],[0 ymaxlim],':k')
end
%set(gca,'xtick',[-5 -3 -2 -1 0 1 2]);
%axis([-6 3 0 0.4]);
title('b)')
disp(['Pe = ' num2str(BayesError)])
axis(myaxis);
axis square

writeEPS('posterioriForMAP');

clf
close all
subplot(121)
N=1000; x=linspace(-6,6,N);
mean1=-1;
mean2=1;
standardDeviation1=2;
standardDeviation2=0.4;
prior1 = 0.5;
prior2 = 0.5;
%g1=pdf('norm',x,-1,standardDeviation1);
g1=octave_normpdf(x,-1,standardDeviation1);
%g2=pdf('norm',x,1,standardDeviation2);
g2=octave_normpdf(x,1,standardDeviation2);
plot(x,g1,x,g2);
xlabel('r'); ylabel('p(r|m)');
hold on
plot([-1 1],[0 0],'x','markersize',20);
[optimalThresholds, BayesError]=...
    ak_MAPforTwoGaussians(mean1, standardDeviation1, prior1, ...
    mean2, standardDeviation2, prior2)
ymaxlim = 1.0;
for i=1:length(optimalThresholds)
    plot(optimalThresholds(i)*[1 1],[0 ymaxlim],':k')
end
%set(gca,'xtick',[-5 -3 -2 -1 0 1 2]);
%axis([-5 5 0 ymaxlim]);
title('a)')
disp(['Pe = ' num2str(BayesError)])
axis square

subplot(122)
mean1=-1;
mean2=1;
standardDeviation1=1;
standardDeviation2=1;
prior1 = 0.8;
prior2 = 0.2;
g1=octave_normpdf(x,-1,standardDeviation1);
g2=octave_normpdf(x,1,standardDeviation2);
plot(x,g1,x,g2);
xlabel('r'); ylabel('p(r|m)');
hold on
plot([-1 1],[0 0],'x','markersize',20);
%
%The call below is to find the threshold, but
%the Bayes error gives NaN, need to finish the function.
%The NaN error is not a problem because we just need the threshold here
[optimalThresholds, BayesError]=...
    ak_MAPforTwoGaussians(mean1, standardDeviation1, prior1, ...
    mean2, standardDeviation2, prior2)
ymaxlim = 0.5;
for i=1:length(optimalThresholds)
    plot(optimalThresholds(i)*[1 1],[0 ymaxlim],':k')
end
%set(gca,'xtick',[-5 -3 -2 -1 0 1 2]);
%axis([-6 3 0 0.4]);
title('b)')
disp(['Pe = ' num2str(BayesError)])
axis([-5 5 0 ymaxlim]);
axis square

if 0 % did not work
    x=get(gcf,'OuterPosition');
    factor = 2;
    set(gcf,'OuterPosition',[x(1) x(2) factor *x(3) factor *x(4)]);
end
writeEPS('regionsForMAP');


close all
sigma2=2; %noise variance
N=1000;
d=1; %space among PAM symbols
%snrs=linspace(0.1,10,N);
snrs=logspace(-3,3,N);
b=zeros(1,N);
Pe=zeros(1,N);
Q=qfunc(d/(2*sqrt(sigma2)))
for i=1:N
    snr=snrs(i);
    b(i)=0.5*log2(12*snr*sigma2/(d^2)+1);
    M=2^b(i); %allow it to be non-integer
    Pe(i)=2*(1-1/M)*Q;
end
b(671)=4; b(771)=5; %fix for better visualization
subplot(121)
plot1 = plot(10*log10(snrs),b);
xlabel('SNR (dB)');  ylabel('b');
makedatatip(plot1,[671,771]);
grid
title('a)')
%axis square
subplot(122)
%plot(10*log10(snrs),Pe);
%semilogy(b,Pe);
plot(b,Pe);
xlabel('b'); ylabel('P_e')
grid
%axis square
title('b)')
writeEPS('rule6dbPAM');

clf
sigma2=0.01; %noise variance
snrs=logspace(-1,9,N);
b=zeros(1,N);
Pe=zeros(1,N);
Q=qfunc(d/(2*sqrt(sigma2)))
for i=1:N
    snr=snrs(i);
    b(i)=0.5*log2(12*snr*sigma2/(d^2)+1);
    M=2^b(i); %allow it to be non-integer
    Pe(i)=2*(1-1/M)*Q;
end
subplot(121)
plot1 = plot(10*log10(snrs),b);
xlabel('SNR (dB)');  ylabel('b');
%makedatatip(plot1,[671,771]);
grid
title('a)')
axis square
subplot(122)
%plot(10*log10(snrs),Pe);
semilogy(b,Pe);
%plot(b,Pe);
xlabel('b'); ylabel('P_e')
grid
axis square
title('b)')
writeEPS('rule6dbPAMHighSNR');

%example of error prob. with Gaussian distributions
close all
%subplot(131)
N=1000; x=linspace(-6,6,N);
variance=2;
g1=octave_normpdf(x,-3,sqrt(variance));
g2=octave_normpdf(x,-1,sqrt(variance));
g3=octave_normpdf(x,1,sqrt(variance));
g4=octave_normpdf(x,3,sqrt(variance));
plot(x,g1,x,g2,x,g3,x,g4)
xlabel('r'); ylabel('p(r|m)');
hold on
plot([-3:2:3],zeros(1,4),'x','markersize',20);
thresholds = -2:2:2;
ymaxlim = 0.4;
for i=1:3
    plot(thresholds(i)*[1 1],[0 ymaxlim],':k')
end
%set(gca,'xtick',[-5 -3 -2 -1 0 1 2]);
%axis([-6 3 0 0.4]);
writeEPS('gaussainPAMNoiseExample');


%example of error prob. with uniform distributions
close all
subplot(131)
N=1000; x=linspace(-6,4,N);
u1=octave_unifpdf(x,-5,0);
u2=octave_unifpdf(x,-1,2);
plot(x,u1,x,u2)
hold on
plot(-3,0,'x',1,0,'x','markersize',20)
threshold = -2;
plot(threshold*[1 1],[0 0.4],':k')
set(gca,'xtick',[-5 -3 -2 -1 0 1 2]);
axis([-6 3 0 0.4]);
xlabel('r'); ylabel('p(r|m)');
axis square
title('a)')
subplot(132)
plot(x,u1,x,u2)
hold on
plot(-3,0,'x',1,0,'x','markersize',20)
threshold = -2;
plot(threshold*[1 1],[0 0.4],':k')
fill([-2 -2 0 0],[0 0.2 0.2 0],'r');
set(gca,'xtick',[-5 -3 -2 -1 0 1 2]);
xlabel('r');
axis([-6 3 0 0.4]);
axis square
title('b)')
subplot(133)
plot(x,u1,x,u2)
hold on
plot(-3,0,'x',1,0,'x','markersize',20)
threshold = 0;
plot(threshold*[1 1],[0 0.4],':k')
fill([0 0 -1 -1],[0 1/3 1/3 0],'r');
set(gca,'xtick',[-5 -3 -2 -1 0 1 2]);
xlabel('r');
axis([-6 3 0 0.4]);
axis square
title('c)')
x=get(gcf, 'Position'); %get figure's position on screen
x(3)=floor(x(3)*1.6); %adjust the size making it "wider"
set(gcf, 'Position',x);
writeEPS('uniformNoiseExample');

%plot Voronoi region
close all;
x=[1 3 -1 -2 2 3];
y=[1 2 -2 3 -1 1];
subplot(121)
[vx, vy] = voronoi(x,y);
plot(x,y,'r.',vx,vy,'b-','markersize',25); axis equal
xlim([-4 4]), ylim([-4 4])
subplot(122)
[v,c]=voronoin([x' y']);
i=1; patch(v(c{i},1),v(c{i},2),i);
hold on
[vx, vy] = voronoi(x,y);
plot(x,y,'r.',vx,vy,'b-','markersize',25); axis equal
xlim([-4 4]), ylim([-4 4])
box('on'); %not sure why the box is not plotted
writeEPS('voronoiExample');
