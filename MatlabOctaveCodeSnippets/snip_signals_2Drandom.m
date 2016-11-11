N = 100000; %number of 2-d vectors
mu=[2 3]; %mean
C=[1 0.5 ; 0.5 10]; %covariance matrix
r = octave_mvnrnd(mu,C,N); %octave_mvnrnd or mvnrnd 
numbiny = 30; numbinx = 30; %number of bins for histogram
Cest=cov(r) %check estimated covariance matrix (should be close to C)
mu_est=mean(r) %estimated mean
R=C+mu'*mu %theoretical correlation matrix
Rest=Cest + mu_est'*mu_est %estimated correlation matrix
[n,xaxis,yaxis]=ak_hist2d(r(:,1),r(:,2),numbinx,numbiny); %histogram
mesh(xaxis,yaxis,n); pause %plot histogram
contour(xaxis,yaxis,n); xlabel('x1'); ylabel('x2'); %and its countour


