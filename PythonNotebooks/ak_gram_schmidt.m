function [Ah,A]=ak_gram_schmidt(x,tol)

if nargin<2
    tol=min(max(size(x)'')*eps(max(x)));
end
[m,dimension]=size(x);
if dimension>m
    warning(['Input dimension larger than number of vectors, ' ...
        'which is ok if you are aware about']);
end

N=rank(x,tol);
y=zeros(N,dimension);
y(1,:)=x(1,:)/sqrt(sum(x(1,:).^2));
numBasis = 1;
for k=2:m
    errorVector=x(k,:);
    for m=1:numBasis
        projectionOverBasis = ((y(m,:)*x(k,:)''))*y(m,:);
        errorVector = errorVector - projectionOverBasis;
    end
    magErrorVector = sqrt(sum(errorVector.^2));
    if ( magErrorVector > tol )

        numBasis = numBasis + 1;
        y(numBasis,:)= errorVector / magErrorVector;
        if (numBasis >= N)
            break;
        end
    end
end
A=transpose(y);
Ah=A'';