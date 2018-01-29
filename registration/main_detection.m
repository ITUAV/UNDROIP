%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% main code for landmark detection
%%%
%%%
%%% I. Leblond
%%%                 
%%%     ECA Robotics march 2017
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
function main_detection(file_name)


%% parameters

%  sonar parameters
hmin=20; %  minimal height of the object in samples
resol_across=1.2e-2; % across track resolution of  Klein 3500

% mission specific parameters
% %  PLOCAN
%%%%%%%%%%%

loc='C:\Users\Mohammed\Desktop\Swarms project\Sonar data and viewer\ECA data\ECA Registration test\ficMat'; % folder containing images and navigation files (in .mat)
%fic='M-22-EW_L009_img'; file_nav='M-22-EW_L009_posXY.mat';  suffix_save='M-22-EW_L009'; % name of the sonar data (* _img.mat) and navigation file (*_posXY.mat). Suffix for saving data
 fic= [file_name '_img']; file_nav=[file_name '_posXY.mat'];  suffix_save= file_name; % name of the sonar data (* _img.mat) and navigation file (*_posXY.mat). Suffix for saving data

loc_save=pwd; % location of the save
sizeMinS=10; % minimal and maximal size of the bounding boxes across track for shadow detection
sizeMaxS=50;
Area_minS=60; % minimal area near the sonar
Ex_min=0.3; % maximal extension of the shadow
fact_thresS=1/2; % factor for thresholding shadows (proportionnal to the average luminance)
offset=10; % with Hwater='auto2', the offset is recommanded because bottom tracking is overestimated
sigmaS=1; % width of the Gaussian for blurring shadows
n_sample_down=700; % number of sample removed at end of range (because of noise)

% general parameters
d_obj_min=250; % minimal distance of shadow from the bottom in samples (reference)
ratio_max=1.01; % ratio between filled area and shadow area
save('param.mat')

% loading data
% loading sonar images
temp=load([loc '\' fic]);
temp2=fieldnames(temp);
temp3=['WF=temp.',char(temp2(1)),';'];
eval(temp3);
load([loc,'\',file_nav]);
Hwater_meter=posXY(:,4); % water height in meters
Hwater_sample = round(Hwater_meter./resol_across) - offset; % water height in samples

%  TVG filtering
WFtvg = TVG_filter(WF);
WF=WFtvg;

%% shadow segmentation
WF2=imgaussfilt(WF,sigmaS); % Gaussian filtering for blurring
thresS=mean2(WF2(:,1:3000)).*fact_thresS;  % shadow thresholding

% portside image
WF2_p = WF2(:,1:size(WF2,2)./2); % left image?
imgS_p=segment_shadow_p(WF2_p,thresS,sizeMinS,sizeMaxS,Area_minS,Ex_min,ratio_max,Hwater_sample,hmin,d_obj_min);

% starboard image
WF2_s = WF2(:,size(WF2,2)./2+1:end);
imgS_s=segment_shadow_s(WF2_s,thresS,sizeMinS,sizeMaxS,Area_minS,Ex_min,ratio_max,Hwater_sample,hmin,d_obj_min);

% concatenation
imgS=[imgS_p imgS_s];

%% set up of data
% working portside / starboard

% portside image
imgS_p=imgS(:,1:size(imgS,2)./2); 
[imgS_p2,pos_landmk_p]=setupLandmark_p(imgS_p);

% starboard image
imgS_s=imgS(:,size(imgS,2)./2+1:end); 
[imgS_s2,pos_landmk_s]=setupLandmark_s(imgS_s);

%% removing of the water column and the end of range
% definition of a mask
n_sample_water=Hwater_sample;
img_mask=ones(size(WF));
img_mask(:,1:n_sample_down)=0;
img_mask(:,end-n_sample_down+1:end)=0;
e_mil=size(img_mask,2)/2; % sample of the middle

for ii=1:length(n_sample_water)
    img_mask(ii,e_mil-n_sample_water(ii):e_mil+n_sample_water(ii))=0;
    
end

mask_p=img_mask(:,1:size(WF,2)./2);
mask_s=img_mask(:,size(WF,2)./2+1:end);

% selection of landmarks inside the mask
[pos_landmk_s2,imgS_s3]=cleanLandmarkMask(mask_s,imgS_s2,pos_landmk_s);
[pos_landmk_p2,imgS_p3]=cleanLandmarkMask(mask_p,imgS_p2,pos_landmk_p);
pos_landmk_temp=pos_landmk_s2;
pos_landmk_temp(:,2)=pos_landmk_temp(:,2)+size(imgS_p3,2);
pos_landmk2=[pos_landmk_p2; pos_landmk_temp]; % position of landmark in global image
imgS_2=[imgS_p3 imgS_s3];


% figures
Lfin=bwlabel(imgS_2);
val=mean(mean(WF)).*5;
im_final=zeros(size(WF,1),size(WF,2),3);
im_final(:,:,1)=WF./val;
im_final(:,:,2)=WF./val+(WF.*imgS_2)*2;
im_final(:,:,3)=WF./val;
figure
imagesc(im_final)
title('extracted shadows overprinted on the image')


% conservation of landmark images in a matrix with the same dimensions of sonar image
img_landmk=zeros(size(WF));
for ii=1:size(pos_landmk2,1)
    img_landmk(pos_landmk2(ii,1),pos_landmk2(ii,2))=1;
end
img_landmk=imgaussfilt(img_landmk,3);


%% saving
pos_landmk_s =pos_landmk_s2;
pos_landmk_p = pos_landmk_p2;
imgS_s = imgS_s3;
imgS_p = imgS_p3;

fileSave=[loc_save, '\pos_landmk_',suffix_save,'.mat']; % file of localisation of landmarks
file_img_landmk=[loc_save, '\img_landmk_',suffix_save,'.mat']; % file of images of landmarks

save(fileSave,'pos_landmk_s','pos_landmk_p','imgS_s','imgS_p')
save(file_img_landmk, 'img_landmk');




