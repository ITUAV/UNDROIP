function img =  remove_water_column(img, edge, varargin)
% This function sets the water column to  a chosen value, value 0 or 1 are
% best choices
% 
% Input-
%
% img: Side scan sonar image, either left or right
% nadir: A structure that contains the nadir edge, first retunrs
% 
% Output- 
% img: the same image but with the water column set to zero
%
%
%  Example:
%  left_img =  remove_water_column(left_img, nadir, 'value', 1); setting
%  the water column to 1
%
%
% Author: Mohammed Al-Rawi [al-rawi@ut.pt]
% Project: SWARMs
% Date: Jan 12, 2017
%
%
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

defaults.value=0;
args = propval(varargin, defaults);

[n_pings, no_points] = size(img);

for ping_idx = 1:n_pings;       
    img(ping_idx, 1:edge(ping_idx)-1)= args.value;            
end


