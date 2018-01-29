function result= sensor_altitude_vs_first_returns()


%  dir_in = 'C:\Users\Mohammed\Desktop\Swarms project\Sonar data and viewer\ECA data\Canaria Trials Sept 2016\M2'; % name of the directory that contains the images, change it to your directory
%  fname1 ={'M2_L005.xtf' 'M2_L006.xtf' 'M2_L007.xtf'  'M2_L008.xtf' ...
%  'M2_L009.xtf' 'M2_L010.xtf' 'M2_L011.xtf' 'M2_L012.xtf' 'M2_L013.xtf' ...
% 'M2_L014.xtf' 'M2_L015.xtf' 'M2_L016.xtf'};  % name of the XTF file you want to read
 
dir_in = 'C:\Users\Mohammed\Desktop\Swarms project\Sonar data and viewer\ECA data\Canaria Trials Sept 2016\M3'; % name of the directory that contains the images, change it to your directory
 fname1 ={'M3_L001.xtf' 'M3_L002.xtf' 'M3_L004.xtf' 'M3_L005.xtf' 'M3_L006.xtf' 'M3_L007.xtf'  'M3_L008.xtf' ...
 'M3_L009.xtf' 'M3_L010.xtf' 'M3_L011.xtf' 'M3_L012.xtf' 'M3_L013.xtf' 'M3_L014.xtf' };  % name of the XTF file you want to read

for i=1: length(fname1)
    [sss_data] = read_xtf_sonar_bath_eca(fname1{i}, dir_in, 'store_ping', false, 'has_bathy_image', true);   
    [cr1_L(i), cr2_L(i)] = do_it(sss_data.left, sss_data.posXY);
    [cr1_R(i), cr2_R(i)] = do_it(sss_data.right, sss_data.posXY);
    
end



disp('xxx');


function [ cr1, cr2, p1, p2] = do_it(img, posXY)



measured_returns = get_measured_nadir(posXY, 0.012);

% left 
edge_left = find_nadir_edge(img);
edge_left_2 = find_nadir_edge_v2(img);


[cr1, p1] = corrcoef(edge_left.edge, measured_returns);
cr1=cr1(1,2);
p1=p1(1,2);

[cr2, p2] = corrcoef(edge_left_2, measured_returns);
cr2=cr2(1,2);
p2=p2(1,2);


