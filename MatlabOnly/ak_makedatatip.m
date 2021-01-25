function ak_makedatatip(hTarget,position,whereToPlace)
if length(position)~=2
    error('Error in logic: was expecting only 2 positions')
end
x=position(1);
y=position(2);
font_size = 8; %default is 10
if nargin < 3
    datatip(hTarget,x,y,'FontSize',font_size);    
else %use whereToPlace
    switch whereToPlace
        case 'left'
            location = 'northwest';
        case 'right'
            location = 'northeast';
        case 'southeast'
            location = 'southeast';
        otherwise
            location = 'northwest'; %default
            warning(location)
    end
    datatip(hTarget,x,y,'FontSize',font_size,'Location',location);
end
return

%AK, Jan 2021 - The function below is not working with Matlab R2020a

% function ak_makedatatip(hTarget,position,whereToPlace)
%'whereToPlace' can be 'right' (default),'left','auto', and indicates
% where the the datatip is positioned.
%Example 1 (note that position refers to actual values, not indices):
%   xdata=-10:-0.5:-20;
%   ydata=-2*xdata;
%   h = plot(xdata,ydata);
%   position=[-15 30];
%   ak_makedatatip(h,position,'left')
%Example 2:
%   h=imagesc(magic(6));
%   position=[3 4];
%   ak_makedatatip(h,position)

if nargin < 3
    whereToPlace = 'right';
end
%First get the figure's data-cursor mode, activate it, and set
%some of its properties
cursorMode = datacursormode(gcf);
%'UpdateFcn',@setDataTipTxt,
set(cursorMode, 'enable','on',...
    'NewDataCursorOnClick',false);
%Note: the optional @setDataTipTxt is used to customize the
%data-tip's appearance

% Note: the following code was adapted from
%%matlabroot%\toolbox\matlab\graphics\datacursormode.m
% Create a new data tip
%hTarget = handle(hLine);
hDatatip = cursorMode.createDatatip(hTarget);

% Create a copy of the context menu for the datatip:
set(hDatatip,'UIContextMenu',get(cursorMode,'UIContextMenu'));
set(hDatatip,'HandleVisibility','off');
set(hDatatip,'Host',hTarget);
set(hDatatip,'ViewStyle','datatip');

% Set the data-tip orientation to top-right rather than auto
switch whereToPlace
    case 'right'
        set(hDatatip,'OrientationMode','manual');
        set(hDatatip,'Orientation','top-right');
    case 'left'
        set(hDatatip,'OrientationMode','manual');
        set(hDatatip,'Orientation','top-left');
    case 'auto'
        set(hDatatip,'OrientationMode','auto');
    otherwise
        error('Unexpected whereToPlace! Options: right, left, auto');
end
% Update the datatip marker appearance
set(hDatatip, 'MarkerSize',5, 'MarkerFaceColor','none', ...
    'MarkerEdgeColor','k', 'Marker','o', 'HitTest','off');

% Move the datatip to the right-most data vertex point
%position = [xdata(end),ydata(end),1; xdata(end),ydata(end),-1];
update(hDatatip, position);