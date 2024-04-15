function [Ah,A]=ak_gram_schmidt(x,tol)
% function [Ah,A]=ak_gram_schmidt(x,tol)
%Gram-Schmidt orthonormalization procedure (x is real)
%Inputs:  x - real matrix: each row is an input vector
%         tol - tolerance for stopping procedure (and SVD)
%Outputs: Ah  - direct matrix, which is the Hermitian (transpose in
%               this case) of A
%         A   - inverse matrix with basis functions as columns
%Example of usage:
% x=[1 1; 0 2; 1 0; 1 4]
% [Ah,A]=ak_gram_schmidt(x,1e-12) %basis functions are columns of A
% testVector=[10; 10]; %test: vector in same direction as first basis
% testCoefficients=Ah*testVector %result is [14.1421; 0]

%% Notes about the code:
%1) The inner product sum(y(m,:).*x(k,:)) is alternatively
%   calculated as y(m,:)*x(k,:)' (row vectors)       
%2) In general, a projection is projectionOverBasis=p_xy=
%             ( <y,x> / ||y||^2 ) * y =
%             ((y(m,:)*x(k,:)')/(y(m,:)*y(m,:)'))*y(m,:);
%but in the code y(m,:)*y(m,:)'=1 and the denominator is 1
if nargin<2
    tol=min(max(size(x)')*eps(max(x))); %find tolerance
end
[m,dimension]=size(x);
if dimension>m
    warning(['Input dimension larger than number of vectors, ' ...
        'which is ok if you are aware about']);
end
N=rank(x,tol); %note: rank is slow because it uses SVD
y=zeros(N,dimension); %pre-allocate space
%pick first vector and normalize it
y(1,:)=x(1,:)/sqrt(sum(x(1,:).^2));
numBasis = 1;
for k=2:m
    errorVector=x(k,:); %error (or target) vector
    for m=1:numBasis%go over all previously selected basis
        %p_xy = <x,y> * y; %recall, in this case: ||y||=1
        projectionOverBasis = ((y(m,:)*x(k,:)'))*y(m,:);
        %update target:
        errorVector = errorVector - projectionOverBasis;
    end
    magErrorVector = sqrt(sum(errorVector.^2));
    if ( magErrorVector > tol )
        %keep the new vector in basis set
        numBasis = numBasis + 1;
        y(numBasis,:)= errorVector / magErrorVector;
        if (numBasis >= N)
            break; %Abort. Reached final number of vectors
        end
    end
end
A=transpose(y);  %basis functions are the columns of inverse matrix A
Ah=A'; %the direct matrix transform is the Hermitian of A

disp(y);
disp(A);
disp(Ah);