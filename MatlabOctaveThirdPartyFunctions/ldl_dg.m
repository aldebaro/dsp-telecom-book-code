function [L D] = ldl_dg(A)
% function [L D] = ldl_dg(A)
%Returns a Cholesky decomposition of A=L*D*L' where
%L is a lower tringular matrix
%D is a diagonal matrix
%This function is used instead chol(), because chol() sometimes
%permutes the lines of the input matrix.
%Example:
% A=[8 2; 2 4];
% R=chol(A,'lower'); %choose the lower triangular instead of upper
% R*R'-A %check the decomposition via chol
% [L D] = ldl_dg(A); %invoke this function decomposition
% L*D*L'-A %check the decomposition via this function
% R2=L*sqrt(D); %convert into a result similar to chol: R2 = R
%By Diego Gomes - UFPA - 2014.

%[r c] = size(A);
%X=zeros(1,c);
%D=diag(X);
L=zeros(size(A));
[n temp]=size(A);
d=zeros(1,n);
for j=1:n
    L(j,j)=1;
    S=A(j,j);
    for k=1:j-1
        S=S-d(k)*L(j,k)*conj(L(j,k));
    end
    d(j)=S;
    for i=j+1:n
        L(j,i)=0;
        S=A(i,j);
        for k=1:j-1
            S=S-d(k)*L(i,k)*conj(L(j,k));
        end
        L(i,j)=S/d(j);
    end
end
D=diag(d);
return