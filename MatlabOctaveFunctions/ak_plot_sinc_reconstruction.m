function ak_plot_sinc_reconstruction(n, x, Ts, t_oversampled, xo, ...
    t_oversampled_expanded,x_reconstructed,x_parcels)
%function ak_plot_sinc_reconstruction(n, x, Ts, t_oversampled, xo,...
%    t_oversampled_expanded,x_reconstructed,x_parcels)
%See ak_sinc_reconstruction.m

figure(1)
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
plot(t_oversampled, xo)
hold on
plot(t_oversampled_expanded,x_reconstructed,'r-'); %,'--','LineWidth',1.5);
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

num_discrete_samples = length(x);
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
