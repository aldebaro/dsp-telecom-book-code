%plots for Laplace transform
%plot magnitude and phase of X(s)=(s-a)/[(s-b)(s-c)(s-c*)] varying the
%values of s in a grid
% Use y as rows and x as columns for better visualization
% that is: imaginary in rows and real part in columns.
close all
clf
a=1; b=-2; c=-1+1j*2; %choose poles and zeros
smin=-3; smax=3;
N=100;
svalues=linspace(smin,smax,N);
N=length(svalues);
Xs=zeros(N,N);
for x=1:N
    for y=1:N
        s=svalues(x)+1j*svalues(y);
        Xs(y,x)=(s-a)/((s-b)*(s-c)*(s-conj(c)));
    end
end

%% Plot magnitude
clf
%best_view=[13 11];
best_view=[15 9];
meshc(svalues,svalues,20*log10(abs(Xs)));
xlabel('\sigma')
ylabel('j\omega')
zlabel('20 log_{10} |X(s)|');
view(best_view);
writeEPS('s_mag')

%% Plot phase
mesh(svalues,svalues,unwrap(angle(Xs)));
hold on;
%show also pole and zero location
minValue=-10;
plot3(real(a),imag(a),minValue,'o','markersize',12)
plot3(real(b),imag(b),minValue,'x','markersize',12)
plot3(real(c),imag(c),minValue,'x','markersize',12)
plot3(real(c),-imag(c),minValue,'x','markersize',12)
xlabel('\sigma')
ylabel('j\omega')
zlabel('angle of X(s) (rad)');
view(best_view);
writeEPS('s_phase')

%% Zero pole representation
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

%% Superimpose the jw axis to magnitude
clf
meshc(svalues,svalues,20*log10(abs(Xs)));
hold on
wfreqs = linspace(-3,3,2*N);
s=1j*wfreqs;
Xs_in_w=(s-a)./((s-b).*(s-c).*(s-conj(c)));
plot3(real(s),imag(s),20*log10(abs(Xs_in_w)),'k','linewidth',2);
%plot
xlabel('\sigma')
ylabel('j\omega')
zlabel('20 log_{10} |X(s)|');
view(best_view);
writeEPS('s_mag_and_jw')

%plot only the response at the jw axis
clf
plot3(real(s),imag(s),20*log10(abs(Xs_in_w)),'k','linewidth',2);
%plot
xlabel('\sigma')
ylabel('j\omega')
zlabel('20 log_{10} |X(s)|');
view(best_view);
axis([-3 3 -3 3 -60 30])
grid
writeEPS('s_jw')

%plot the frequency response
[B,A]=zp2tf(a,[b;c;conj(c)],1); %in column vectorrs
freqs(B,A)  %calculate frequency response in rad/s
writeEPS('s_freqresponse')
close all