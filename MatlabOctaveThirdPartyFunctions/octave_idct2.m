% Copyright (C) 2001 Paul Kienzle
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; If not, see <http://www.gnu.org/licenses/>.

% y = idct2 (x)
%   Computes the inverse 2-D discrete cosine transform of matrix x
%
% y = idct2 (x, m, n) or y = idct2 (x, [m n])
%   Computes the 2-D inverse DCT of x after padding or trimming rows to m and
%   columns to n.

% Author: Paul Kienzle
% 2001-02-08
%   * initial revision

function y = octave_idct2(x, m, n)

if (nargin < 1 || nargin > 3)
    usage('idct (x) or idct (x, m, n) or idct (x, [m n])');
end

if nargin == 1
    [m, n] = size (x);
elseif (nargin == 2)
    n = m (2);
    m = m (1);
end

if m == 1
    y = idct (x.', n).';
elseif n == 1
    y = idct (x, m);
else
    y = idct (idct (x, m).', n).';
end
