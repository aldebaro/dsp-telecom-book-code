function [x_reconstructed, x_parcels, t_oversampled, ...
    t_oversampled_expanded] = ak_sinc_reconstruction(n, x, Ts, ...
    n_oversampled, xo, textra)
%function [x_reconstructed, x_parcels, t_oversampled, ...
%    t_oversampled_expanded] = ak_sinc_reconstruction(n, x, Ts, ...
%    n_oversampled, xo, textra)
%% Illustrate perfect sinc reconstruction
%Inputs:
%n - vector with integers as abscissa of x
%x - samples of signal to be reconstructed
%Ts - sampling interval (in seconds)
%n_oversampled - vector with integers as abscissa of oversampled x
%xo - oversampled x, to be used for comparison purposes
%textra - extra time (in s) to be added for visualization purposes
%Outputs:
%x_reconstructed - reconstructed signal
%x_parcels - matrix with individual sincs used in x_reconstructed
%t_oversampled - discrete-time in seconds, corresponding to
%                input n_oversampled multiplied by the oversampled Ts
%t_oversampled_expanded - similar to t_oversampled but with the
%                         addition of textra in the beginning and end
if nargin < 6
    textra = 0; %5*Ts;
end
if sum(logical(rem(n,1))) ~= 0 %check if vector has only integers
     error('Elements of vector n must be integers!')
end
if sum(logical(rem(n_oversampled,1))) ~= 0 %check if integers
     error('Elements of vector n_oversampled must be integers!')
end

num_discrete_samples = length(x);
if length(n) ~= num_discrete_samples
    error('Lengths of n and xn must be the same!')
end

num_oversampled_samples = length(xo);
if length(n_oversampled) ~= num_oversampled_samples
    error('Lengths of n_oversampled and xo must be the same!')
end

%oversampling factor can be found by
%N_o = L (N-1) + 1, where N is the number of samples
%in x and L is the oversampling factor
oversampling_factor = (num_oversampled_samples-1) / (num_discrete_samples-1);
if mod(oversampling_factor,1) ~= 0
    error('Oversampling factor must be an integer!')
end
oversampled_Ts = Ts/oversampling_factor;

%% Create expanded time axis to help visualation if requested
%get number of samples to be added before and after original signal
nextra = ceil(textra/oversampled_Ts); 

n_oversampled_expanded = n_oversampled(1)-nextra:n_oversampled(end)+nextra;
t_oversampled_expanded = n_oversampled_expanded*oversampled_Ts;

total_samples = length(t_oversampled_expanded);
%% Find parcel corresponding to each sinc and sum them to
% compose x_reconstructed
x_parcels = zeros(num_discrete_samples, total_samples);
x_reconstructed = zeros(1, total_samples);
for ncounter=1:num_discrete_samples
    this_n = n(ncounter); %value of n, for instance, n=-4
    %Sinc delayed by this_n*Ts:
    this_sinc=x(ncounter)*sinc((t_oversampled_expanded-this_n*Ts)/Ts);
    x_parcels(ncounter,:)=this_sinc; %save this sinc
    x_reconstructed = x_reconstructed + this_sinc; %add sinc contribution
end

%create vector in case one wants to plot results
t_oversampled = n_oversampled*oversampled_Ts;
if nargout < 1
    %plot results
    ak_plot_sinc_reconstruction(n, x, Ts, t_oversampled, xo, ...
        t_oversampled_expanded,x_reconstructed,x_parcels);
end
