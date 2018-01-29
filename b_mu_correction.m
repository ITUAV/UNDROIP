function img = b_mu_correction(img, varargin)
% Dynamic range reduction using Bell Mu Law.
%
% parameters/inputs:
% - m: the bit length of the acquired image
% - n: the bit length of the output/desired image
% Ref: The handbook of sidescan sonars
%
% Author: Mohammed Al-Rawi (University of Aveiro)
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



defaults.m = 16;
defaults.n = 8;
defaults.c = 1500;
args = propval(varargin, defaults);

img = args.c*log(1+ 2^(args.n-args.m)*img);
