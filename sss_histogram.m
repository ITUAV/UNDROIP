function hist_values = sss_histogram(img, varargin)
% This function draws the histogram of an SSS image
%
% Input- 
% img: a 2D image
% 
% Output-
% hist_values: A vector containing the histogram of the image
% 
% Example: 
% hist_values = sss_histogram(x.left); % x.left is a left SSS image
%
%
% Author: Mohammed Al-Rawi, al-rawi@ua.pt
%
% Project: SWARMs
% Date: Oct 22, 2016
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



defaults.number_of_bins = 1000;
args = propval(varargin, defaults);

h = histogram(img, args.number_of_bins); 
hist_values =  h.Values;