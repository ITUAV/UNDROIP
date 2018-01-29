function [out_img] = slant_2_ground(in_img, first_return )
% Converts slant range side scan sonar data to ground range based on sonar
% altitude.
%
% Size of out_img is same as in_img. Ground range ping tails are
% padded with 0.
%
% Input-
%
% in_img : Sonar data( ping ix, sample ix) where sample ix = 1 is closest
% to sonar
%
% first_return : a vectro containing the index of first seafloor return. 
% Size must be the same as number of ping in in_img
%
%
% Author: Fredrik Elmgren DeepVision [fredrik@deepvision.se]
% Project: SWARMs
% Date: Oct 22, 2016
%
% Optimized for speed by MS Al-Rawi (al-rawi@ua.pt)
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


%size
sl = size(in_img);
np = sl(1); %Number of pings
ns = sl(2); %Number of samples per ping
extra_pts = 100; % This should be large enough to prohibit overflow that might occur, 
                   % if you have an overflow issue you may increase this value, 
                   % 100, however, is more than enough
in_img = [in_img zeros(np, ns + extra_pts )]; % Embedding zeros to prohibit array overflow
out_img = zeros( np, ns );
s_sq = [1:ns].^2 ; % precalculation to speedup the calculations 

for p = 1:np
    fr2 = first_return(p)^2; 
    for s = 1:ns        
        out_img(p,s) = in_img(p, round( sqrt( s_sq(s) + fr2 ) ) ); % if fr2 is out of range in in_img, it will be assigned to zero value
    end
end


