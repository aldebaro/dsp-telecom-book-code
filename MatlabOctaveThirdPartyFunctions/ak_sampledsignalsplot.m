function ak_sampledsignalsplot(x,t,T,varargin)
% function ak_sampledsignalsplot(x,t,T,varargin)
%Plots the time series x as impulses. The abscissa is t as time-axis or
%generated automatically with T as sampling interval.
%The distinction with respect to ak_impulseplot is that this function does
%not plot the zero values
%Examples:
% x=1:3; t=1:0.5:2; ak_sampledsignalsplot(x,t,[],'color','r')
% T=0.5; ak_sampledsignalsplot(x,[],T,'color','r')

%Check syntax:
if isempty(t)
    if isempty(T)
        error(['You need to specify the time-axis t or the ' ...
        'sampling interval T']);
    end
    if ~isnumeric(T)
        error('Syntax error: T must be numeric (when specified)');
    end
    %generate time-axis
    t=0:T:(length(x)-1)*T;
else
    if nargin > 2 %allow the user specify only two parameters
        if ~isempty(T)
            error(['You cannot specify both the time-axis t and the ' ...
            'sampling interval T. Check the syntax']);
        end    
    end
end

%AK April 24 - 2021
%because negative impulses were having different colors than positive ones
%I am defining a default color:
if isempty(varargin)
    varargin={'color','b'};
end

%remember whether hold is on or off
holdison = 0;
if ishold
    holdison = 1;
end
%add some extra comments to stem for plotting an arrowhead
%do not forget to pass it the other parameters in varargin{:}

indicesPos = find(x>0);
indicesNeg = find(x<0);
indicesZero = find(x==0);

markersize = 9;
linewidth = 2;

stem(t(indicesPos),x(indicesPos),'marker','^','markersize',markersize,...
    'color','b',...
    'markerfacecolor','auto', ...
    'LineStyle','-', 'LineWidth',linewidth, ...
    varargin{:});
hold on
stem(t(indicesNeg),x(indicesNeg),'marker','v','markersize',markersize,...
    'color','b',...
    'markerfacecolor','auto', ...
    'LineStyle','-', 'LineWidth',linewidth, ...
    varargin{:});
if 0 %do not plot
stem(t(indicesZero),x(indicesZero),'marker','o','markersize',markersize,...
    'markerfacecolor','auto', ...
    'LineStyle','-', 'LineWidth',linewidth, ...
    varargin{:});
end

plot(t,zeros(size(t)),varargin{:}); %plot line to represent zeros


%restore previous hold situation
hold off
if holdison==1
    hold on
end

xlabel('Time (s)');
ylabel('Amplitude');
