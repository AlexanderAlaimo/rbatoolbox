function D = rbaDefinition(h,fs,time)
%
%   Description:    Calculate definition parameter (D50 by default) 
%	in accordance with ISO-3382
%
%   Usage: D = rbaDefiniton(h,fs,time)
%
%   Input parameters:
%       - h: Impulse response
%       - fs: Sampling frequency
%       - time: The time parameter in ms, until which the integration runs,
%               e.g. 50 for D50
%   Output parameters:
%       - D: Calculated definition (D50, by default)
%
%   Author: Oliver Lylloff, Mathias Immanuel Nielsen & David Duhalde 
%   Date: 05-11-2012, Last update: 17-12-2012
%   Acoustic Technology, DTU 2012

if nargin < 2
    error('Too few input arguments')
elseif nargin == 2
    time = 50;  % calculate D%= by default
end

% Check size of h
[m,n] = size(h);
% ensure that octave bands are in the columns
if m<n
    h = h';
    [m,n] = size(h);
end

% initialize output column vector
D = zeros(1,n);
idxstart = zeros(1,n);
for i = 1:n
% Determine proper onset of impulse response
[~,idxstart(i)] = max(h(:,i));
if idxstart(i) > floor(5e-3*fs)
idxstart(i) = idxstart(i)-floor(5e-3*fs);
else
    idxstart(i) = 1;
end
h2 = h(idxstart(i):end,i).^2;

% find index of integration time in ir
int_idx = ceil(time*1e-3*fs);
% error handling
if int_idx > length(h2)
    error('Impulse response must be longer than wanted time integration!')
end

% calculate Clarity parameter, see ISO-3382-1 (A.11)
D(:,i) = sum(h2(1:int_idx))/sum(h2);

end
end