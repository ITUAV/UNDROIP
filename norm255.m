function img = norm255(img)
% This function normalizes the image into between 0 and 255, and the output
% is stored in uint8
%
%
%
% Author: Mohammed Al-Rawi, al-rawi@ua.pt
%
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




mn = min(min(img));
mx = max(max((img)));
img = ceil(255*(img-mn)/(mx-mn));
img = uint8(img);

end
