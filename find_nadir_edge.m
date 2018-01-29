function nadir = find_nadir_edge(img, varargin)
% Finds nadir center, and nadir edge
%
% Input-
% img: either left scan image, or right scan image
% nadir: a structure with threhold values, see below 
%
% Output-
% % nadir: a structure with threhold values and the detected first retunrs 
%
%
% Author: Mohammed Al-Rawi [al-rawi@ut.pt]
% Project: SWARMs
% Date: Sept 12, 2016
%
%
%
% Project SWARMs http://www.swarms.eu/
%
% License:
%=====================================================================
% This is part of the UNDROIP toolbox, released under
% the GPL. https://github.com/rawi707/UNDROIP/blob/master/LICENSE
% 
% The UNDROIP toolbox is available free and
% unsupported to those who might find it useful. We do not
% take any responsibility whatsoever for any problems that
% you have related to the use of the UNDROIP toolbox.
%
% ======================================================================
%%

defaults.threshold = 150; % the first strong echo after nadir area, values lower than this will be neglected and not will be used in polynomial fitting
defaults.last_search = 700; % the end value to look for the location where the real echo starts
args = propval(varargin,defaults);

[n_pings, no_points] = size(img);
args.edge = zeros(n_pings, 1, 'double');
args.center = zeros(n_pings, 1, 'double');

for ping_idx = 1:n_pings;  
    fmat = double( img(ping_idx, :) );
    fmat(logical(fmat==0)) = 1; % replacing 0s values with 1s, since they will cause a problem with the log function
    args.center(ping_idx) = find_nadir_center_using_spline_fit(fmat);
    xx = find( img(ping_idx, args.center(ping_idx): args.last_search)  > args.threshold); % possible locations of the edge, xx(1) is the edge
    args.edge(ping_idx) = xx(1)+ args.center(ping_idx)-1; % the first strong echo after nadir area     
    progress(ping_idx, n_pings);   
end

nadir = args;

