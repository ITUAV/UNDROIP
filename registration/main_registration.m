%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%     registration algorithm
%%%
%%% I. Leblond ECA Robotics march 2017
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Example:
%  main_registration('M3_L009', 'M3_L010')

function main_registration(file_name_tst, file_name_ref)
% file_name, is the name of the image

%% parameters
% data choice

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%                         PLOCAN
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% landmarks
%  loc_ldk='C:\Users\Swarms2\Documents\SWARMS\PROGRAMMES\pourDonnerSWARMS';
loc_ldk = 'C:\Users\Mohammed\Desktop\Swarms project\Sonar data and viewer\ECA data\ECA Registration test';

file_ldk_test= ['pos_landmk_' file_name_tst '.mat'];
file_ldk_ref= ['pos_landmk_' file_name_ref '.mat'];

%  sonar images
loc_im_test = 'C:\Users\Mohammed\Desktop\Swarms project\Sonar data and viewer\ECA data\ECA Registration test\ficMat'; % folder containing images and navigation files (in .mat)
loc_im_ref=loc_im_test;

file_im_test=[file_name_tst '_img.mat'];
file_im_ref=[file_name_ref '_img.mat'];

% navigation
% loc_nav_test='C:\Users\Swarms2\Documents\SWARMS\DATA\PLOCAN\dataMission\data_M-22-EW_bottom_tracked\ficMat';
loc_nav_test = loc_im_test;
loc_nav_ref = loc_nav_test;
file_nav_test=[ file_name_tst '_posXY'];
file_nav_ref=[ file_name_ref '_posXY'];

% specific parameters for each file
ratio_square=10; % ratio to have the same resolution between pings and samples
cut_im_test=1; % 0 if we take all reference image, 1 if it's cut
icrop_test=[1 500]; % cut in pings [] if all is taken
jcrop_test=[]; % cut in samples
cut_im_ref=1; % 0 if we take all reference image, 1 if it's cut
icrop_ref=[2000 2750]; % cut in pings [] if all is taken
jcrop_ref=[]; % cut in samples

