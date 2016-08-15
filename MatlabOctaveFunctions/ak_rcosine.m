function p=ak_rcosine(Fd,Fs,type_flag,r,delay)
% function p=ak_rcosine(Fd,Fs,type_flag,r,delay)
% Design a raised cosine filter for signals at sampling frequency Fs
% assuming the "symbols" embedded in the signals have a baud rate Fd.
%   Fd: Symbol rate (sometimes called bauds)
%   Fs: Sampling frequency, where Fs/Fd is the "oversampling" factor
%   type_flag:  Specific filter design instructions
%   	'fir/normal'    Design regular raised cosine filter (default)
%   	'fir/sqrt'      Design square root raised cosine
%   r:          Roll-off factor, default value is 0.5
%   delay:      Group delay in symbols (not samples), default value
%               is 3. The group delay and the oversampling factor L
%               determines the filter order P, where P=2*delay*L + 1
%
% Further information:
%         http://en.wikipedia.org/wiki/Raised-cosine_filter
%         http://www.michael-joost.de/rrcfilter.pdf
%
% Example of usage:
%    Fd = 8000; % Symbol rate (bauds)
%    Fs = 24000; % Sampling frequency (Hz)
%    r = 0.25; % Roll-off factor
%    P = 31; % Pulse duration in samples, an odd integer
%    L = Fs/Fd; %oversampling factor
%    delay = (P-1)/(2*L); %group delay in symbols for given P and L
%    %obs: delay=5 symbols, which corresponds to L*5=6*5=30 samples.
%    p = ak_rcosine(Fd,Fs,'fir/sqrt',r,delay); %square-root RC
% or use directly in "discrete-time"
%    p = ak_rcosine(1,L,'fir/sqrt',r,delay); %square-root RC

%Establish default values:
if nargin < 5
    delay = 3; %default group delay
end
if nargin < 4
    r = 0.5; %default roll-off factor
end
if nargin < 3 || isempty(type_flag)
    type_flag = 'fir/normal'; %default is a normal (not root) RC
end

%Check input (could include many other tests, such as delay > 0, etc)
if ~isequal(type_flag,'fir/normal') && ~isequal(type_flag,'fir/sqrt')
    error('Supports only type_flag equals fir/normal or fir/sqrt')
end

L = Fs/Fd; %oversampling factor
if (ceil(L)~=L) || (L<=1) || ~isreal(L)
    error('Oversampling Fs/Fd must be an integer greater than 1.')
end
if ceil(delay) ~= delay
    error('Delay (which is in samples) must be an integer number!')
end
n = -delay*L:delay*L; %Sampling instants

if isequal(type_flag,'fir/normal')
    p = (sin(pi*n/L)./(pi*n/L)).*(cos(r*pi*n/L) ./ ...
        (1-(2*r*n/L).^2));
    p(1:L:end)=0; %correct numerical errors: force zeros
    %p has singularity at t=0 and may have at
    %n=L/(2r) and -L/(2r) in case they are integers
    centralSample = delay*L+1; %corresponding to t=0
    p(centralSample)=1; %recover the value due to 0/0
    indexWithValue = find(abs(n - L/(2*r)) < sqrt(eps),1,'last');
    if ~isempty(indexWithValue) %correct singularities
        temp=(sin(pi/(2*r))./(pi/(2*r)))*pi/4; %from L'Hospital rule
        p(indexWithValue) = temp; %sample at singularity n=L/(2r)
        p(centralSample-(indexWithValue-(centralSample))) = temp;
    end
elseif isequal(type_flag,'fir/sqrt')
    %Note Mathwork's firrcos.m uses other equations and strategies
    %to deal with numerical errors.
    p = (sin(pi*n/L*(1-r)) + ...
        4*r*n/L.*cos(pi*n/L*(1+r)))./(pi*n/L.*(1-(4*r*n/L).^2));
    %p has 3 singularities: at t=0, 1/(4r) and -1/(4r)
    centralSample = delay*L+1; %corresponding to t=0
    p(centralSample)= (1-r)+4*r/pi; %recover the value at t=0
    indexWithValue = find(abs(n - L/(4*r)) < sqrt(eps),1,'last');
    if ~isempty(indexWithValue)
        temp = r/sqrt(2)*((1+2/pi)*sin(pi/(4*r))+...
            (1-2/pi)*cos(pi/(4*r))); %correct value at +/- 1/(4r)
        p(indexWithValue) = temp; %sample at 1/(4r), and t=-1/(4r):
        p(centralSample-(indexWithValue-(centralSample))) = temp;
    end
    p=p./sqrt(sum(p.^2)); %Normalization to unit energy
end
