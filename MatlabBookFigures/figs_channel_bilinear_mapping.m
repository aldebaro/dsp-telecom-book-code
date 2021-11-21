%Shows how to map points in z plane to s plane and vice-versa
close all
%figure(1)
N=11; 
%unit circle in z plane
z_plane_points=exp(1j*linspace(0,2*pi-(2*pi/N),N));
Fs=8;
ak_map_z_into_s(z_plane_points,Fs);
writeEPS('bilinear_map1');

%figure(2)
clf
N=11; 
%unit circle in z plane
%unit circle in z plane
z_plane_points=exp(1j*linspace(0,2*pi-(2*pi/N),N));
Fs=150;
ak_map_z_into_s(z_plane_points,Fs);
writeEPS('bilinear_map2');

%figure(3)
clf
N=11; 
smin=-20;
smax=20;
%jw in s plane
s=linspace(smin,smax,N);
s_plane_points=0+1j*s;
Fs=8;
ak_map_s_into_z(s_plane_points,Fs);
writeEPS('bilinear_map3');

%figure(4)
clf
N=11; 
smin=-20;
smax=20;
%s plane numbers at left and right side of jw
s=linspace(smin,smax,N);
s_plane_points=s+1j*s;
Fs=8;
ak_map_s_into_z(s_plane_points,Fs);
writeEPS('bilinear_map4');

