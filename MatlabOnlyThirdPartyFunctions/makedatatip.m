function varargout = makedatatip(hObj,index)
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

% Author: Tim Farajian
% Release: 1.0
% Release date: 5/10/2008

error(nargchk(2,2,nargin))
error(nargoutchk(0, 1, nargout))

% Ensure hObj is valid target
handleObj = handle(hObj);
if ~ishandle(hObj)
  error('MAKEDATATIP:InvalidHandle',...
    'HOBJ is an invalid handle object.');
elseif ~isa(handleObj,'hg.surface') &&...
    ~isa(handleObj,'hg.patch') &&...
    ~isa(handleObj,'hg.line') &&...
    ~isa(handleObj,'hg.image')
  error('MAKEDATATIP:InvalidObjectType',...
    'Objects of class ''%s'' are not a valid targets for datatips.',...
    class(handleObj));
end

% Read data from hObj
X = get(hObj,'XData');
Y = get(hObj,'YData');
Z = get(hObj,'ZData');

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
elseif isvector(X) || size(index,2)~=2
  hDatatip = zeros(size(index));
  index = index(:);
  isLinear = true;
else
  hDatatip = zeros(size(index,1),1);
  isLinear = false;
end

% Get handle to datacursor mode object
hDataCursorMgr = datacursormode(ancestor(hObj,'figure'));

% Loop through each specified data point
for n = 1:size(index,1)
  
  % Create position vector
  if isempty(Z)
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
  hDatatip(n) = createDatatip(hDataCursorMgr, hObj);
  % Specify data cursor properties
  set(get(hDatatip(n),'DataCursor'),'DataIndex',index(n),...
    'TargetPoint',pos)
  % Specify datatip properties
  set(hDatatip(n),'Position',pos)
  
end

% Update all data cursors
updateDataCursors(hDataCursorMgr)

% Return handles if requested
if nargout==1
  varargout = {hDatatip};
end