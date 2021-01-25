function varargout = makedatatip(hObj,index)
%Modified by AK in Jan 2021, using comments by Zhengyi, 2 Feb 2018 at:
%https://www.mathworks.com/matlabcentral/fileexchange/19877-makedatatip
%MAKEDATATIP  Adds data tips to specified data points of graphical objects.
%
%  MAKEDATATIP(HOBJ,INDEX) adds a datatip to the graphical object HOBJ at
%  the data point defined by INDEX.
%
%  HOUT = MAKEDATATIP(...) returns handles to the created datatips.
%
%  If HOBJ is 1-dimensional, INDEX can be of any size and is assumed to be
%  a linear index into the data contained by HOBJ.  HOUT will be of the
%  same size as INDEX.
%
%  If HOBJ is 2-dimensional and INDEX is N-by-2, INDEX is assumed to be a
%  set of N subscripts, and HOUT will be N-by-1.  If INDEX is of any other
%  size, it is assumed to a linear index and HOUT will be the same size as
%  INDEX.  Note that if you wish to specify 2 linear indices, ensure INDEX
%  is a column vector, else it will be assumed to be a single set of
%  subscripts.
%
% Example:
%     x = 1:10;
%     y = rand(1,10);
%     hPlot = plot(x,y);
%     makedatatip(hPlot,[3 8])
%
% Example:
%     [X,Y,Z] = peaks(30);
%     hObj = surf(X,Y,Z);
%     makedatatip(hObj,[5 8; 20 12; 22 28])
%
% Example: Add a single data tip to data point (5,25)
%     [X,Y,Z] = peaks(30);
%     hObj = surf(X,Y,Z);
%     makedatatip(hObj,[5 25])
%
% Example: Add two data tips to data points (5) and (25)
%     [X,Y,Z] = peaks(30);
%     hObj = surf(X,Y,Z);
%     makedatatip(hObj,[5; 25])
%
% Example: Add two data tips to an image
%     load mandrill
%     figure
%     hObj = image(X);
%     colormap(map) 
%     makedatatip(hObj, [103 348; 270 348])

% Author: Tim Farajian
% Release: 2.0
% Release date: 6/27/2012

% Check # of inputs
narginchk(2, 2)
nargoutchk(0, 1)

if length(hObj)~=1
  error('MAKEDATATIP:InvalidSize',...
    'HOBJ must be scalar.');
end

% Ensure hObj is valid target
if ~ishandle(hObj)
  error('MAKEDATATIP:InvalidHandle',...
    'HOBJ is an invalid handle object.');
end

isImage = strcmp(get(hObj, 'Type'), 'image'); %Determine if target is image

% Read data from hObj
try
  X = get(hObj,'XData');
  Y = get(hObj,'YData');
catch ME
  % Object must have an XData and YData property to be valid
  error('MAKEDATATIP:InvalidObjectType',...
    'Objects of class ''%s'' are not a valid targets for datatips.',...
    class(handle(hObj)))
end
try
  Z = get(hObj,'ZData');
catch ME
  % Many objects do not have a ZData property.  Some will work, some will
  % not.
  isImage = true;
end
% Ensure subscripts or indices are valid values and sizes
if isempty(index)
  return
elseif ~isnumeric(index)
  error('MAKEDATATIP:InvalidDataType',...
    'Subscript indices must be of numeric data type.')
elseif any(index(:)<1) ||...
    any(fix(index(:))~=index(:)) ||...
    any(isinf(index(:)))
  error('MAKEDATATIP:InvalidIndex',...
    'Subscript indices must be positive integers.')
elseif ~isvector(index) && ~any(size(index)==2)
  error('MAKEDATATIP:InvalidIndexMatrixSize',...
    'Subscript indices must be a vector or N-by-2 matrix.')
elseif (~isImage && isvector(X)) || size(index,2)~=2
  %hDatatip = zeros(size(index));
  hDatatip = cell(size(index));
  index = index(:);
  isLinear = true;
else
  %hDatatip = zeros(size(index,1),1);
  hDatatip = cell(size(index,1),1);
  isLinear = false;
end

% Get handle to datacursor mode object
hDataCursorMgr = datacursormode(ancestor(hObj,'figure'));

% Loop through each specified data point
for n = 1:size(index,1)
  
  % Create position vector
  if isImage && isLinear
    [i j] = ind2sub([X(2) Y(2)], index(n));
    pos = [i j 1];
  elseif isImage
    pos = [index(n, 1) index(n, 2) 1];
  elseif isempty(Z)
    pos = [X(index(n)) Y(index(n))];
  elseif isLinear
    pos = [X(index(n)) Y(index(n)) Z(index(n))];
  else
    pos = [...
      X(index(n,1),index(n,2))...
      Y(index(n,1),index(n,2))...
      Z(index(n,1),index(n,2))];
  end
  
  % Create datatip
  %hDatatip(n) = createDatatip(hDataCursorMgr, hObj);
  hDatatip{n} = createDatatip(hDataCursorMgr, hObj);
  % Specify data cursor properties
  if isImage
    %set(get(hDatatip(n),'DataCursor'),'DataIndex',pos,...
    %  'TargetPoint',pos(1:2))
    hDatatip{n}.Cursor.DataIndex = pos; hDatatip{n}.Cursor.Position = pos(1:2);
  else
    %set(get(hDatatip(n),'DataCursor'),'DataIndex',index(n, :),...
    %  'TargetPoint',pos)
    hDatatip{n}.Cursor.DataIndex = index(n,:); hDatatip{n}.Cursor.Position = pos;
  end
  
  % Specify datatip properties
  %set(hDatatip(n),'Position',pos)
  set(hDatatip{n},'Position',pos)
  
end

% Update all data cursors
updateDataCursors(hDataCursorMgr)

% Return handles if requested
if nargout==1
  varargout = {hDatatip};
end