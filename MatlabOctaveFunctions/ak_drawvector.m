function [ann_handle,figx,figy,orix,oriy]=ak_drawvector(x1,y1,xo,yo)
%function [ann_handle,figx,figy,orix,oriy]=ak_drawvector(x1,y1,xo,yo)
%Draws an arrow. Examples (all are equivalent for drawing a vector
%from point (0,0) to (2,1):
%ak_drawvector(2+j)
%ak_drawvector(2,1)
%ak_drawvector([2,1])
%ak_drawvector([2,1]')
%Example of vector from point (1,2) to (3,4):
%ak_drawvector(3,4,1,2) or ak_drawvector([3,4,1,2])
%
%Note: First create the axis.
%And make sure the axis of the figure is large enough to hold all
%vectors that will be draw. This will avoid the error message below,
%which occurs when the specified vector coordinates fall outside
%the current plot axis. To go around it, just expand the axis before
%the first vector and do not rescale it.
%??? Error using ==> annotation (line 111)
%X and Y values must be between 0 and 1
%Error in ==> ak_drawvector (line 58)
%ann_handle=annotation('arrow',[orix figx],[oriy figy]);
if nargin == 1 %a complex number or a vector
    if ~isvector(x1)
        error(['If only one input parameter is used, it must be ' ...
            'a vector or scalar']);
    end
    switch length(x1)
        case 1
            xo=0; yo=0; % assume origin is (0,0) if not specified
            x=real(x1); %assume it is a complex number
            y=imag(x1);
        case 2
            xo=0; yo=0; % assume origin is (0,0) if not specified
            x=x1(1); %assume it is a vector with 2 elements
            y=x1(2);
        case 4
            x=x1(1); %assume it is a vector with 4 elements
            y=x1(2);
            xo=x1(3);
            yo=x1(4);
        otherwise
            error('Vector length must be 1, 2 or 4')
    end
elseif nargin == 4
    %the origin is specified
    x=x1;
    y=y1;
elseif nargin == 2
    % assume origin is (0,0) if not specified
    xo=0;
    yo=0;
    x=x1;
    y=y1;
end
[figx figy] = dsxy2figxy(gca, x, y);
[orix oriy] = dsxy2figxy(gca, xo, yo);
if nargout == 0 %avoid echoing the annotation handle
    annotation('arrow',[orix figx],[oriy figy]);
    return
else
    ann_handle=annotation('arrow',[orix figx],[oriy figy]);
end
end
%From Mathwork's documentation:
function varargout = dsxy2figxy(varargin)
% dsxy2figxy -- Transform point or position from axis to figure coords
% Transforms [axx axy] or [xypos] from axes hAx (data) coords into coords
% wrt GCF for placing annotation objects that use figure coords into data
% space. The annotation objects this can be used for are
%    arrow, doublearrow, textarrow
%    ellipses (coordinates must be transformed to [x, y, width, height])
% Note that line, text, and rectangle anno objects already are placed
% on a plot using axes coordinates and must be located within an axes.
% Usage: Compute a position and apply to an annotation, e.g.,
%   [axx axy] = ginput(2);
%   [figx figy] = getaxannopos(gca, axx, axy);
%   har = annotation('textarrow',figx,figy);
%   set(har,'String',['(' num2str(axx(2)) ',' num2str(axy(2)) ')'])

%% Obtain arguments (only limited argument checking is performed).
% Determine if axes handle is specified
if length(varargin{1})== 1 && ishandle(varargin{1}) && ...
        strcmp(get(varargin{1},'type'),'axes')
    hAx = varargin{1};
    varargin = varargin(2:end);
else
    hAx = gca;
end;
% Parse either a position vector or two 2-D point tuples
if length(varargin)==1	% Must be a 4-element POS vector
    pos = varargin{1};
else
    [x,y] = deal(varargin{:});  % Two tuples (start & end points)
end
%% Get limits
axun = get(hAx,'Units');
set(hAx,'Units','normalized');  % Need normaized units to do the xform
axpos = get(hAx,'Position');
axlim = axis(hAx);              % Get the axis limits [xlim ylim (zlim)]
axwidth = diff(axlim(1:2));
axheight = diff(axlim(3:4));
%% Transform data from figure space to data space
if exist('x','var')     % Transform a and return pair of points
    varargout{1} = (x-axlim(1))*axpos(3)/axwidth + axpos(1);
    varargout{2} = (y-axlim(3))*axpos(4)/axheight + axpos(2);
else                    % Transform and return a position rectangle
    pos(1) = (pos(1)-axlim(1))/axwidth*axpos(3) + axpos(1);
    pos(2) = (pos(2)-axlim(3))/axheight*axpos(4) + axpos(2);
    pos(3) = pos(3)*axpos(3)/axwidth;
    pos(4) = pos(4)*axpos(4)/axheight;
    varargout{1} = pos;
end
%% Restore axes units
set(hAx,'Units',axun)
end