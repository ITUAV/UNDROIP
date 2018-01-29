function result = find_all_landmarks

% for all images
 %dir_in = 'C:\Users\Mohammed\Desktop\Swarms project\Sonar data and viewer\ECA data\Canaria Trials Sept 2016\M2'; % name of the directory that contains the images, change it to your directory
 %fname ={'M2_L005.xtf', 'M2_L006.xtf', 'M2_L007.xtf', 'M2_L008.xtf', 'M2_L009.xtf', 'M2_L010.xtf', 'M2_L011.xtf', 'M2_L012.xtf', 'M2_L013.xtf', 'M2_L014.xtf', 'M2_L015.xtf', 'M2_L016.xtf'};
 
 dir_in = 'C:\Users\Mohammed\Desktop\Swarms project\Sonar data and viewer\ECA data\Canaria Trials Sept 2016\M3'; % name of the directory that contains the images, change it to your directory
 fname ={'M3_L001.xtf', 'M3_L002.xtf', 'M3_L004.xtf', 'M3_L005.xtf', 'M3_L006.xtf', 'M3_L007.xtf', 'M3_L008.xtf', 'M3_L009.xtf', 'M3_L010.xtf', 'M3_L011.xtf', 'M3_L012.xtf', 'M3_L013.xtf', 'M3_L014.xtf'};
  
 for i=1: length(fname)
     
     fprintf('processing %s', fname{i});
     [sss_data] = read_xtf_sonar_bath_eca(fname{i}, dir_in, 'store_ping', false, 'has_bathy_image', true);
     nadir_edge = get_measured_nadir(sss_data.posXY, 0.012);   
     
        
     landmarks_left= landmark_detection(sss_data.left, nadir_edge);
     result.n_pksL(i)= landmarks_left.peaks.number_of_peaks_or_shadows;
     result.n_shadL(i)= landmarks_left.shadows.number_of_peaks_or_shadows;
     result.n_pks_allE_L(i)= length( landmarks_left.peaks.all_E);
     result.n_shad_allE_L(i)= length( landmarks_left.shadows.all_E);
    
     landmarks_right = landmark_detection(sss_data.right, nadir_edge);     
     result.n_shadR(i)= landmarks_right.shadows.number_of_peaks_or_shadows;
     result.n_pksR(i)= landmarks_right.peaks.number_of_peaks_or_shadows;
     result.n_pks_allE_R(i)= length( landmarks_right.peaks.all_E);
     result.n_shad_allE_R(i)= length( landmarks_right.shadows.all_E);
     
 end
 
  
  