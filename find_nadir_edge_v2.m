function [nadir_edge,  ni] = find_nadir_edge_v2( img, varargin)
%   DETECT_FIRST_ECHO Summary of this function goes here
%   img -- either left scan or right scan
%   thresholds high and low -- threshold for detecting echo
%   filter_size -- determines window size of the filter for computing
%   averages
%   ni - refers to the indices of the first lowest point (wrt to some
%   predefined threshold) before the nadir edge
%   nadir_edge - refers to the indeces of the first returns
%
% To find gap, the moving average the filter function shall be used
% Parameters a and b for the function are defined
%
%
% Author Migrita Frasheri (MDH) and MS Al-Rawi (al-rawi@ua.pt)
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


defaults.filter_size = 50;
defaults.low_ave = 50;
defaults.high_ave = 100;
defaults.low = 100;

args = propval(varargin,defaults);

b = (1/args.filter_size)*ones(1, args.filter_size);
a = 1;
% Use transpose of ping, since the moving average is computed column-wise
moving_average = filter (b, a, img')';

% Find mean values within range
min_ave = args.low_ave < moving_average & moving_average < args.high_ave;

% Find indexes of the first such value, for each row
[~, min_ave_i] = max(min_ave, [], 2);
% Linearize the indexes, and keep the values
row = 1:size(img,1);
lin_min_ave_i = sub2ind(size(moving_average), row', min_ave_i);
ave_i = moving_average(lin_min_ave_i);

% approx gap
ni = min_ave_i;
% Smooth out the signal before ni
% First make the values before the center of the gap zero
img(bsxfun(@le, 1:size(img, 2), ni(:))) = 0;

% Then instead of keeping them zero, substitute that value with the average
% of the gap.
ave_i_rep = repmat(ave_i, 1, size(img,2));
ave_i_rep(bsxfun(@gt, 1:size(ave_i_rep, 2), ni(:))) = 0;
img = img + ave_i_rep;

% Substract each column in the matrix with the previous one
% The resulting matrix will have one column less than the pings matrix
ping_point_diff = img(:,2:end) - img(:,1:end-1);

% Find elements in matrix which are higher or equal to the threshold
idx = ping_point_diff > args.low;
 
% For each row keep the first index of the first non-zero element in matrix
% The indexes in index refer to ping_point_diff
[out, nadir_edge] = max(idx, [], 2);

% Don't keep the indexes in which the values of out are 0 -- in that case
% return 0 -> this will produce error as it shouldn't happen
nadir_edge(out == 0) = 0;

end
