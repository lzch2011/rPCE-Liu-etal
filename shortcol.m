function [yy] = shortcol(X, b, h)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% SHORT COLUMN FUNCTION
%
% Authors: Sonja Surjanovic, Simon Fraser University
%          Derek Bingham, Simon Fraser University
% Questions/Comments: Please email Derek Bingham at dbingham@stat.sfu.ca.
%
% Copyright 2013. Derek Bingham, Simon Fraser University.
%
% THERE IS NO WARRANTY, EXPRESS OR IMPLIED. WE DO NOT ASSUME ANY LIABILITY
% FOR THE USE OF THIS SOFTWARE.  If software is modified to produce
% derivative works, such modified software should be clearly marked.
% Additionally, this program is free software; you can redistribute it 
% and/or modify it under the terms of the GNU General Public License as 
% published by the Free Software Foundation; version 2.0 of the License. 
% Accordingly, this program is distributed in the hope that it will be 
% useful, but WITHOUT ANY WARRANTY; without even the implied warranty 
% of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU 
% General Public License for more details.
%
% For function details and reference information, see:
% http://www.sfu.ca/~ssurjano/
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INPUTS:
%
% xx = [Y, M, P]
% b  = width of cross-section (optional), with nominal value 5
% h  = depth of cross-section (optional), with nominal value 15
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Y = X(:,1);
M = X(:,2);
P = X(:,3);

if (nargin == 1)
    b = 5;
    h = 15;
elseif (nargin == 2)
    h = 15;
end

term1 = -4*M ./ (b*(h^2)*Y);
term2 = -(P.^2) ./ ((b^2)*(h^2)*(Y.^2));

yy = 1 + term1 + term2;

end
