function  [imgtest_sonar, imgtest_ldk, imgref_sonar, imgref_ldk, indtest, indref, heading] =  loadParam_registration(file_ldk_test, file_ldk_ref, file_im_test, file_im_ref, file_nav_test, file_nav_ref, ratio_square, cut_im_test, icrop_test, jcrop_test, cut_im_ref, icrop_ref, jcrop_ref, resol_across)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% loading parameters for registration
%%%
%%% I. Leblond
%%%
%%% ECA Robotics march 2017
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%% loading data

% navigation

load(file_nav_test);
posXY_test = posXY;

load(file_nav_ref);
posXY_ref = posXY;


% loading sonar images
load(file_im_test);
WF_old=WF;

sample_water_test = round(posXY_test(:,4)./resol_across); % samples corresponding to water column

WF=[WF_old(:,1:size(WF_old,2)/2 - sample_water_test)  WF_old(:,size(WF_old,2)/2+sample_water_test:end)]; % cut water column
imgtest_sonar=WF(:,1:ratio_square:end); % to have the same resolution along and across


load(file_im_ref);
WF_old=WF;

% sample_water_ref = find_water_column(WF);  no such a function

sample_water_ref = round(posXY_ref(:,4)./resol_across); % samples corresponding to water column, added by Rawi

WF=[WF_old(:,1:size(WF_old,2)/2 - sample_water_ref)  WF_old(:,size(WF_old,2)/2+sample_water_ref:end)]; % cut water column
imgref_sonar=WF(:,1:ratio_square:end);

% loading landmarks

load(file_ldk_test);
sample_water_test_ldk = sample_water_test (pos_landmk_s(:,1));
pos_landmk_s(:,2)=pos_landmk_s(:,2)+size(imgS_s,2)-2.*sample_water_test_ldk; % concatenation portside / starboard
ind_test=[pos_landmk_p(:,1:2);pos_landmk_s(:,1:2)];
ind_test(:,2)=floor(ind_test(:,2)./ratio_square); % to have the same resolution along and across


load(file_ldk_ref);
sample_water_ref_ldk = sample_water_ref (pos_landmk_s(:,1));
pos_landmk_s(:,2)=pos_landmk_s(:,2)+size(imgS_s,2)-2.*sample_water_ref_ldk; % concatenation portside / starboard

ind_ref=[pos_landmk_p(:,1:2);pos_landmk_s(:,1:2)];
ind_ref(:,2)=floor(ind_ref(:,2)./ratio_square);  % to have the same resolution along and across




%% if test or ref image is cut


if cut_im_ref==1
    
    % indices of landmarks are removed to correspond to the new image
    
    if isempty(icrop_ref)
        icrop_ref(1)=1;
        icrop_ref(2)=size(imgref_sonar,1);
    end
    
    if isempty(jcrop_ref)
        jcrop_ref(1)=1;
        jcrop_ref(2)=size(imgref_sonar,2);
        
    end
    
    
    ind_ref_old=ind_ref;
    
    ind=find(ind_ref_old(:,1)<icrop_ref(1) | ind_ref_old(:,1)>icrop_ref(2));
    
    ind_ref(ind,:)=[];
    
    ind=find(ind_ref(:,2)<jcrop_ref(1) | ind_ref(:,2)>jcrop_ref(2));
    
    ind_ref(ind,:)=[];
    
    ind_ref(:,1)=ind_ref(:,1)-icrop_ref(1);
    ind_ref(:,2)=ind_ref(:,2)-jcrop_ref(1);
    
    % images
    
    imgref_sonar=imgref_sonar(icrop_ref(1):icrop_ref(2),jcrop_ref(1):jcrop_ref(2));
    
    % heading
    
    heading_ref=mean(posXY_ref(icrop_ref(1):icrop_ref(2),3));
    
    
else
    
    heading_ref=mean(posXY_ref(:,3));
    
    
end


if cut_im_test==1
    
    % indices of landmarks are removed to correspond to the new image
    
    if isempty(icrop_test)
        icrop_test(1)=1;
        icrop_test(2)=size(imgtest_sonar,1);
    end
    
    if isempty(jcrop_test)
        jcrop_test(1)=1;
        jcrop_test(2)=size(imgtest_sonar,2);
        
    end
    
    
    ind_test_old=ind_test;
    
    ind=find(ind_test_old(:,1)<icrop_test(1) | ind_test_old(:,1)>icrop_test(2));
    
    ind_test(ind,:)=[];
    
    ind=find(ind_test(:,2)<jcrop_test(1) | ind_test(:,2)>jcrop_test(2));
    
    ind_test(ind,:)=[];
    
    ind_test(:,1)=ind_test(:,1)-icrop_test(1);
    ind_test(:,2)=ind_test(:,2)-jcrop_test(1);
    
    
    % image
    imgtest_sonar=imgtest_sonar(icrop_test(1):icrop_test(2),jcrop_test(1):jcrop_test(2));
    
    % heading
    heading_test=mean(posXY_test(icrop_test(1):icrop_test(2),3)); 
    
else
    
    
    heading_test=mean(posXY_test(:,3)); 
    
    
end

heading=heading_test-heading_ref; % taken the difference in this side, we are sure that we are in counter-clock wise



%% images of landmarks

%test image

imgtest_ldk=zeros(size(imgtest_sonar));


ind_testx=max(1,ind_test(:,1));
ind_testy=max(1,ind_test(:,2));

indtest=[ind_testx ind_testy];


for ii=1:length(ind_test)
    
    imgtest_ldk(ind_testx(ii),ind_testy(ii))=1;
    
end


% ref image
imgref_ldk=zeros(size(imgref_sonar));


ind_refx=max(1,ind_ref(:,1));
ind_refy=max(1,ind_ref(:,2));

indref=[ind_refx ind_refy];

for ii=1:length(ind_ref)
    
    imgref_ldk(ind_refx(ii),ind_refy(ii))=1;
    
end



