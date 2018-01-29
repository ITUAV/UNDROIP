function y = test_equalize(x)
%  Performs image enhancement to side scan sonar provided by DeepVision
%  General model Exp2:
%  f2(x) = a*exp(b*x) + c*exp(d*x)
% 
%
% Author: Mohammed Al-Rawi, al-rawi@ua.pt
% Project: SWARMs
% Date: Oct 22, 2016
%
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


magic_number= 1; % use this to control the contrast .5<= magic_number<1.5
idx = 500;  % the position to select one sample to perform exponential fitting, this idx was roughly chosen, not sure if there is a better alternative to chose among the indices!
water_column_edge= 50;

dim_val = size(x.left);
if dim_val(1)<idx 
    disp('please reduce the idx value to less than the number of pings');
    return;
end

in_axis = water_column_edge:dim_val(2);  % neglecting the first 100 dark positions, nadir area

imgL = zeros(size(x.left));
imgR = zeros(size(x.right));

inmat = (in_axis)';

% left weights
fmatL = double( x.left(idx, in_axis) )';
f = fit(inmat,fmatL ,'exp2');
wL = (f(in_axis/magic_number)'); %  these are the weights that we shall use to normalize the left image

% right weights
fmatR = double( x.right(idx, in_axis) )';
f = fit(inmat,fmatR ,'exp2');
wR = (f(in_axis/magic_number)'); %  these are the weights that we shall use to normalize the right image

% now, do the normalization
for i= 1: size(x.left,1)    
    imgL(i,in_axis) =  double(x.left(i,in_axis))./wL;
    imgR(i, in_axis) =  double(x.right(i,in_axis))./wR;
end

% normalizing values to 255
mL = max(max(imgL));
mR = max(max(imgR));
imgL = imgL*255/mL;
imgR = imgR*255/mR;

% storing the output
x.left= imgL;
x.right=imgR;
y =x;
figure; plot_side_scan_sonar_data(x)

