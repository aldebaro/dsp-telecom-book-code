x=[2,2]; %define a vector x
y=[5,1]; %define a vector y
magx=sqrt(sum(x.*x))%magnitude of x
magy=sqrt(sum(y.*y))%magnitude of y
innerprod=sum(x.*y) %<x,y>=||x|| ||y|| cos(theta)
theta=acos(innerprod / (magx*magy)) %angle between x and y
%obs: could use acosd to have angle in degrees
disp(['Angle is ' num2str(180*theta/pi) ' degrees']);
%check if inverting direction is needed:
invertDirection=1; if theta>pi/2 invertDirection=-1; end
%find the projection of x over y (called p_xy) and p_yx
mag_p_xy = magx*abs(cos(theta)) %magnitude of p_xy
%directions: obtained as y normalized by magy, x by magx
y_unitary=y/magy; %normalize y by magy to get unitary vec.
p_xy = mag_p_xy * y_unitary* invertDirection %p_xy
mag_p_yx = magy*abs(cos(theta)); %magnitude of p_yx
x_unitary=x/magx; %normalize x by magx to get unitary vec.
p_yx = mag_p_yx * x_unitary* invertDirection %p_yx
%test orthogonality of error vectors:
error_xy = x - p_xy; %we know: p_xy + error_xy = x
sum(error_xy.*y) %this inner product should be zero
error_yx = y - p_yx; %we know: p_yx + error_yx = y
sum(error_yx.*x) %this inner product should be zero

