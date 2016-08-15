function ak_timeplot(x,y,varargin)
% function ak_timeplot(x,y,varargin)
%Plots the time series y in abscissa x

linewidth = 2;

plot(x,y,'LineStyle','-', 'LineWidth',linewidth, ...
    varargin{:});

xlabel('Time (s)');
ylabel('Amplitude');