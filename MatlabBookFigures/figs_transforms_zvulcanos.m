% Plot magnitude and phase of X(z)=(z-a)/[(z-b)(z-c)(z-c*)] varying
% the values of z in a grid.
% Use y as rows and x as columns for better visualization
% that is: imaginary in rows and real part in columns.
close all
clear all
clf

%% Calculate X(z)
a=-0.9; b=0.8; c=0.5+1j*0.6; %choose poles and zeros
zmin=-1; zmax=1;
N=100;
zvalues=linspace(zmin,zmax,N);
Xz=zeros(N,N);
for x=1:N
    for y=1:N
        z=zvalues(x)+1j*zvalues(y);
        %Use y as rows and x as columns for better visualization
        %that is: imaginary in rows and real part in columns
        Xz(y,x)=(z-a)/((z-b)*(z-c)*(z-conj(c)));
    end
end

%% Plot the magnitude of X(z)
clf
meshc(zvalues,zvalues,20*log10(abs(Xz)));
xlabel('real(z)')
ylabel('imaginary(z)')
zlabel('20 log_{10} |X(z)|');
view([-20 35]);
writeEPS('z_mag')
%pause

%plot phase
mesh(zvalues,zvalues,unwrap(angle(Xz)));
hold on;
%show also pole and zero location
minValue=-10;
plot3(real(a),imag(a),minValue,'o','markersize',12)
plot3(real(b),imag(b),minValue,'x','markersize',12)
plot3(real(c),imag(c),minValue,'x','markersize',12)
plot3(real(c),-imag(c),minValue,'x','markersize',12)
xlabel('real(z)')
ylabel('imaginary(z)')
zlabel('angle of X(z) (rad)');
view([-29 24]);
writeEPS('z_phase')
%pause

%zero pole representation
clf
zplane(a,[b;c;conj(c)]) %in column vectorrs
xlabel('real(z)')
ylabel('imaginary(z)')
writeEPS('z_polezero')
%pause

%will superimpose the unity circle
clf
meshc(zvalues,zvalues,20*log10(abs(Xz)));
hold on
zangles = linspace(0,2*pi,2*N);
z=exp(1j*zangles);
Xz_circle=(z-a)./((z-b).*(z-c).*(z-conj(c)));
plot3(real(z),imag(z),20*log10(abs(Xz_circle)),'k','linewidth',2);
%plot
xlabel('real(z)')
ylabel('imaginary(z)')
zlabel('20 log_{10} |X(z)|');
%view([-67 24]);
view([-20 35]);
writeEPS('z_mag_and_circle')
%pause

%plot only the response at the unity circle
clf
plot3(real(z),imag(z),20*log10(abs(Xz_circle)),'k','linewidth',2);
%plot
xlabel('real(z)')
ylabel('imaginary(z)')
zlabel('20 log_{10} |X(z)|');
view([-20 35]);
%view([-67 24]);
writeEPS('z_circle')
%pause

%plot the frequency response
[B,A]=zp2tf(a,[b;c;conj(c)],1); %in column vectorrs
freqz(B,A,'whole')
writeEPS('z_freqresponse')
