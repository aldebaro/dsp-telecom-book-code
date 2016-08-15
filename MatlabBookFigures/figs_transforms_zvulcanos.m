%plot magnitude and phase of X(z)=(z-a)/[(z-b)(z-c)(z-c*)] varying the values of
%z in a grid
close all, clear all
clf
a=-0.9; b=0.8; c=0.5+j*0.6; %choose poles and zeros
zmin=-1; zmax=1;
N=100;
zvalues=linspace(zmin,zmax,N);
Xz=zeros(N,N);
for x=1:N
    for y=1:N
        z=zvalues(x)+j*zvalues(y);
        Xz(x,y)=(z-a)/((z-b)*(z-c)*(z-conj(c)));
    end
end

%plot magnitude
clf
meshc(zvalues,zvalues,20*log10(abs(Xz)));
ylabel('real(z)')
xlabel('imaginary(z)')
zlabel('20 log_{10} |X(z)|');
view([-67 24]);
writeEPS('z_mag')

%plot phase
mesh(zvalues,zvalues,unwrap(angle(Xz)));
hold on;
%show also pole and zero location
minValue=-5;
plot3(imag(a),real(a),minValue,'o','markersize',12)
plot3(imag(b),real(b),minValue,'x','markersize',12)
plot3(imag(c),real(c),minValue,'x','markersize',12)
plot3(-imag(c),real(c),minValue,'x','markersize',12)
ylabel('real(z)')
xlabel('imaginary(z)')
zlabel('angle of X(z) (rad)');
view([-15 12]);
writeEPS('z_phase')

%zero pole representation
clf
zplane(a,[b;c;conj(c)]) %in column vectorrs
xlabel('real(z)')
ylabel('imaginary(z)')
writeEPS('z_polezero')

%will superimpose the unity circle
clf
meshc(zvalues,zvalues,20*log10(abs(Xz)));
hold on
zangles = linspace(0,2*pi,2*N);
z=exp(j*zangles);
Xz_circle=(z-a)./((z-b).*(z-c).*(z-conj(c)));
plot3(imag(z),real(z),20*log10(abs(Xz_circle)),'k','linewidth',2);
%plot
ylabel('real(z)')
xlabel('imaginary(z)')
zlabel('20 log_{10} |X(z)|');
view([-67 24]);
writeEPS('z_mag_and_circle')

%plot only the response at the unity circle
clf
plot3(imag(z),real(z),20*log10(abs(Xz_circle)),'k','linewidth',2);
%plot
ylabel('real(z)')
xlabel('imaginary(z)')
zlabel('20 log_{10} |X(z)|');
view([-67 24]);
writeEPS('z_circle')

%plot the frequency response
[B,A]=zp2tf(a,[b;c;conj(c)],1); %in column vectorrs
freqz(B,A,'whole')
writeEPS('z_freqresponse')