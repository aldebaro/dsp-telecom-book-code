function s_plane_points=ak_map_z_into_s(z_plane_points,Fs)
z_plane_points = transpose(z_plane_points(:)); %make it a row vector
N=length(z_plane_points);
s_plane_points = zeros(1,N);
for i=1:N
    %for each z find corresponding s using bilinear transformation
    %use bilinear transformation
    s_plane_points(i)=(2*Fs*(z_plane_points(i)-1))./(z_plane_points(i)+1); 
end
subplot(121)
hold on
plot_numbers_in_plane(s_plane_points);
plot_jw()
subplot(122)
hold on
plot_numbers_in_plane(z_plane_points);
plot_unit_circle()
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