% general parameters (generally, they don't need to be changed)
sigma=15; %sigma of the Gaussian for filtering

% maximal difference for research of matching landmarks
diff_tx_max=50; % let keep a large difference
diff_ty_max=diff_tx_max;
nb_test_min=40; % minimal number of test to realise
nb_test_max=50; % maximal  number of test to realise
prop_test=1/20 ; % or ratio on the total number of possibilities

% admissible differences between selected registrations
err_tx=20; % error for translation
err_ty=err_tx;

resol_across=1.2e-2; % across track resolution of  Klein 3500


%% loading landmarks positions

file_nav_test2 = [loc_nav_test,'\',file_nav_test];
file_nav_ref2 = [loc_nav_ref,'\',file_nav_ref];

file_im_test2 = [loc_im_test,'\',file_im_test];
file_im_ref2 = [loc_im_ref,'\',file_im_ref];

file_ldk_test2 = [loc_ldk,'\',file_ldk_test];
file_ldk_ref2 = [loc_ldk,'\',file_ldk_ref];

[imgtest_sonar, imgtest_ldk, imgref_sonar, imgref_ldk, indtest, indref, heading] =  loadParam_registration(file_ldk_test2, file_ldk_ref2, file_im_test2, file_im_ref2, file_nav_test2, file_nav_ref2, ratio_square, cut_im_test, icrop_test, jcrop_test, cut_im_ref, icrop_ref, jcrop_ref, resol_across);


%% adding patches around images to have no crop due to rotation or translation


temp=[size(imgtest_ldk) size(imgref_ldk)];

tmax=max(temp);

s_tot=2.*ceil(tmax.*sqrt(2));
x_mid=s_tot/2; % coordinates of the middle of new images
y_mid=x_mid;

% test image of landmarks

imgtest_old=imgtest_ldk;
x_mid_imtest= size(imgtest_old,1)/2; % coordinates of the middle of test images
y_mid_imtest=size(imgtest_old,2)/2;

ibegtest=floor(x_mid-x_mid_imtest)+1;
jbegtest=floor(y_mid-y_mid_imtest)+1;


imgtest_ldk=zeros(s_tot);
imgtest_ldk(ibegtest:ibegtest-1+size(imgtest_old,1),jbegtest:jbegtest-1+size(imgtest_old,2))=imgtest_old;



% ref image of landmarks
imgref_old=imgref_ldk;
x_mid_imref= size(imgtest_old,1)/2; % coordinates of the middle of ref images
y_mid_imref=size(imgtest_old,2)/2;

ibegref=floor(x_mid-x_mid_imref)+1;
jbegref=floor(y_mid-y_mid_imref)+1;
imgref_ldk=zeros(s_tot);
imgref_ldk(ibegref:ibegref-1+size(imgref_old,1),jbegref:jbegref-1+size(imgref_old,2))=imgref_old;



%  sonar images for final registration
imgtest_sonar_old=imgtest_sonar;
imgref_sonar_old=imgref_sonar;

imgtest_sonar=zeros(s_tot);
imgref_sonar=zeros(s_tot);

imgtest_sonar(ibegtest:ibegtest-1+size(imgtest_sonar_old,1),jbegtest:jbegtest-1+size(imgtest_sonar_old,2))=imgtest_sonar_old;
imgref_sonar(ibegref:ibegref-1+size(imgref_sonar_old,1),jbegref:jbegref-1+size(imgref_sonar_old,2))=imgref_sonar_old;


dimx=s_tot;
dimy=s_tot;



%% Gaussian filtering for correlations
im_test_ldk=imgaussfilt(imgtest_ldk,sigma);
im_ref_ldk=imgaussfilt(imgref_ldk,sigma);


%%  test of all translations

x_centre=size(imgtest_sonar_old,1)/2;
y_centre=size(imgtest_sonar_old,2)/2;

im_ref_init=im_ref_ldk;

% rotation of data
xrot=(indtest(:,1)-x_centre).*cos(heading/180*pi)-(indtest(:,2)-y_centre).*sin(heading/180*pi)+x_centre;
yrot=(indtest(:,1)-x_centre).*sin(heading/180*pi)+(indtest(:,2)-y_centre).*cos(heading/180*pi)+y_centre;

nb_pts_test=length(xrot);
nb_pts_ref=size(indref,1);


% estimation of all possible translations
tx_tot=(ones(nb_pts_test,1)*indref(:,1)')'-ones(nb_pts_ref,1)*xrot';
ty_tot=(ones(nb_pts_test,1)*indref(:,2)')'-ones(nb_pts_ref,1)*yrot';


[pos, space_param, crit]=estimate_trans(im_test_ldk, imgtest_sonar, im_ref_ldk, tx_tot, ty_tot, indref, indtest, diff_tx_max, diff_ty_max, nb_test_min, nb_test_max, heading);

%% post-processing

% extraction of best matchings

itemp=isnan(crit); % remove NaN
crit(itemp)=-1;
[crit_sort,I]=sort(crit,'descend');

ind=find(crit_sort>=(max(crit_sort)-std(crit_sort)));% best matchings

pos1=pos(I(ind),:);


space_param_OK=space_param(I(ind),:);

ang_mean=mean(space_param_OK(:,1));

% research if translations values are close to the others

delta_param=[abs(max(space_param_OK(:,1))-min(space_param_OK(:,1))) abs(max(space_param_OK(:,2))-min(space_param_OK(:,2))) abs(max(space_param_OK(:,3))-min(space_param_OK(:,3))) ];

if delta_param(2)<=err_tx && delta_param(3)<=err_ty
    
    % case one, values are consistent, translation are the average of the different values
    disp('Translation values are close to the others');
    disp('average values:');  
    
    tx_mean=mean(space_param_OK(:,2))    
    ty_mean=mean(space_param_OK(:,3))
    
    
else
    disp('Be carreful, there is at least one translation which is not consostent to the others');
    
    % case two, values are non all consistent. In this case, K first values are kept, and translation is the median value
    
    nb_val=min(length(I),nb_pts_test*(nb_pts_test-1)/2);
    ind_ref=I(1:nb_val);
    
    if length(ind)>length(ind_ref)
        % In an ideal case, there is ind_ref matched landmarks
        % If there is a number of kept registrations is over, there is probably a mistake, so, the first ind_ref values are kept
        ind=ind_ref;
        disp('kept values:');
        space_param_OK=space_param(ind,:)
        
    end
    
    tx_mean=median(space_param_OK(:,2))
    
    ty_mean=median(space_param_OK(:,3))
    
    
    
end




%% application of tranlation on sonar image and landmark image

im_reg_ldk=imageRegistration(im_test_ldk,ang_mean,tx_mean,ty_mean);

im_reg_sonar=imageRegistration(imgtest_sonar,ang_mean,tx_mean,ty_mean);

xrottrans=(indtest(:,1)-x_centre).*cos(heading/180*pi)-(indtest(:,2)-y_centre).*sin(heading/180*pi)+x_centre+tx_mean; %  rotation  and  translation of test data
yrottrans=(indtest(:,1)-x_centre).*sin(heading/180*pi)+(indtest(:,2)-y_centre).*cos(heading/180*pi)+y_centre+ty_mean;



%% figures



figure
plot(crit)
title('correlation on all possible translations')


% recalage between sonar images
val=mean(mean(imgref_sonar))*50;
val2=mean(mean(im_reg_sonar))*50;

nb_ping_imRef=size(imgref_sonar,1);
nb_echant_imRef=size(imgref_sonar,2);

nb_ping_imReg=size(im_reg_sonar,1);
nb_sample_imReg=size(im_reg_sonar,2);


im_final=zeros(dimx,dimy,3);
im_final(1:nb_ping_imReg,1:nb_sample_imReg,1)=im_reg_sonar./val2;
im_final(1:nb_ping_imRef,1:nb_echant_imRef,2)=imgref_sonar./val;
im_final(1:nb_ping_imReg,1:nb_sample_imReg,3)=im_reg_sonar./val2;
figure
imagesc(im_final)
title('Registered image (magenta) overprinted on reference image (green)')
axis image

figure
im_mean=mean(mean(im_reg_sonar));
im_reg_sonar2=im_reg_sonar./im_mean;
image(im_reg_sonar2)
colormap gray
title('Registered image')

figure
im_mean=mean(mean(imgref_sonar));
im_reg_sonar2=imgref_sonar./im_mean;
image(im_reg_sonar2)
colormap gray
title('Reference image')

%% landmarks on sonar images

% test image
im_temp=imgaussfilt(imgtest_old,sigma);
val=mean(mean(imgtest_sonar))*250;
val2=max(max(im_temp));
im_final=zeros(size(imgtest_sonar_old,1),size(imgtest_sonar_old,2),3);
im_final(:,:,1)=imgtest_sonar_old./val+im_temp(1:size(imgtest_sonar_old,1),1:size(imgtest_sonar_old,2))./val2;
im_final(:,:,2)=imgtest_sonar_old./val;
im_final(:,:,3)=imgtest_sonar_old./val+im_temp(1:size(imgtest_sonar_old,1),1:size(imgtest_sonar_old,2))./val2;
figure
imagesc(im_final)
title('landmarks on test image')
axis image

% ref image

im_temp=imgaussfilt(imgref_old,sigma);
val=mean(mean(imgtest_sonar))*100;
val2=max(max(im_temp));
im_final=zeros(size(imgref_sonar_old,1),size(imgref_sonar_old,2),3);
im_final(:,:,1)=imgref_sonar_old./val;
im_final(:,:,2)=imgref_sonar_old./val+im_temp(1:size(imgref_sonar_old,1),1:size(imgref_sonar_old,2))./val2;
im_final(:,:,3)=imgref_sonar_old./val;
figure
imagesc(im_final)
title('landmarks on reference image')
axis image



%% visualisation of matched landmarks
x_centre_test=size(imgtest_sonar,1)/2;
y_centre_test=size(imgtest_sonar,2)/2;

xrottest=((pos1(:,3)+ibegtest)-x_centre_test).*cos(heading/180*pi)-((pos1(:,4)+jbegtest)-y_centre_test).*sin(heading/180*pi)+x_centre_test; %  rotation  des données test
yrottest=((pos1(:,3)+ibegtest)-x_centre_test).*sin(heading/180*pi)+((pos1(:,4)+jbegtest)-y_centre_test).*cos(heading/180*pi)+y_centre_test;

temp2=imrotate(imgtest_sonar, ang_mean,'crop');
im_tot1=[imgref_sonar temp2];

temp=mean(im_tot1);

% images are cropped for more readibility
iii=find(temp(1:end-1)==0 & temp(2:end)~=0);
iii=iii+1;

jj=find(temp(1:end-1)~=0 & temp(2:end)==0);

temp=mean(im_tot1,2);

iii2=find(temp(1:end-1)==0 & temp(2:end)~=0);
iii2=iii2+1;

jj2=find(temp(1:end-1)~=0 & temp(2:end)==0);


im_tot=[im_tot1(iii2:jj2,iii(1):jj(1)) im_tot1(iii2:jj2,iii(2):jj(2))];


figure
WF_mean=mean(mean(im_tot));
WF2=im_tot./WF_mean.*16;
image(WF2)
colormap gray

hold on
for ii=1:size(pos1,1)
    pt_abs=[pos1(ii,2)+jbegref-iii(1)  yrottest(ii) + size(imgref_sonar,2)-iii(1)-(iii(2)-jj(1))];
    pt_ord=[pos1(ii,1)+ibegref-iii2 xrottest(ii)-iii2];
    plot(pt_abs,pt_ord,'c')
    
end
title ('matched landmarks')


