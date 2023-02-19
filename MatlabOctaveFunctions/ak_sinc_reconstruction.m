function ak_sinc_reconstruction(n, x, Ts, n_oversampled, xo, textra)
%% Illustrate perfect sinc reconstruction
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

if nargout < 1
    figure(1)
    %t in seconds
    t_oversampled = n_oversampled*oversampled_Ts;    
    subplot(411)
    plot(t_oversampled, xo)
    xlabel('t (s)'), ylabel('Original x(t)')
    axis tight

    subplot(413)
    stem(n, x)
    xlabel('Discrete-time n')
    ylabel('x[n]')
    grid
    
    subplot(412)
    t = n*Ts; 
    %T=0.2; ak_sampledsignalsplot(x,[],T,'color','r')
    ak_sampledsignalsplot(x, t, [], 'color', 'b')
    hold on
    plot(t,zeros(1,length(t)),'color','b');
    xlabel('t (s)')
    ylabel('x_s(t)')
    axis tight
    grid
    
    subplot(414)
    plot(t_oversampled_expanded,x_reconstructed); %,'--','LineWidth',1.5);
    hold on
    plot(t_oversampled, xo,'r-')
    myaxis = axis;
    myaxis(1) = t_oversampled(1);
    myaxis(2) = t_oversampled(end);
    axis(myaxis)
    legend('Original','Reconstructed')
    %axis tight
    ylabel('x(t)')
    xlabel('t (s)')
    ak_changeFigureSize(1.5, 1.5) %expand figure

    %% Show the parcels (each sinc) in sinc reconstruction
    figure(2)
    
    plot(t_oversampled_expanded,x_reconstructed,'LineWidth',1.5);
    %C=colororder; %Octave does not recognize it
    C=get(gca,"colororder");
    newcolors = [0.83 0.14 0.14
             1.00 0.54 0.00
             0.47 0.25 0.80];
    C=[C(1,:)
        newcolors
        C(2:end,:)];
    %colororder(C); %Octave does not recognize it
    set(gca,"colororder",C);
    [num_colors, ~] = size(C);
    hold on
    for i=1:num_discrete_samples
        j=rem(i,num_colors-1)+2; %skip the color already used
        plot(t_oversampled_expanded,x_parcels(i,:),'--','Color',C(j,:));
        stem(n*Ts,x,'Color',C(j,:));
        plot(n(i)*Ts,x(i),'x','MarkerSize',20,'Color',C(j,:),'LineWidth',2.5);
    end
    y_zeros = t_oversampled_expanded(1):Ts:t_oversampled_expanded(end);
    stem(y_zeros,zeros(1,length(y_zeros)),'o','Color','k');
    xlabel('t (s)');
    ylabel('Reconstructed x(t)')
    hold off
    axis tight
    ak_changeFigureSize(1.5, 1.5) %expand figure
end