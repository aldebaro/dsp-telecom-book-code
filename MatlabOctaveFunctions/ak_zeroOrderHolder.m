function y=ak_zeroOrderHolder(x, L)
% function y=ak_zeroOrderHolder(x, L)
%Repeat L times each value of array x, mimicking a zero-order 
%holder (ZOH). Look at alternative implementations at:
%http://www.mathworks.com/matlabcentral/answers/46898-repeat- ...
%    element-of-a-vector-n-times-without-loop
%Example:
%  L=2; y=ak_zeroOrderHolder(1:3, L)
%outputs
%  y=[1     1     2     2     3     3]
x=transpose(x(:)); %make x a row vector
y=ones(L,1)*x; %matrix with repetitions. Could use repmat function
y=transpose(y(:)); %make y a row vector