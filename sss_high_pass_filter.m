function img = sss_high_pass_filter(img)

% This function applies a high-pass filter to the input image
%
% Input - 
% img: a 2D image
%
% 
% 
%
%
% Author: Mohammed Al-Rawi, al-rawi@ua.pt
% Date: Oct 22, 2016
%
%
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




h = fspecial('unsharp'); % Many other filters are available, please see Matlab's help

img = imfilter(img, h);

