function z_plane_points=ak_map_s_into_z(s_plane_points,Fs)
s_plane_points = transpose(s_plane_points(:)); %make it a row vector
N=length(s_plane_points);
z_plane_points = zeros(1,N);
Ts=1/Fs;
for i=1:N
    %for each s find corresponding z using bilinear transformation
    z_plane_points(i)=((2+Ts*s_plane_points(i)))./(2-Ts*s_plane_points(i)); 
end
subplot(121)
hold on
plot_numbers_in_plane(z_plane_points);
plot_unit_circle()
subplot(122)
hold on
plot_numbers_in_plane(s_plane_points);
plot_jw()
end

function plot_numbers_in_plane(points)
myaxis=[min([real(points), -2]) max([real(points), 2]) ...
    min([imag(points), -2]) max([imag(points), 2])];
axis(myaxis);
axis equal
N=length(points);
for i=1:N
    plot(real(points(i)), imag(points(i)), '.');
    text(real(points(i)), imag(points(i)), num2str(i));
end
end

function plot_unit_circle()
w=linspace(0,2*pi,500);
c=exp(1j*w);
plot(real(c),imag(c));
xlabel('real(z)')
ylabel('imag(z)')
title('z plane')
end

function plot_jw()
myaxis=axis;
line([myaxis(1),myaxis(2)],[0,0]);
line([0,0],[myaxis(3),myaxis(4)]);
xlabel('real(s) = \sigma')
ylabel('imag(s) = j \omega')
title('s plane')
end