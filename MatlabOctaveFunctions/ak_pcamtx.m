function [Ah,A,lambdas] = ak_pcamtx(data)
% function [Ah,A,lambdas] = ak_pcamtx(data)
%Principal component analysis (PCA).
%Input:
%  data - M x D input matrix (M vectors of dimension D each)
%Outputs: 
%  Ah - direct matrix, Hermitian (transpose in this case) of A
%  A  - inverse matrix with principal components (or eigenvectors) in
%       each column
%  lambdas - Mx1 matrix of variances (eigenvalues)
%Example of usage:
%x=[1 1; 0 2; 1 0; 1 4]
%[Ah,A]=ak_pcamtx(x) %basis functions are columns of A
%testVector=[1; 1]; %test: vector in same direction as first basis
%testCoefficients=Ah*testVector %result is [0.9683; -1.0307]
covariance = cov(data); % calculate the covariance matrix
[pc,lambdas]=eig(covariance);%get eigenvectors/eigenvalues
lambdas = diag(lambdas); % extract the matrix diagonal
[temp,indices]= sort(-1*lambdas);%sort in decreasing order
lambdas = lambdas(indices); %rearrange
A = pc(:,indices); %obtain sorted principal components: columns of A
Ah=A'; %provide also the direct transform matrix (Hermitian of A)
