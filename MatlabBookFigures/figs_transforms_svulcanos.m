%plots for Laplace transform
%plot magnitude and phase of X(s)=(s-a)/[(s-b)(s-c)(s-c*)] varying the
%values of s in a grid
clf
a=1; b=-2; c=-1+j*2; %choose poles and zeros
smin=-3; smax=3;
N=100;
svalues=linspace(smin,smax,N);
N=length(svalues);
Xs=zeros(N,N);
for x=1:N
    for y=1:N
        s=svalues(x)+j*svalues(y);
        Xs(x,y)=(s-a)/((s-b)*(s-c)*(s-conj(c)));
    end
end

%plot magnitude
clf
meshc(svalues,svalues,20*log10(abs(Xs)));
ylabel('\sigma')
xlabel('j\omega')
zlabel('20 log_{10} |X(s)|');
view([-67 24]);
writeEPS('s_mag')

%plot phase
mesh(svalues,svalues,unwrap(angle(Xs)));
hold on;
%show also pole and zero location
minValue=-10;
plot3(imag(a),real(a),minValue,'o','markersize',12)
plot3(imag(b),real(b),minValue,'x','markersize',12)
plot3(imag(c),real(c),minValue,'x','markersize',12)
plot3(-imag(c),real(c),minValue,'x','markersize',12)
ylabel('\sigma')
xlabel('j\omega')
zlabel('angle of X(s) (rad)');
view([-15 12]);
writeEPS('s_phase')

%zero pole representation
clf
plot(a,0,'o','markersize',12,'linewidth',2);
hold on
plot(b,0,'x','markersize',12,'linewidth',2);
plot(c,'x','markersize',12,'linewidth',2);
plot(conj(c),'x','markersize',12,'linewidth',2);
xlabel('\sigma')
ylabel('j\omega')
line([-3,3],[0,0],'linewidth',1,'color','k')
line([0,0],[-3,3],'linewidth',1,'color','k')
grid
writeEPS('s_polezero')

%superimpose the jw axis
clf
meshc(svalues,svalues,20*log10(abs(Xs)));
hold on
wfreqs = linspace(-3,3,2*N);
s=j*wfreqs;
Xs_in_w=(s-a)./((s-b).*(s-c).*(s-conj(c)));
plot3(imag(s),real(s),20*log10(abs(Xs_in_w)),'k','linewidth',2);
%plot
ylabel('\sigma')
xlabel('j\omega')
zlabel('20 log_{10} |X(s)|');
view([-145 8]);
writeEPS('s_mag_and_jw')

%plot only the response at the jw axis
clf
plot3(imag(s),real(s),20*log10(abs(Xs_in_w)),'k','linewidth',2);
%plot
ylabel('\sigma')
xlabel('j\omega')
zlabel('20 log_{10} |X(s)|');
view([-145 8]);
axis([-3 3 -3 3 -60 30])
grid
writeEPS('s_jw')

%plot the frequency response
[B,A]=zp2tf(a,[b;c;conj(c)],1); %in column vectorrs
freqs(B,A)  %calculate frequency response in rad/s
writeEPS('s_freqresponse')
close all