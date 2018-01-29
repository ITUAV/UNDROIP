function nadir_edge = get_measured_nadir(posXY, resol_across)

% resol_across=1.2e-2; % across track resolution of  Klein 3500

nadir_edge = round(posXY(:,4)./resol_across); % samples corresponding to water column

% WF=[WF_old(:,1:size(WF_old,2)/2 - sample_water_test)  WF_old(:,size(WF_old,2)/2+sample_water_test:end)]; % cut water column
% imgtest_sonar=WF(:,1:ratio_square:end); % to have the same resolution along and across


% load(file_im_ref);
% WF_old=WF;

% sample_water_ref = find_water_column(WF);  no such a function
% sample_water_ref = round(posXY_ref(:,4)./resol_across); % samples corresponding to water column, added by Rawi

%WF = [WF_old(:,1:size(WF_old,2)/2 - sample_water_ref)  WF_old(:,size(WF_old,2)/2+sample_water_ref:end)]; % cut water column
% imgref_sonar = WF(:,1:ratio_square:end);