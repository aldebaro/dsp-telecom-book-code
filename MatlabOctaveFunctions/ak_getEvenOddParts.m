function [x_even, x_odd] = ak_getEvenOddParts(x,n)
% function [x_even, x_odd] = ak_getEvenOddParts(x,n)
%Obtain the even and odd parts of a signal.
%It takes samples of a signal x[n] organized in a vector x
%of N elements and the consecutive integer values of n for
%these N elements, to calculate its even and odd components.
%Examples of a step, parabola and triangle, respectively:
%x=[0 0 0 1 1 1 1 1]; n=-3:4; ak_getEvenOddParts(x,n);
%n=1:100; x=n.^2; ak_getEvenOddParts(x,n);
%M=40;x=[(0:M) (M-1:-1:0)]; n=20+(0:2*M); ak_getEvenOddParts(x,n);

x=x(:); %make it a column vector
n=n(:); %make it a column vector
N = length(n); %number of elements
if length(x) ~= N
    disp(['Error: length(x)=' num2str(length(x)) ...
        ' and length(n)=' num2str(N)])
    error('Vectors need to have same number of elements!')
end

%create x[-n]
minus_n = flipud(-n);
x_minus_n = flipud(x);

%find the minimum values
minimum_n = min([n; minus_n]);
maximum_n = max([n; minus_n]);

n_new = minimum_n:maximum_n; %create a new range

%create new vectors with enough elements to hold all samples
x_new = zeros(length(n_new), 1);
x_minus_n_new = zeros(length(n_new), 1);

%copy vectors with original range n to vectors with
%the new range n_new
x_relative_index = find(n_new == min(n));
x_new(x_relative_index:x_relative_index+N-1) = x;

x_relative_index = find(n_new == min(minus_n));
x_minus_n_new(x_relative_index:x_relative_index+N-1) = x_minus_n;

%find the even and odd components
x_even = 0.5*(x_new + x_minus_n_new);
x_odd = 0.5*(x_new - x_minus_n_new);

if nargout < 1 %plot the output
    subplot(311)
    %stem(n,x) %use the original range of n
    stem(n_new,x_new) %new range of n
    ylabel('x[n]')
    subplot(312), stem(n_new,x_even)
    ylabel('x_{even}[n]')
    subplot(313), stem(n_new,x_odd)
    ylabel('x_{odd}[n]')
    xlabel('n')
end