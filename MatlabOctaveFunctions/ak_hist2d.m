function [histogram,xaxis,yaxis]=ak_hist2d(x,y,num_binx,num_biny)
% function [n,xaxis,yaxis]=ak_hist2d(x,y,num_binx,num_biny)
% Outputs a 2-D histogram organized as matrix. 
% Default values: num_binx=10; num_biny=10;
% Example of usage:
% [histogram,xaxis,yaxis]=ak_hist2d(rand(1,N),rand(1,N),10,10)
% mesh(xaxis,yaxis,histogram); xlabel('x'); ylabel('y');

if nargin == 2 %assume default values
    num_binx=10; 
    num_biny=10;
end
x=x(:); y=y(:); %work with column vectors


nx = length(x); ny = length(y);
if nx ~= ny
   error('Vectors must have same length!');
end

minx=min(x);
miny=min(y);
maxx=max(x);
maxy=max(y);

%avoid numerical errors when minimum = maximum
if minx == maxx
    maxx = minx+2*eps;
end
if miny == maxy
    maxy = miny+2*eps;
end

deltax = (maxx - minx) / (num_binx - 1);
deltay = (maxy - miny) / (num_biny - 1);

xaxis = minx:deltax:maxx;
yaxis = miny:deltay:maxy;

% x=> columns and y=> lines
histogram = zeros(num_biny,num_binx);

nstepsx = 1 + round((x-minx) / deltax);  %added 1 because Matlab vectors start from 1
nstepsy = 1 + round((y-miny) / deltay);

for i=1:nx
   histogram(nstepsy(i),nstepsx(i)) = histogram(nstepsy(i),nstepsx(i)) + 1;
end

if nargout < 1
   mesh(xaxis,yaxis,histogram);
   xlabel('x');
   ylabel('y');
end
