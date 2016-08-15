function [a,k,E]=snip_frequency_Levinson_Durbin(R,p)
% function [a,k,E]=snip_frequency_Levinson_Durbin(R,p)
%Usage: x=randn(1,100)+linspace(1,5,100); p=10; R=xcorr(x,p);
%       R=R(p+1:end); %keep only values of interest: R(0)...R(p)
%       [a,k,E]=snip_frequency_Levinson_Durbin(R,p)
%Inputs:
% p - order of LPC analysis
% R - p+1 sample correlation function values, R(0)...R(p)
%Outputs:
% a - p LPC coefficients, from a(1) to a(p)
% k - p reflection coefficients, from k(1) to k(p)
% E - E energies of error, from E(1) to E(p)
%Initialization
k(1)=R(1+1)/R(0+1); a(1)=k(1); E(1)=R(0+1)*(1-k(1)^2);
%Recursion
for i=2:p
    k(i)=(R(i+1)-sum(a(1:i-1).*R(i:-1:2)))/E(i-1);
    a(i)=k(i);
    a(1:i-1)=a(1:i-1)-k(i)*a(i-1:-1:1);
    E(i)=E(i-1)*(1-k(i)^2);
end

