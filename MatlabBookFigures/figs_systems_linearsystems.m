%generate a 3-d representation of the system H(z)=3 - 2z^(-1).
clear all
close all
clf
randn('state',0) %set seed
%first just get some output values from an example of input x[n]
N=20;

if 0 %figure was hard to understand, take it out
    r=linspace(1,2,N); %a line segment
    x=r+randn(1,N); %add noise
    %y=filter([3 -2],1,x); %filter with B(z)=3-2z^(-1) and A(z)=1
    xnm1=[0 x(1:N-1)]; %organize x[n-1] in vector
    y=3*x-2*xnm1;
    subplot(121)
    plot3(x,xnm1,y)
    xlabel('x[n]')
    ylabel('x[n-1]')
    zlabel('y[n]')
    grid
    subplot(122)
end
%now use a grid for easier visualization
x=[0 linspace(-2,4,N)]; %make (0,0) the first point
xnm1=[0 linspace(-2,4,N)];
y=zeros(N,N);
for i=1:N+1
    for j=1:N+1
        y(i,j)=3*x(j)-2*xnm1(i);
    end
end
hobj=mesh(x,xnm1,y)
xlabel('x[n]')
ylabel('x[n-1]')
zlabel('y[n]')
makedatatip(hobj,[1; 1; 1]) %use this trick because (0,0) is the first point

writeEPS('linear_systems')