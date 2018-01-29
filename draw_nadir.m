function draw_nadir(left_image, right_image, nadir, varargin)
%
% Draws the first returns on top of the SSS image (both left and right)
% The purpose is just to illustrate the first returns
%
%
% Input-
% -left and the right scans
% nadir: a structure containing the left first returns and the right first returns, i.e. nadir edges
%
%
% Author: Mohammed Al-Rawi [al-rawi@ut.pt]
% Project: SWARMs
% Date: Jan 18, 2017
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

defaults.res=0.05;
defaults.line_width = 5; % 1 point width is best, but it might not be visible in large images
args = propval(varargin, defaults);

L_img = deal_with_it(left_image, nadir.left.edge, args.line_width);
R_img = deal_with_it(right_image, nadir.right.edge, args.line_width);

plot_side_scan_sonar_data( log(L_img), log( R_img), 'res', args.res );

end


function img = deal_with_it(img, edge, line_width)
[n_pings, n_points]= size(img);
mx = max(max(img));
for i=1:n_pings
    img(i,edge(i):edge(i)+ line_width)= mx; % giving the line a width of 5 points
end

end
