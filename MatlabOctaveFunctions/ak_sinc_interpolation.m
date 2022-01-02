function [xt, t, x_parcels] = ak_sinc_interpolation(xn, Ts, origin_n0)
%function [xt, t, x_parcels] = ak_sinc_interpolation(xn, Ts, origin_n0)
if nargin < 2
    Ts = 1;
end
if nargin < 3
    origin_n0 = 0; %assume x[n] starts at 0
end
textra = 5*Ts;
nextra = ceil(textra/Ts);

num_discrete_samples = length(xn);
t0 = origin_n0*Ts;

nstart = origin_n0-nextra;
nend = origin_n0+nextra;

tend = nstart*Ts;
tstart = nend*Ts;

%% Adopt a faster sampling rate for increased resolution
L=2000; %oversampling factor
%use m=n*L instead of n to relate m and n
mstart = nstart*L;
mend = nend*L;
total_samples = mend - mstart + 1;

x_parcels = zeros(num_discrete_samples, total_samples);
xt = zeros(1, total_samples);
T=Ts/L; %small sampling interval for increased resolution
t = (mstart:mend)*T;
n = origin_n0:num_discrete_samples-1; %assume it simply increments

%I will assume that the function can be truncated when it has ~30 zero
%crossings
for nn=1:num_discrete_samples
    this_n = n(nn);
    %We are always delaying signals by n*Ts
    my_sinc=xn(nn)*sinc((t-this_n*Ts)/Ts); %this sinc will have its first zero at Tsym
    x_parcels(nn,:)=my_sinc;    
    xt = xt + my_sinc;
end

if nargout < 1
    clf
    plot(t,xt,'-','LineWidth',1.5);
    hold on
    plot(t,x_parcels);
    stem(n*Ts,xn,'Color','b');
    plot(n*Ts,xn,'x','MarkerSize',20,'Color','b');
    hold off
end