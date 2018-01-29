function plot_side_scan_sonar_data_dvs( side_scan_data )
% Plots Side Scan Sonar Data in a waterfall view
%
% Input- 
% side_scan_data structure, with the following contents:
% side_scan_data.res: Ping resolution [m] across track
% side_scan_data.nSamples: The number of samples per ping per channel(side)
% side_scan_data.left: Left side sonar data (ping ix, sample ix)
% side_scan_data.right: Right side sonar data (ping ix, sample ix)
% side_scan_data.lat: Latitude in [rad]
% side_scan_data.lon: Longitude in [rad]
% 
% The structure could be obtained using [side_scan_data] =
% read_side_scan_sonar_dvs(file_name), where file_name is the input file
% 'XXX.dvs', for example, to read a file named WE1.dvs we can use the following script: 
%  x =  read_side_scan_sonar_dvs('WE1.dvs'); 
% 
% then, to plot the image, one can use the following:
% plot_side_scan_sonar_data(x)
% 
% Author: Fredrik Elmgren DeepVision [fredrik@deepvision.se]
% Date: May 11, 2016
%
% 
% This plot function assuems that the left and the right image are of the
% same size
%
%  Project SWARMs http://www.swarms.eu/
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



sl = size(side_scan_data.left);
%sr = size(side_scan_data.right);

np = sl(1);
ns = sl(2);
pd = zeros( np,2*ns);

for p=1:np
    pd(p,1:ns) = fliplr(side_scan_data.left(np-p+1,:));
    pd(p,ns+1:2*ns) = side_scan_data.right(np-p+1,:);
end
x = [-ns*side_scan_data.res ns*side_scan_data.res];
y = [0 np];

colormap('copper');
image(x, y, pd/3);
% axis image; %set aspect ratio to image

