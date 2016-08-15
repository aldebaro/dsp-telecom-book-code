function y=ak_areColumnsOrthonormal(A)
% function y=ak_areColumnsOrthonormal(A)
%Returns y=1 if the columns of matrix A are orthonormal to each other
%and 0 otherwise. The matrix A is not required to be square.

tolerance = 1e-13; %threshold to allow numerical errors
Ah = A'; %assume the inverse is the Hermitian
allInnerProducts = Ah*A; %this result should be the identity matrix
error = allInnerProducts - eye(size(allInnerProducts)); %get the error
maxAbsoluteError = max(abs(error(:)));
if maxAbsoluteError > tolerance 
    y=0;
else
    y=1;
end