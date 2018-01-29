function plot_side_scan_sonar_data( left_img, right_img, varargin )
%Plots side scan sonar data
% -left_img (the left scan)
% -right_img (the right scan)
% -res resolution
%
% Example 1:
% To draw the slant-range image you can use, supposing the image is stored
% in xsz structure you can use:
% plot_side_scan_sonar_data( xsz.left, xsz.right, xsz.res );
%
% Example 2: 
% To plot the ground-range image you an use:
% plot_side_scan_sonar_data( slant_2_ground(xsz.left_norm, xsz.parameters.left_nadir.edge ), slant_2_ground(xsz.right_norm, xsz.parameters.right_nadir.edge ), xsz.res )
%
%  Example 3: 
% To draw the polynomial/spline values, i.e. the curve fit at each ping
% plot_side_scan_sonar_data( xsz.left_poly_values, xsz.right_poly_values, xsz.res )
%
%
%
% Authors: Originally written by Fredrik Elmgren DeepVision [fredrik@deepvision.se]
% Date: May 11, 2016. 
% Modified then by: Mohammed Al-Rawi (al-rawi@ua.pt)
% Date: June 30, 2016.
% 
% Project SWARMs http://www.swarms.eu/
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

defaults.res = 0.012;
defaults.do_flip = true;
defaults.use_log =  false;
defaults.store_as_png = false; 

args = propval(varargin,defaults);

[np, ns] = size(left_img); % assuming left and right are equal

pd = zeros(np, 2*ns);

for p=1:np
    if args.do_flip
        pd(p,1:ns) = fliplr(left_img(np-p+1,:));
    else
        pd(p,1:ns) = left_img(np-p+1,:);
    end    
    pd(p,ns+1:2*ns) = right_img(np-p+1,:);
end

x = [-ns.*args.res ns.*args.res];  % if each ping has a differenet resolution, side_scan_data.res(1) should be changed to side_scan_data.res(i): i=1:np
y = [0 np];

colormap('copper');

if args.use_log
    % will not work if pd has <=0 values since the log will be
    % -ve/complex/ or infinite (for 0 vals)
    pd = 1 + pd - min(min(pd)); % slightly shfiting the values in case they are -ve
    imagesc(x, y, log( pd));
   
else
    imagesc(x, y, uint8( pd));
end
    
% if one wants to store the image:
if args.store_as_png
     str = input('enter output image name','s');
     imwrite( uint8(pd), colormap(copper), str );
end

end



