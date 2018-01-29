function img_out = denoise_sss_image(img, nadir, varargin)
%  Performs image denoising to a side scan sonar (SSS) image
% The function uses Savitzky–Golay filter is a digital filter that can be 
% applied to a set of digital data points for the purpose of smoothing the 
% data, that is, to increase the signal-to-noise ratio without greatly 
% distorting the signal. This is achieved, in a process known as convolution, 
% by fitting successive sub-sets of adjacent data points with a low-degree 
% polynomial by the method of linear least squares.
%
%
% Input:
%  img: either the left or the right SSS image
%  nadir: a structure containing the nadir edge, i.e., first echo returns
%  nadir edge can be found using detect_first_echo_v2(), or the slower function
%  find_nadir_edge()
%

% Example: Run and display the image:
%  plot_side_scan_sonar_data( filter_SSS_image(ec_norm.left_norm, ec_norm.parameters.nadir.left),filter_SSS_image(ec_norm.right_norm, ec_norm.parameters.nadir.right), 0.012 )
% 
% Author: Mohammed Al-Rawi [al-rawi@ut.pt]
% Project: SWARMs
% Date: Jan 18, 2017
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



defaults.order = 9; % For info on these filter parameters, please see https://www.mathworks.com/help/signal/ref/sgolayfilt.html
defaults.framelen = 17;  %   ( another good filter is order 7 and framelen = 121); 9 & 13 is good too, you must tune these values according to your need

args = propval(varargin,defaults);

[n_pings, no_points] = size(img);
img_out=img;
for ping_idx = 1:n_pings
    x= img(ping_idx, nadir.edge(ping_idx):end); % picking one across-track sample
    y = sgolayfilt(x, args.order, args.framelen);         
    y= smooth(y);       
    img_out(ping_idx, nadir.edge(ping_idx):end) = y;
end

img_out = sanity_check(img, img_out);


function img_out = sanity_check(img, img_out)
loci = find(img_out<0);
if any(loci)<0
    warning('negative values occured during filtering, please change framelen');   
    img_out(loci) = img(loci); % replacing the -ve values with the original values
end

