function nadir_center = find_nadir_center_using_spline_fit(accross_track_signal, varargin)
% A simple function to find the first returns using spline fitting
%
%
% Inputs-
% accross_track_signal: one ping (across-track)
% spline_tol: The spline tune parameter
%
%
%
% Author: Mohammed Al-Rawi, al-rawi@ua.pt
%
% Date: Oct 22, 2016
%
% Project SWARMs http://www.swarms.eu/
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



defaults.spline_tol = 1e-8;
args = propval(varargin, defaults);

f_size = length(accross_track_signal);
wL = csaps(1:f_size, log(accross_track_signal), args.spline_tol ,  1:f_size); % plot(ys); hold on; plot(fmat)
%[~, nadir_center]= min(wL);

i=1;
while(1)
    if wL(i+1)<wL(i)
        i=i+1;
        continue;
    else break;
    end    
end
nadir_center= i;




end