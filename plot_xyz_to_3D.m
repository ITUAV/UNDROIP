function plot_xyz_to_3D(inpt, xyz_img1, xyz_img2)

%  plot_xyz_to_3D(result.matches)
%  result.matches are the outputs form the function [result] =
%  rawi_bathy_analysis ((xyz1, xyz2)

% Example:
% [result] = rawi_bathy_analysis (M2L9, M2L10); % doing the matching
% plot_xyz_to_3D(result.matches, M2L9, M2L10);

x1= [inpt.x_img1 inpt.y_img1 inpt.z_img1];
x2= [inpt.x_img2 inpt.y_img2 inpt.z_img2];
    
do_it(xyz_img1, x1);
do_it(xyz_img2, x2);


function do_it(x, x1)
% plot3(x,y,z)  % to plot 3D something with vectors x,y,z
[f, x, x_ref, y_ref] = get_f(x, 0); % the passed 0 indicates finding the reference points
x1(1:end,1) = round(x1(1:end,1)-x_ref+1);
x1(1:end,2) = round(x1(1:end,2)-y_ref+1);

% setting f to 0
id0 = logical(x(:,3)==0);
Lx = length(x);
for idx=1: Lx
        f( x(idx,1), x(idx,2) )= id0(idx)*-3;           
end


% now, putting the matched values in the 0-ed f matrix
for idx=1: length(x1);
     f( x1(idx,1), x1(idx,2) )= -x1(idx,3);       
end

figure; colormap(colorcube); mesh(f); % image(f);

% norm_g = floor( 255*(x(1:end,3)- min_g)/(max_g-min_g));

%  image(x(1:end,1), x(1:end,2), x(1:end,3));
% z = reshape(norm_g, 2*383, 11299);
% to display the vectros as a mesh, we can use https://www.mathworks.com/help/matlab/visualize/representing-a-matrix-as-a-surface.html



function [f, x, x_ref, y_ref] = get_f(x, x_ref, y_ref)

x(:,1)= round(x(:,1));
x(:,2) = round(x(:,2));
if x_ref==0
    x_ref= min(x(:,1)); % min(x(1:end,1)'); %   % x(1,1); % the center of mass is another alternative
    y_ref = min(x(:,2)); % min(x(1:end,2)'); % % x(1,2);
end

x(1:end,1) = x(1:end,1)-x_ref;
x(1:end,2) = x(1:end,2)-y_ref;

[min_x ] = min(x(1:end,1)');
[min_y ] = min(x(1:end,2)');

[max_x ] = max(x(1:end,1)');
[max_y ] = max(x(1:end,2)');

% Transform to positive xy-plane

x(1:end,1) = x(1:end,1)- min_x+1;
x(1:end,2) = x(1:end,2) - min_y+1;
x(:,3)=abs(x(:,3));

[max_x ] = round( max(x(1:end,1)'));
[max_y ] = round( max(x(1:end,2)'));

f = zeros(max_x, max_y);

