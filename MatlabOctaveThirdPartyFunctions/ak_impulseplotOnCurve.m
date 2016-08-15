function ak_impulseplotOnCurve(abscissa,starts,stops,previousAxis,...
    varargin)
%function ak_impulseplotOnCurve(abscissa,starts,stops,...
%    previousAxis,varargin)
%Plots impulses with abcissas given by the first parameter, and
%the impulse heights given by "starts" and "stops", which corresponds
%to the ordinates: the i-th impulse starts at starts(i) and ends at
%stops(i). This funcion uses the
%third party code "arrow", which requires dealing with axis. Hence, 
%the fourth parameter is the current figure axis. The 5th parameter
%is not working yet.
%Example (creates one impulse at x=2, going from y=2 to 5 and
%another at x=6, with y=7 to 8):
%clf;plot(1:10)
%ak_impulseplotOnCurve([2 6],[2 7],[5 8],axis)
%See also ak_impulseplot

%remember whether hold is on or off
holdison = 0;
if ishold
    holdison = 1;
end

%% First task is just to adjust the axis (the impulses may resize
%it). So, generate a temporary figure just to obtain the axis.
warning off %the code below can generate several warnings. turn off
figure(50) %create a figure with an arbitrary number
plot(abscissa,starts), hold on
for i=1:length(starts)
    arrow([abscissa(i) starts(i)], ...
        [abscissa(i) stops(i)]); %,varargin);
        %'EdgeColor','b','FaceColor','b')
end
myaxis = axis;
close(50)
warning on %already have axis defined

%% Define a axis that is large enough to accomodate the previous and
%the new ones
myaxis = [min(previousAxis(1),myaxis(1)), ...
    max(previousAxis(2),myaxis(2)), ...
    min(previousAxis(3),myaxis(3)), ...
    max(previousAxis(4),myaxis(4))];

%% Now, effectively plot the impulses
hold on
axis(myaxis);
for i=1:length(starts)
    arrow([abscissa(i) starts(i)], ...
        [abscissa(i) stops(i)],...
        'EdgeColor','b','FaceColor','b') 
        %this should come from 5th input parameter varargin, but
        %is not working
end
%restore previous hold situation
hold off
if holdison==1
    hold on
end