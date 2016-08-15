function y=ak_qfuncinv(x)
% function y=ak_qfuncinv(x)
%Inverse Q function using erfcinv.
y = sqrt(2) * erfcinv(2*x);