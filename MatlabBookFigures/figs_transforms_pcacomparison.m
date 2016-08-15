close all
clear all
%generate N two-dimensional Gaussian vectors
C=[1 0.9   %covariance matrix
    0.9 4];
mu=[1 3];  %mean
N=500;     %number of examples
randn('state',3); %set seed to allow replicating result
x=octave_mvnrnd(mu,C,N); %each row is a 2-d Gaussian vector

%plot data
plot(x(:,1),x(:,2),'x')
axis([-4 10 -4 10])
xlabel('x_1'); ylabel('x_2')
set(gca,'DataAspectRatio',[1 1 1]) %relative magnitudes along each axis

%find Gram-Schmidt basis
[Ah_gs,A_gs]=ak_gram_schmidt(x); %vectors are organized in columns
h=ak_drawvector(A_gs(1,1),A_gs(2,1))
set(h,'color','red');
h=ak_drawvector(A_gs(1,2),A_gs(2,2))
set(h,'color','red');
text(A_gs(1,1),A_gs(1,2),'Gram-Schmidt','FontSize',12,'FontWeight',...
    'bold','color','red')

%find PCA basis: columns of A
[Ah,A,V] = ak_pcamtx(x)
h=ak_drawvector(A(1,1),A(2,1))
h=ak_drawvector(A(1,2),A(2,2))

text(-3,1,'PCA','FontSize',12,'FontWeight',...
    'bold','color','black')

writeEPS('compare_pca_gramschmidt','font12Only');

%now project the data using PCA
clf
%need to multiply N vectors by PCA matrix Ah but want to avoid a loop
%note: if x and y are column vectors, then y = Ah x. Alternatively, one
%could use row vectors: y^T = (Ah x)^T = x^T Ah^T
if 1 %subtract the mean
    means_replicated = repmat(mu,N,1); %to subtract the mean
    %y=transpose(transpose(Ah)*transpose(x-means_replicated));
    y=Ah*transpose(x-means_replicated);
else
    y=Ah*transpose(x);
    %y=transpose(transpose(Ah)*transpose(x));
end
plot(x(:,1),x(:,2),'x') %obs: row vectors
hold on
plot(y(1,:),y(2,:),'r+') %obs: column vectors
xlabel('x_1 for original data and y_1 for PCA'); 
ylabel('x_2 for original data and y_2 for PCA'); 
legend('original data','PCA transformed')
writeEPS('pca_projecteddata','font12Only');

%now project the data using Gram-Schmidt
clf
%need to multiply N vectors by Gram-Schmidt matrix A_gs but want to avoid
%a loop
%note: if x and y are column vectors, then y = Ah x. Alternatively, one
%could use row vectors: y^T = (Ah x)^T = x^T Ah^T

%y=transpose(transpose(A_gs)*transpose(x));
y=Ah_gs*transpose(x);
plot(x(:,1),x(:,2),'x') %obs: row vectors
hold on
plot(y(1,:),y(2,:),'r+') %obs: column vectors
xlabel('x_1 for original data and y_1 for Gram-Schmidt'); 
ylabel('x_2 for original data and y_2 for Gram-Schmidt'); 
legend('original data','Gram-Schmidt transformed')
writeEPS('gram-schmidt_projecteddata','font12Only');