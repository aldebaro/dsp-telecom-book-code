function figs_signals_correlationcoeff
clf
randn('seed',1);
subplot(311)
%generate N two-dimensional Gaussian vectors
C=[4 0;0 1]; %covariance matrix
mu=[30 6];  %mean
plotOneGaussian(mu,C);
text(23,8,'product A')
%legend('product A')

subplot(312)
C=[4 0.99;0.99 1]; %covariance matrix
mu=[30 12];  %mean
plotOneGaussian(mu,C);
ylabel('y (number of purchased units)')
text(24.6,14,'product B')

if 0
    C=[4 0.1;0.1 1]; %covariance matrix
    mu=[30 6];  %mean
    plotOneGaussian(mu,C); pause %currently disabled
end

subplot(313)
C=[4   -1.4593;   -1.4593    2];
mu=[30 8];  %mean
plotOneGaussian(mu,C);
xlabel('x (customer age)'); 
text(23,6,'product C')

if 0
x=get(gcf, 'Position'); %get figure's position on screen
x(3)=floor(x(3)*0.6); %adjust the size making it "wider"
set(gcf, 'Position',x);
end
if 0
x=get(gcf, 'Position'); %get figure's position on screen
x(4)=floor(x(4)*1.2); %adjust the size making it "taller"
set(gcf, 'Position',x);
end

writeEPS('examplecorrelations','font12Only');
end

function plotOneGaussian(mu,C)
N=1000;     %number of examples
x=octave_mvnrnd(mu,C,N); %each row is a 2-d Gaussian vector
disp(['Below are the following info: specified Cov, empirical cov(), ' ...
    'empirical corrcoef() and empirical mean'])
if 0
    [row,col]= find(x(:,1)<0);
    x([row;col])=[0,0];
end
%show some info
C
corrcoef(x)
cov(x)
mean(x)
plot(x(:,1),x(:,2),'x') %plot data
end