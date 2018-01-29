function [no_of_matches, result] = bathy_analysis (img1, img2, varargin )
% Input-
% img1 or img2: contains 1) x location, 2) y location, and 3) bath or intensity
% value
% so, img1 is xyz1
% img2 is xyz2
% Bathymetric data stored in XYZ fomat
% 
% Output-
% no_of_matches : Number of matched pairs
% result: a structure that stores all matched pairs


% Example:
% M2L10 = dlmread('M2_L010_5cm_utm28.xyz');
% M2L9 = dlmread('M2_L009_5cm_utm28.xyz');

% [no_matches, result] = rawi_bathy_analysis (M2L9, M2L10);
%  [no_matches, result] =  rawi_bathy_analysis (M2L9, M2L10, 'm1', 0.5505, 'm2', 0.5505);
% xx=0:0.5:10; for i=xx; [no_matches(2*i+1), result] =  rawi_bathy_analysis (M2L9, M2L10, 'm1', 0.5505, 'm2', 0.5505, 'x_min', i, 'y_min', i, 'z_min', 1.5); end
% format long g; to show only numbers in long


%%
% Default parameters
defaults.m1 = 0.5505; % 
defaults.m2 = 0.5505; % 
defaults.z_min = 1.5;
defaults.x_min = 2;
defaults.y_min = 2;
defaults.show_plots = true;
defaults.experiment_name=['test-' date];
args = propval(varargin,defaults);
tic;

% Getting rid of a all the missing data; these are marked with z=0
img1= clean_xyz(img1);
img2= clean_xyz(img2);

% Applying the spatial depth functions on the bathy data (bathy data are
% called img1 and img2 in this function)
result1 = process_data(img1,  args);
result2 = process_data(img2, args);

% Intersecting the values; they have been sorted in the function
% process_data()
[~, idx_img1_sortedf1, idx_img2_sortedf1] = intersect(result1.f1.values(1:end), result2.f1.values(1:end)); % Intersecting f1(img1) and f1(img2)
[~, idx_img1_sortedf2, idx_img2_sortedf2] = intersect(result1.f2.values(1:end), result2.f2.values(1:end)); % Intersecting f2(img1) and f2(img2)

% Find the location in the original data, then, intersecting f1(img1) and
% f2(img1)
idx_img1_realf1 = result1.f1.idx(idx_img1_sortedf1);
idx_img1_realf2 = result1.f2.idx(idx_img1_sortedf2);
idx_img1_real = intersect(idx_img1_realf1, idx_img1_realf2);

idx_img2_realf1 = result2.f1.idx(idx_img2_sortedf1);
idx_img2_realf2 = result2.f2.idx(idx_img2_sortedf2);
idx_img2_real = intersect(idx_img2_realf1, idx_img2_realf2);

mm = min( length(idx_img1_real), length( idx_img2_real));
id_all = find_min_diffs(img1, img2, idx_img1_real,idx_img2_real, mm,  args);

[matches.x_img1, matches.x_img2] = get_values(img1(idx_img1_real(1:mm), 1), img2(idx_img2_real(1:mm),1), id_all) ;
[matches.y_img1, matches.y_img2] = get_values(img1(idx_img1_real(1:mm), 2), img2(idx_img2_real(1:mm),2), id_all) ;
[matches.z_img1, matches.z_img2] = get_values(img1(idx_img1_real(1:mm), 3), img2(idx_img2_real(1:mm),3), id_all) ;

no_of_matches = verification(matches, img1, img2); % Number of matched pairs
result.matches = matches;
result.args = args;
result.no_data_img1 = size(img1,1);
result.no_data_img2 = size(img2,1);
result.percent_matching= no_of_matches/min(result.no_data_img1, result.no_data_img2);


% getting rid of all the trivial values (no values); these are marked with
% z=0 in the XYZ file
function x= clean_xyz(x)
id0 = logical(x(:,3)==0);
x(id0,:) =[]; 

% A simple function that extracts the values from vectors v1 and v2 using
% the index vector id_all
function [u1, u2]= get_values(v1, v2, id_all)
 u1= v1(id_all);
 u2 = v2(id_all);


% Finding the index(es) when the difference below the default min values of x y z
function id_all = find_min_diffs(img1, img2, idx_img1_real,idx_img2_real, mm,  args)

diff_x = abs(img1(idx_img1_real(1:mm), 1)- img2(idx_img2_real(1:mm),1));
diff_y =  abs(img1(idx_img1_real(1:mm),2)- img2(idx_img2_real(1:mm),2));
diff_z =  abs(img1(idx_img1_real(1:mm),3)- img2(idx_img2_real(1:mm),3));

idz = logical(diff_z < args.z_min);
idx = logical(diff_x< args.x_min);
idy = logical(diff_y<args.y_min);
id_all = idx & idy & idz;



% Apply the sptial depth function to find f1 for bathy1 and f2 for bathy2
function result = process_data(x, args)
 
x(:,3) = abs(x(:,3));
f1 = round( (x(:,1).^args.m1).* ( x(:,2).^args.m1 ) .*x(:,3) );
f2 = round( (x(:,1).^args.m2).* ( x(:,2).^args.m2 ) .*x(:,3) );

[f1, idx] = sort(f1);
result.f1.values =f1;
result.f1.idx=idx;

 [f2, idx] = sort(f2);
result.f2.values =f2;
result.f2.idx=idx;


% A verification function that compares one matched pair value,
% between bathy1 and bathy2. Also displays the CPU elapsed time
function no_of_matches = verification(matches, img1, img2)
no_of_matches = length(matches.x_img1);
fprintf('CPU elapsed time is %.2f, Total number of matches %d \n', toc, no_of_matches);
if no_of_matches == 0
    return;
end
sel_id=1; % to get the positions of all the matches we need to do the intersection
idx1 = find(  (img1(:, 1)== matches.x_img1(sel_id)) & (img1(:, 2)== matches.y_img1(sel_id))  );
idx2 = find(  (img2(:, 1)== matches.x_img2(sel_id)) & (img2(:, 2)== matches.y_img2(sel_id))  );

for i= sel_id
    fprintf('The  match location in img1 is at %d with x,y,z %.2f %.2f %.2f \n', idx1(i), img1(idx1(i),1), img1(idx1(i), 2), img1(idx1(i), 3));
    fprintf('The  match location in img2 is at %d with x,y,z %.2f %.2f %.2f \n \n', idx2(i), img2(idx2(i),1), img2(idx2(i),2), img2(idx2(i), 3));
end


% A deprecated function
function img1_img2_intersection = intersect_positions(img1, img2)

d1={};
for i=1:length(img1)
    d2{i} = num2str([img1(i,1) img1(i,2)]);
end

d2={};
for i=1:length(img2)
    d2{i} = num2str([img2(i,1) img2(i,2)]);
end

img1_img2_intersection = intersect(d1, d2);

% Deprecated  code, to take into account shifting with respect to min
% value
% [x_ref, y_ref]= min_ref(img1, img2);
% img1(:,1) = img1(:,1)-x_ref;
% img2(:,1) = img2(:,1)-x_ref;
% 
% img1(:,2) = img1(:,2)-y_ref;
% img2(:,2) = img2(:,2)-y_ref;
