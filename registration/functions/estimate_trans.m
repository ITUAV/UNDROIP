function [pos, space_param, crit]=estimate_trans(im_test_ldk, imgtest_sonar, im_ref_ldk, tx_tot, ty_tot, indref, indtest, diff_tx_max, diff_ty_max, nb_test_min, nb_test_max, heading)

%%%%%%%%%%%%%%%%%%%
%
%  estimation of translation to register
%
% I. Leblond
%
%  ECA Robotics march 2017
%
%%%%%%%%%%%%%%%%%%%

% initialisation

crit=0;
counter=0;
pos=[];
space_param=[];

% extraction of linked landmarks

im_ref_init=im_ref_ldk; 


nb_pts_ref=size(tx_tot,1);
nb_pts_test=size(ty_tot,2);

nb_poss=nb_pts_ref*nb_pts_test;

h = waitbar(0,'Extraction of linked landmarks...');
counter_wb=0;

nb_ldk_linked=zeros(nb_poss,1);

for iref=1:nb_pts_ref
    for itest=1:nb_pts_test
        counter_wb=counter_wb+1;
        waitbar(counter_wb / nb_poss)
        
        % application of estimated values on images
        
        tx=tx_tot(iref,itest);
        ty=ty_tot(iref,itest);
        
        
        ind_ldk_linked=find((tx_tot<=tx+diff_tx_max) & (tx_tot>=tx-diff_tx_max) & (ty_tot<=ty+diff_ty_max) & (ty_tot>=ty-diff_ty_max) ); % number of linked landmarks
        
        counter=counter+1;
        nb_ldk_linked(counter)= length(ind_ldk_linked);
        
    end
end
close(h)


% correlations between the best linked landmarks


[ldk_sort,I]=sort(nb_ldk_linked,'descend');

temp=find(ldk_sort);
nb_ldk=length(temp); 


maxi=max(nb_test_min,floor(length(I)/20));
maxi2=min(maxi,nb_test_max);
maxi3=min(maxi2,nb_ldk);
mini=min(nb_poss,maxi3);


ind_totest=I(1:mini); % test of N best matching


h = waitbar(0,'Estimation of corrélations...');
counter_wb=0;
counter=0;

for iref=1:nb_pts_ref
    for itest=1:nb_pts_test
        counter_wb=counter_wb+1;
        waitbar(counter_wb / nb_poss)
        
        % application of translation values on image
        
        tx=tx_tot(iref,itest);
        ty=ty_tot(iref,itest);
        
        test=find(ind_totest==counter_wb);
        
        if ~isempty(test)
            
            % test of different registrations
            
            im_reg_ldk=imageRegistration(im_test_ldk,heading,tx,ty); 
            
            mask_corr=ones(size(im_reg_ldk));
            im_reg_sonar=imageRegistration(imgtest_sonar,heading,tx,ty);
            ind= find(im_reg_sonar==0);
            
            mask_corr(ind)=0;
            im_ref_ldk=im_ref_init.*mask_corr;
            
            counter=counter+1;
            
            
            % correlation is only made on a portion of reference image corresponding to test image
                        
            [indx,indy]=find(mask_corr);
            xmin=min(indx);
            xmax=max(indx);
            ymin=min(indy);
            ymax=max(indy);
            crit(counter)=corr2(im_ref_ldk(xmin:xmax,ymin:ymax),im_reg_ldk(xmin:xmax,ymin:ymax));
            pos=[pos; indref(iref,1) indref(iref,2) indtest(itest,1) indtest(itest,2) nb_ldk_linked(counter_wb) iref itest]; % positions of linked landmarks
            space_param=[space_param; heading tx ty]; %space of parameters
            
        end
        
        
        
    end
end

close(h)


