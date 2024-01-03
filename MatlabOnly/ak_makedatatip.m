function ak_makedatatip(hTarget,position,whereToPlace)
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
    end
    datatip(hTarget,x,y,'FontSize',font_size,'Location',location);
end
