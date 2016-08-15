% Create figure
clf
figure1 = figure(1);

% Create ellipse
annotation(figure1,'ellipse',[0.1245 0.3889 0.374 0.2996]);

% Create ellipse
annotation(figure1,'ellipse',[0.2606 0.3788 0.374 0.2996]);

% Create textbox
annotation(figure1,'textbox',[0.5134 0.4494 0.128 0.09921],...
    'String',{'Time-','invariant'},...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',[0.1577 0.4673 0.0878 0.05952],...
    'String',{'Linear'},...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',[0.3504 0.5742 0.06036 0.05952],...
    'String',{'LTI'},...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',[0.328 0.477 0.0878 0.05952],...
    'String',{'LCCDE','(rest)'},...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create ellipse
annotation(figure1,'ellipse',[0.3075 0.4212 0.13016 0.13]);

writeEPS('ltidiagram','none')

clf
close all
%illustrate convolution
x=[2 -3]; nx=[0 1];
h=[1 -2 1]; nh=[0 1 2];
y=x(1)*[h 0]+x(2)*[0 h];
myaxis=[-1 4 -4 6];

subplot(321);
stem(nx,x); axis(myaxis); 
ylabel('x[n]')
subplot(322);
stem(0:3,y); axis([-1 4 -10 10]); ylabel('y[n]')
subplot(323);
stem(nx(1),x(1)); axis(myaxis); 
ylabel('1st impulse')
subplot(324);
stem(nh+nx(1),x(1)*h); axis(myaxis); 
ylabel('2h[n]')
subplot(325);
stem(nx(2),x(2)); axis(myaxis); 
ylabel('2nd impulse')
subplot(326);
stem(nh+nx(2),x(2)*h); axis(myaxis); 
ylabel('-3h[n-1]')
writeEPS('convolution_example')

clf
snip_systems_continuous_discrete_conv
writeEPS('continuous_discrete_conv')