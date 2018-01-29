function [img, spikes]= isolate_spikes(img, varargin)
% Based on a threshold value, this function decomposes the image into two parts,
% one with the very high values, and the other with the values where the rest. 
% Very high values have low occurence. So, based on the histogram, if the
% number of occurence is less than or equal than the threshold_val, the image
% be decomposed into two.
%
% Input-
% img: side scan sonar image, one part, either the left or the right
% threshold_val: the higher the value, the less bright points are detected
%
%
% Example
% [x.left_cor, x.left_spikes] = isolate_spikes(x.left_norm);
% [x.right_cor, x.right_spikes]= isolate_spikes(x.right_norm);
%
%
%
% Author: Mohammed Al-Rawi, al-rawi@ua.pt
% Project: SWARMs
% Date: Oct 22, 2016
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




defaults.threshold_val = 3000; % the higher the value, the less bright points are detected, hence, you may try out several values until deciding which one fits your application
defaults.median_filter_size= 11;
args = propval(varargin, defaults);

spikes= img;
h= histogram(img); title('Histogram of image' );
[mm, im] = max(h.Values(7:end)); % im(1)  idx for the first maxima, the first peak appears at the second location value 1, which is the nadir area, thus, we start from 7
z = find(h.Values(im(1):end)<args.threshold_val); % 
z = z + im(1)-1; % correcting the position
loci= logical(img>z(1));
img( loci ) = z(1); % z(1) is the index pixels of the first highr thatn im(1)
spikes(logical(spikes<=z(1) ))= 0; % z(1) is the value of the first signal less than 10, so
spikes  = medfilt2(spikes, [args.median_filter_size args.median_filter_size]); % removing isolaed points
spikes = uint8(spikes); % This will set the high values to 255

end